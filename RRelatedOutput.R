##########Library import
library("ape")
library("phyloseq")
library("ggplot2")
library("gplots")

args <- commandArgs(trailingOnly = TRUE)

##########Data import
#txt = "/Users/chengguo/Desktop/Hengchuang/M231/exported/feature-table.ConsensusLineage.txt"
#tre = "/Users/chengguo/Desktop/Hengchuang/M231/exported/tree.rooted.nwk"
#rs = "/Users/chengguo/Desktop/Hengchuang/M231/exported/dna-sequences.fasta"
map = args[1]
category1 = args[2]

#category1 = "SampleType"
#map = "~/Desktop/Hengchuang/M122/M122_Mapping.tsv"

#category1 = "Group1"
#map = "/Users/chengguo/Desktop/Hengchuang/M231/M231_Mapping_2.tsv"


this.dir <- dirname(parent.frame(2)$map)
new.dir <- paste(this.dir, "/R_output", sep="")
setwd(new.dir)

txt = paste(this.dir, "/exported/feature-table.ConsensusLineage.txt", sep="")
tre = paste(this.dir, "/exported/tree.rooted.nwk", sep="")
rs = paste(this.dir, "/exported/dna-sequences.fasta", sep="")

print("#Start reading realted files with Phyloseq")
print(map)
print(txt)
print(tre)
print(rs)

qiimedata = import_qiime(txt, map, tre, rs)

gpt <- subset_taxa(qiimedata, Kingdom=="Bacteria")
gpt <- prune_taxa(names(sort(taxa_sums(gpt),TRUE)[1:200]), gpt)
gpt <- prune_taxa(names(sort(taxa_sums(gpt),TRUE)), gpt)

head(tax_table(gpt)[,2])

print("#Generate phylogenetic trees for common phylums")
for (selected_phylum in c('Bacteroidetes','Firmicutes','Proteobacteria')){
  print(paste("Making tree plots for", selected_phylum, sep=" "))
  GP.chl <- subset_taxa(gpt, Phylum==selected_phylum)
  phylogeny_outputpdfname <- paste(selected_phylum, ".phylogeny.pdf", sep="")
  pdf( phylogeny_outputpdfname, width=12, height=14)
  plot<-plot_tree(GP.chl, color="Group1", shape="Family", label.tips="Genus", size="abundance", plot.margin=0.1, base.spacing=0.04, ladderize=TRUE, nodelabf=nodeplotblank)
  print(plot+ ggtitle(selected_phylum))
  dev.off()
}

pdf("Bacteria.phylogeny.pdf", width=12, height=14)
plot<-plot_tree(gpt, color="Group1", shape="Phylum", label.tips="Family", size="abundance", text.size=2, plot.margin=0.1, base.spacing=0.04, ladderize=TRUE, nodelabf=nodeplotblank)
print(plot + ggtitle("Bacteria"))
dev.off()

print("#Generate the NMDS plot for betadiversity")
for (distance_matrix in c('bray', 'unifrac', 'jaccard', 'wunifrac')){
  GP.ord <- ordinate(gpt, "NMDS", distance_matrix)
  NMDS_outputpdfname <- paste(distance_matrix, "_NMDS.pdf", sep="")
  pdf(NMDS_outputpdfname, width=10, height=12)
  p2 = plot_ordination(gpt, GP.ord, type="samples", color=category1) 
  p3 = p2  + geom_point(size=5) + geom_text(aes(label=Description),hjust=0, vjust=2)
  print(p3 + ggtitle(distance_matrix))
  dev.off()
}

print("#calculate distance")
for (distance_matrix in c('bray', 'unifrac', 'jaccard', 'wunifrac')){
  beta_heatmap_outputpdfname <- paste(distance_matrix, "_betadiversity_heatmap.pdf", sep="")
  pdf(beta_heatmap_outputpdfname)
  Dist <- distance(qiimedata, method=distance_matrix)
  heatmap.2(as.matrix(Dist), main=distance_matrix)
  dev.off()
  beta_outputtxtname <- paste(distance_matrix, "_matrix.txt", sep="")
  write.table(as.matrix(Dist), beta_outputtxtname , quote=FALSE, col.names=NA, sep="\t")
}

