#/bin/sh -S

#########
#Please address any bugs to Cheng. 
#Date 2017.12.19
#########
mapping_file=$1
category_1=$2
READMEORIGINALPATH=$3

if [ -z "$3" ]; then
	echo "##########

		  Please prepare the directory structure before starting the program like below:
		  raw/fastq_files ...
		  mapping_file
		  manifest_file
		  \n\n"

	echo "Please provide following input parameters
		1) Full path of the mapping file. (Accept both .csv or txt format.)
		2) The name of the first category in the mapping file. 

		Sample Usage:
		sh $0 M231_Mapping_2.tsv Group1 readme.pdf
		"
	exit 0
else
	echo "################
	Running: sh $0 $1 $2 $3"
fi

check_file() {
	echo "Checking file for $1 ..."
	file_name=$1
	if [ -f $file_name ]; then
		echo "File $file_name exists"
	else
		echo "File $file_name does not exist"
		exit
	fi
}

organize_deliverable_structure() {

	group_1=$1 

	echo "Start organize the files for deliverables ..."
	
	cp $READMEORIGINALPATH ./Result_AmpliconSequencing/
	cp $mapping_file ./Result_AmpliconSequencing/

	cp -r demux.qzv* stats-dada2.qzv* ./Result_AmpliconSequencing/1-QCStats/

	cp -r exported/feature-table.taxonomy.* exported/Relative/Classified_stat_relative* ./Result_AmpliconSequencing/2-OTUAnalysis/1-OTUSummary/1-OTUTable/
	cp -r exported/Relative/otu_table.even.txt ./Result_AmpliconSequencing/2-OTUAnalysis/1-OTUSummary/1-OTUTable/feature-table.taxonomy.even.txt

	cp exported/Absolute/otu_table.p.absolute.mat ./Result_AmpliconSequencing/2-OTUAnalysis/1-OTUSummary/1-OTUTable/1-Absolute/feature-table.Phylum.absolute.txt
	cp exported/Absolute/otu_table.c.absolute.mat ./Result_AmpliconSequencing/2-OTUAnalysis/1-OTUSummary/1-OTUTable/1-Absolute/feature-table.Class.absolute.txt
	cp exported/Absolute/otu_table.o.absolute.mat ./Result_AmpliconSequencing/2-OTUAnalysis/1-OTUSummary/1-OTUTable/1-Absolute/feature-table.Order.absolute.txt
	cp exported/Absolute/otu_table.f.absolute.mat ./Result_AmpliconSequencing/2-OTUAnalysis/1-OTUSummary/1-OTUTable/1-Absolute/feature-table.Family.absolute.txt
	cp exported/Absolute/otu_table.g.absolute.mat ./Result_AmpliconSequencing/2-OTUAnalysis/1-OTUSummary/1-OTUTable/1-Absolute/feature-table.Genus.absolute.txt
	cp exported/Absolute/otu_table.s.absolute.mat ./Result_AmpliconSequencing/2-OTUAnalysis/1-OTUSummary/1-OTUTable/1-Absolute/feature-table.Species.absolute.txt

	cp exported/Relative/otu_table.p.relative.mat ./Result_AmpliconSequencing/2-OTUAnalysis/1-OTUSummary/1-OTUTable/2-Relative/feature-table.Phylum.relative.txt
	cp exported/Relative/otu_table.c.relative.mat ./Result_AmpliconSequencing/2-OTUAnalysis/1-OTUSummary/1-OTUTable/2-Relative/feature-table.Class.relative.txt
	cp exported/Relative/otu_table.o.relative.mat ./Result_AmpliconSequencing/2-OTUAnalysis/1-OTUSummary/1-OTUTable/2-Relative/feature-table.Order.relative.txt
	cp exported/Relative/otu_table.f.relative.mat ./Result_AmpliconSequencing/2-OTUAnalysis/1-OTUSummary/1-OTUTable/2-Relative/feature-table.Family.relative.txt
	cp exported/Relative/otu_table.g.relative.mat ./Result_AmpliconSequencing/2-OTUAnalysis/1-OTUSummary/1-OTUTable/2-Relative/feature-table.Genus.relative.txt
	cp exported/Relative/otu_table.s.relative.mat ./Result_AmpliconSequencing/2-OTUAnalysis/1-OTUSummary/1-OTUTable/2-Relative/feature-table.Species.relative.txt

	cp -r exported/collapsed/*qzv* ./Result_AmpliconSequencing/2-OTUAnalysis/1-OTUSummary/1-OTUTable/3-CollapsedStats/

	cp -r ./rep-seqs.* ./*tree* ./Result_AmpliconSequencing/2-OTUAnalysis/1-OTUSummary/2-RepresentiveSequence/

	cp -r taxa-bar-plots.qzv* ./Result_AmpliconSequencing/2-OTUAnalysis/1-OTUSummary/3-Barplots/

	cp -r exported/1000/*.qzv* ./Result_AmpliconSequencing/2-OTUAnalysis/1-OTUSummary/4-Heatmaps/

	cp -r exported/ANCOM/*.qzv* ./Result_AmpliconSequencing/2-OTUAnalysis/2-OTUDifferentialAnalysis/1-ANCOM/

	cp -r exported/DiffOTU/ANOVA_Group1*txt ./Result_AmpliconSequencing/2-OTUAnalysis/2-OTUDifferentialAnalysis/2-ANOVA/

	cp -r exported/DiffOTU/kruskal_wallis_Group1*txt ./Result_AmpliconSequencing/2-OTUAnalysis/2-OTUDifferentialAnalysis/3-KruskalWallis/

	##cp lefse result ./Result_AmpliconSequencing/2-OTUAnalysis/2-OTUDifferentialAnalysis/4-LEfSe/

	cp -r alpha/alpha-summary.tsv R_output/alpha_diversity_* ./Result_AmpliconSequencing/3-AlphaDiversity/1-AlphaDiversitySummary/

	cp -r alpha-rarefaction.qzv* ./Result_AmpliconSequencing/3-AlphaDiversity/2-AlphaRarefaction/

	cp -r core-metrics-results/*observed* ./Result_AmpliconSequencing/3-AlphaDiversity/3-ObservedOTUs/

	cp -r core-metrics-results/*shannon*  ./Result_AmpliconSequencing/3-AlphaDiversity/4-Shannon/

	cp -r core-metrics-results/*faith* ./Result_AmpliconSequencing/3-AlphaDiversity/5-FaithPD/

	cp -r R_output/*matrix.txt R_output/BetaDiversity_heatmap.* ./Result_AmpliconSequencing/4-BetaDiversity/1-BetaDiversitySummary/

	cp -r R_output/bray*heatmap.pdf R_output/bray*txt ./Result_AmpliconSequencing/4-BetaDiversity/2-BrayCurtis/
	cp -r core-metrics-results/bray*_emperor.qzv* ./Result_AmpliconSequencing/4-BetaDiversity/2-BrayCurtis/1-PCoA/
	cp -r R_output/bray*NMDS* ./Result_AmpliconSequencing/4-BetaDiversity/2-BrayCurtis/2-NMDS/
	cp -r core-metrics-results/bray*significance.qzv* ./Result_AmpliconSequencing/4-BetaDiversity/2-BrayCurtis/3-GroupSignificance/

	cp -r R_output/unifrac*heatmap.pdf R_output/unifrac*txt ./Result_AmpliconSequencing/4-BetaDiversity/3-UnweightedUnifrac/
	cp -r core-metrics-results/unweighted*_emperor.qzv* ./Result_AmpliconSequencing/4-BetaDiversity/3-UnweightedUnifrac/1-PCoA/
	cp -r R_output/unifrac*NMDS* ./Result_AmpliconSequencing/4-BetaDiversity/3-UnweightedUnifrac/2-NMDS/
	cp -r core-metrics-results/unweighted*significance.qzv* ./Result_AmpliconSequencing/4-BetaDiversity/3-UnweightedUnifrac/3-GroupSignificance/

	cp -r R_output/wunifrac*heatmap.pdf R_output/wunifrac*txt ./Result_AmpliconSequencing/4-BetaDiversity/4-WeightedUnifrac/
	cp -r core-metrics-results/weighted*_emperor.qzv* ./Result_AmpliconSequencing/4-BetaDiversity/4-WeightedUnifrac/1-PCoA/
	cp -r R_output/wunifrac*NMDS* ./Result_AmpliconSequencing/4-BetaDiversity/4-WeightedUnifrac/2-NMDS/
	cp -r core-metrics-results/weighted*significance.qzv* ./Result_AmpliconSequencing/4-BetaDiversity/4-WeightedUnifrac/3-GroupSignificance/

	cp -r R_output/PLSDA* ./Result_AmpliconSequencing/4-BetaDiversity/5-PLS-DA/

	cp -r R_output/*phylogeny.pdf ./Result_AmpliconSequencing/5-OTUPhylogenetics/1-MajorPhylums/

	cp -r phylogeny/tol_* phylogeny/tree.rooted.nwk ./Result_AmpliconSequencing/5-OTUPhylogenetics/2-MajorOTUs/

	cp -r exported/Absolute/p.rda.pdf ./Result_AmpliconSequencing/6-AssociationAnalysis/1-RDA/Phylum.rda.pdf
	cp -r exported/Absolute/c.rda.pdf ./Result_AmpliconSequencing/6-AssociationAnalysis/1-RDA/Class.rda.pdf
	cp -r exported/Absolute/o.rda.pdf ./Result_AmpliconSequencing/6-AssociationAnalysis/1-RDA/Order.rda.pdf
	cp -r exported/Absolute/f.rda.pdf ./Result_AmpliconSequencing/6-AssociationAnalysis/1-RDA/Family.rda.pdf
	cp -r exported/Absolute/g.rda.pdf ./Result_AmpliconSequencing/6-AssociationAnalysis/1-RDA/Genus.rda.pdf
	cp -r exported/Absolute/s.rda.pdf ./Result_AmpliconSequencing/6-AssociationAnalysis/1-RDA/Species.rda.pdf

	#cp -r /Result_AmpliconSequencing/6-AssociationAnalysis

	cp -r closedRef_forPICRUSt/feature-table.metagenome* closedRef_forPICRUSt/percent.feature-table.metagenome*svg* ./Result_AmpliconSequencing/7-FunctionAnalysis/1-KEGG_Pathway/

	cp -r closedRef_forPICRUSt/PCA* ./Result_AmpliconSequencing/7-FunctionAnalysis/2-PCAPlots/
	rm ./Result_AmpliconSequencing/7-FunctionAnalysis/2-PCAPlots/PCA*/PCA.R ./Result_AmpliconSequencing/7-FunctionAnalysis/2-PCAPlots/PCA*/Rplots.pdf

	cp -r closedRef_forPICRUSt/tree* ./Result_AmpliconSequencing/7-FunctionAnalysis/3-TreeBasedPlots/

	#######################For 8-FiguresTablesForReport
	cd ./Result_AmpliconSequencing/8-FiguresTablesForReport

	ln -s ../2-OTUDifferentialAnalysis/1-ANCOM/ANCOM.Species.qzv Table3-1.qzv
	ln -s ../2-OTUAnalysis/1-OTUSummary/1-OTUTable/3-CollapsedStats/table-Species.qzv  Table3-2.qzv
	ln -s ../3-AlphaDiversity/1-AlphaDiversitySummary/alpha-summary.tsv Table3-3.tsv
	ln -s ../3-AlphaDiversity/4-Shannon/shannon-group-significance.qzv Table3-4.qzv
	ln -s ../4-BetaDiversity/3-UnweightedUnifrac/unweighted-unifrac-permanova-${group_1}-significance.qzv Table3-5.qzv
		
	ln -s ../2-OTUAnalysis/1-OTUSummary/1-OTUTable/Classified_stat_relative.png Figure3-1.png
	ln -s ../2-OTUAnalysis/1-OTUSummary/3-Barplots/taxa-bar-plots.qzv Figure3-2.qzv
	ln -s ../2-OTUAnalysis/1-OTUSummary/4-Heatmaps/table-Phylum.1000.qzv Figure3-3.qzv
	ln -s ../2-OTUDifferentialAnalysis/1-ANCOM/ANCOM.Species.qzv Figure3-4.qzv
	ln -s ../3-AlphaDiversity/2-AlphaRarefaction/alpha-rarefaction.qzv Figure3-6.qzv
	ln -s ../3-AlphaDiversity/4-Shannon/shannon-group-significance.qzv Figure3-7.qzv
	ln -s ../4-BetaDiversity/1-BetaDiversitySummary/BetaDiversity_heatmap.png Figure3-8.png
	ln -s ../4-BetaDiversity/3-UnweightedUnifrac/1-PCoA/unweighted_unifrac_emperor.qzv Figure3-9.qzv
	ln -s ../4-BetaDiversity/unifrac_NMDS.pdf Figure3-10.pdf
	ln -s ../4-BetaDiversity/3-UnweightedUnifrac/3-GroupSignificance/unweighted-unifrac-permanova-${group_1}-significance.qzv Figure3-11.qzv
	ln -s ../5-OTUPhylogenetics/1-MajorPhylums/Bacteria.phylogeny.pdf Figure3-12.pdf
	ln -s ../6-AssociationAnalysis/1-RDA/Phylum.rda.pdf Figure3-14.pdf
	ln -s ../6-AssociationAnalysis/permanova.pdf Figure3-15.pdf
	ln -s ../7-FunctionAnalysis/1-KEGG_Pathway/percent.feature-table.metagenome.L1.svg.png Figure3-18.png
	ln -s ../7-FunctionAnalysis/2-PCAPlots/PCA_L1/PCA-2D.pdf Figure3-19.pdf
	ln -s ../7-FunctionAnalysis/3-TreeBasedPlots/tree.feature-table.metagenome.L1.svg.png Figure3-20.png

}

MAIN() {

	echo "##############################################################\n#Organize the Result folder"
	organize_deliverable_structure $category_1

<<COMMENT1
	echo "##############################################################\n#Organize the Essential folder ----- part1"
	mkdir Essential
	mkdir Essential/1-Demux/ Essential/2-OTUAnalysis/ Essential/3-AlphaDiversity Essential/4-BetaDiversity
	mkdir Essential/2-OTUAnalysis/OTUSummary Essential/2-OTUAnalysis/OTUDifferentialAnalysis Essential/2-OTUAnalysis/OTUSummary/Heatmap Essential/2-OTUAnalysis/OTUDifferentialAnalysis/ANCOM
	cp -r demux.qzv.exported Essential/1-Demux/
	cp -r taxa-bar-plots.qzv.exported Essential/2-OTUAnalysis/OTUSummary/
	cp exported/feature-table.taxonomy.txt Essential/2-OTUAnalysis/OTUSummary/
	cp -r exported/Relative Essential/2-OTUAnalysis/OTUSummary/
	cp -r exported/exported/1000/table-l2.1000 exported/exported/1000/table-l6.1000 Essential/2-OTUTable/Heatmap
	cp -r exported/ANCOM/ANCOM.l2.qzv.exported Essential/2-OTUAnalysis/OTUDifferentialAnalysis/ANCOM/phylum
	cp -r exported/ANCOM/ANCOM.l6.qzv.exported Essential/2-OTUAnalysis/OTUDifferentialAnalysis/ANCOM/genus
	cp exported/kruskal_wallis* exported/ANOVA* Essential/2-OTUAnalysis/OTUDifferentialAnalysis
	cp alpha/alpha-summary.tsv Essential/3-AlphaDiversity
	cp R_output/bray_matrix.txt R_output/wunifrac_matrix.txt R_output/unifrac_matrix.txt R_output/*unifrac_NMDS.pdf R_output/bray_NMDS.pdf R_output/P*_plot.pdf Essential/4-BetaDiversity/

	cp -r Essential Result
COMMENT1
}

MAIN;