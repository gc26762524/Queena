#/bin/sh -S

#########
#Please address any bugs to Cheng. 
#Date 2017.12.19
#########
mapping_file=$1
depth=$2
min_freq=$3
category_1=$4
category_2=$5
category_3=$6
reference_trained=$7
close_reference_trained=$8
manifest_file=$9

if [ -z "$9" ]; then
	echo "##########

		  Please prepare the directory structure before starting the program like below:
		  raw/fastq_files ...
		  mapping_file
		  manifest_file
		  \n\n"

	echo "Please provide following input parameters
		1) Full path of the mapping file. (Accept both .csv or txt format.)
		2) Depth of the for subsampleing. (Suggested value: 4000)
		3) Mininum frequence for OTU to be selected. (Suggested value: 1000)
		4) The name of the first category in the mapping file. (category 1 and 2 don't necessary to be different. You could put category 1 for twice in the commands, the first run will be replaced)
		5) The name of the second category in the mapping file. (Numeric values for category 2 prefered here)
		6) The specific type of the first category in the mapping file you want to further investigate.
		7) Full path of the reference for alignment.
		8) Full path of the reference for close reference alignment.
		9) Full path of the manifest file.

		Sample Usage:
		sh $0 M231_Mapping_2.tsv 4000 1000 Group1 Group2 A ~/Desktop/Hengchuang/16S_reference/gg-13-8-99-515-806-nb-classifier.qza ~/Desktop/Hengchuang/16S_reference/gg_13_18_97_otus.qza M231_manifest.txt 
		"
	exit 0
else
	echo "################
	Running: sh $0 $1 $2 $3 $4 $5 $6 $7 $8 $9"
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
	
	mkdir Result
	mkdir Result/1-Demux Result/2-OTUAnalysis Result/3-AlphaDiversity Result/4-BetaDiversity Result/5-OTUComparision Result/6-FunctionAnalysis Result/7-AssociationAnalysis Result/FigureandTable
	cp $READMEORIGINALPATH ./Result/
	cp $mapping_file ./Result/
	#cp -r raw demux.qzv demux.qza Result/1-Demux
	cp -r demux.qzv demux.qza Result/1-Demux
	cp -r taxa-bar-plots.qzv taxonomy.qzv table.qzv phylogeny exported/feature-table* exported/dna-sequences.fasta exported/tree* exported/1000 exported/Relative/Classified_stat_relative.svg R_output/*phylogeny* Result/2-OTUAnalysis
	cp -r alpha alpha-rarefaction.qzv core-metrics-results/*evenness* core-metrics-results/*faith* core-metrics-results/*observed* core-metrics-results/*shannon* Result/3-AlphaDiversity
	cp -r core-metrics-results/*bray_curtis* core-metrics-results/*unifrac* R_output/*matrix* R_output/*NMDS* R_output/*heatmap* Result/4-BetaDiversity 
	cp -r exported/ANCOM exported/collapsed/table-l7.qzv Result/5-OTUComparision
	cp -r closedRef_forPICRUSt/* Result/6-FunctionAnalysis
	cp -r exported/Absolute/*pdf Result/7-AssociationAnalysis

	cd Result/FigureandTable
	ln -s ../3-AlphaDiversity/alpha/alpha-summary.tsv Table3-2.tsv
	ln -s ../3-AlphaDiversity/shannon-group-significance.qzv Table3-3.qzv
	ln -s ../4-BetaDiversity/unweighted-unifrac-permanova-${group_1}-significance.qzv Table3-4.qzv
	ln -s ../5-OTUComparision/ANCOM/ANCOM.l7.qzv Table3-5.qzv
	ln -s ../5-OTUComparision/table-l7.qzv Table3-6.qzv
	
	ln -s ../2-OTUAnalysis/Classified_stat_relative.svg Figure3-1.svg
	ln -s ../2-OTUAnalysis/taxa-bar-plots.qzv Figure3-2.qzv
	ln -s ../2-OTUAnalysis/1000/table-l2.1000.qzv Figure3-3.qzv
	ln -s ../2-OTUAnalysis/Bacteria.phylogeny.pdf Figure3-4.pdf
	ln -s ../3-AlphaDiversity/alpha-rarefaction.qzv Figure3-6.qzv
	ln -s ../3-AlphaDiversity/shannon-group-significance.qzv Figure3-7.qzv
	ln -s ../4-BetaDiversity/BetaDiversity_heatmap.svg Figure3-8.svg
	ln -s ../4-BetaDiversity/unweighted_unifrac_emperor.qzv Figure3-9.qzv
	ln -s ../4-BetaDiversity/unifrac_NMDS.pdf Figure3-10.pdf
	ln -s ../4-BetaDiversity/unweighted-unifrac-permanova-${group_1}-significance.qzv Figure3-11.qzv
	ln -s ../5-OTUComparision/ANCOM/ANCOM.l7.qzv Figure3-12.qzv
	ln -s ../6-FunctionAnalysis/percent.feature-table.metagenome.L1.svg Figure3-14.svg
	ln -s ../6-FunctionAnalysis/PCA_L1/PCA-2D.pdf Figure3-15.pdf
	ln -s ../6-FunctionAnalysis/tree.feature-table.metagenome.L1.svg Figure3-16.svg
	ln -s ../7-AssociationAnalysis/Phylum.rda.pdf Figure3-17.pdf
	ln -s ../7-AssociationAnalysis/permanova.pdf Figure3-18.pdf

}

MAIN() {

	##Activate Qiime2 Version
	source activate qiime2-2017.10


	echo "Initiate directory name and set up the directory structure"
	SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
	RSCRIPTORIGINALPATH=${SCRIPTPATH}/RRelatedOutput.R
	cp $RSCRIPTORIGINALPATH ./
	READMEORIGINALPATH=${SCRIPTPATH}/Result_README.txt
	ITOLPERLPATH=${SCRIPTPATH}/generate_file_Itol.pl

	#echo "#Demultiplexing the sequence file"
	#qiime demux emp-single --i-seqs emp-single-end-sequences.qza --m-barcodes-file $mapping_file --m-barcodes-category BarcodeSequence  --o-per-sample-sequences demux.qza
	#qiime demux summarize --i-data demux.qza --o-visualization demux.qzv

	echo "#Set up the directory structure and prepare the raw fastq sequences."
	check_file $manifest_file
	#qiime tools import   --type 'SampleData[SequencesWithQuality]'   --input-path $manifest_file --output-path demux.qza --source-format SingleEndFastqManifestPhred64
	qiime tools import   --type 'SampleData[SequencesWithQuality]'   --input-path $manifest_file --output-path demux.qza --source-format SingleEndFastqManifestPhred33
	qiime demux summarize --i-data demux.qza --o-visualization demux.qzv


	echo "#Use DADA2 for quality control and feature table construction"
	qiime dada2 denoise-single --i-demultiplexed-seqs demux.qza --p-trim-left 10 --p-trunc-len 340 --o-representative-sequences rep-seqs-dada2.qza --o-table table-dada2.qza  --p-n-threads 0
	mv rep-seqs-dada2.qza rep-seqs.withCandM.qza
	mv table-dada2.qza table.withCandM.qza


	echo "#Filter out Choloroplast and Mitochondira"
	check_file $reference_trained
	qiime feature-classifier classify-sklearn   --i-classifier $reference_trained  --i-reads rep-seqs.withCandM.qza  --o-classification taxonomy.withCandM.qza
	qiime taxa filter-table   --i-table table.withCandM.qza  --i-taxonomy taxonomy.withCandM.qza  --p-exclude mitochondria,chloroplast   --o-filtered-table table-no-mitochondria-no-chloroplast.qza
	mv table-no-mitochondria-no-chloroplast.qza table.qza
	qiime taxa filter-seqs   --i-sequences rep-seqs.withCandM.qza   --i-taxonomy taxonomy.withCandM.qza  --p-exclude mitochondria,chloroplast   --o-filtered-sequences rep-seqs-no-mitochondria-no-chloroplast.qza
	mv rep-seqs-no-mitochondria-no-chloroplast.qza rep-seqs.qza


	echo "#Classify the taxonomy"
	qiime feature-classifier classify-sklearn   --i-classifier $reference_trained  --i-reads rep-seqs.qza  --o-classification taxonomy.qza
	qiime metadata tabulate   --m-input-file taxonomy.qza   --o-visualization taxonomy.qzv

	qiime taxa barplot   --i-table table.qza   --i-taxonomy taxonomy.qza   --m-metadata-file $mapping_file  --o-visualization taxa-bar-plots.qzv


	echo "#Visulize of the table without Choloroplast and Mitochondira"
	qiime feature-table summarize --i-table table.qza --o-visualization table.qzv --m-sample-metadata-file $mapping_file
	qiime feature-table tabulate-seqs   --i-data rep-seqs.qza   --o-visualization rep-seqs.qzv

	echo "#Generate tree"
	qiime alignment mafft   --i-sequences rep-seqs.qza   --o-alignment aligned-rep-seqs.qza
	qiime alignment mask   --i-alignment aligned-rep-seqs.qza   --o-masked-alignment masked-aligned-rep-seqs.qza
	qiime phylogeny fasttree   --i-alignment masked-aligned-rep-seqs.qza   --o-tree unrooted-tree.qza
	qiime phylogeny midpoint-root   --i-tree unrooted-tree.qza   --o-rooted-tree rooted-tree.qza

	echo "#Core alpha and beta diversity analysis"
	qiime diversity core-metrics-phylogenetic   --i-phylogeny rooted-tree.qza   --i-table table.qza   --p-sampling-depth $depth   --m-metadata-file $mapping_file  --output-dir core-metrics-results
	qiime diversity alpha-group-significance   --i-alpha-diversity core-metrics-results/faith_pd_vector.qza   --m-metadata-file $mapping_file  --o-visualization core-metrics-results/faith-pd-group-significance.qzv
	qiime diversity alpha-group-significance   --i-alpha-diversity core-metrics-results/evenness_vector.qza   --m-metadata-file $mapping_file  --o-visualization core-metrics-results/evenness-group-significance.qzv
	qiime diversity alpha-group-significance   --i-alpha-diversity core-metrics-results/shannon_vector.qza   --m-metadata-file $mapping_file  --o-visualization core-metrics-results/shannon-group-significance.qzv
	qiime diversity beta-group-significance   --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza   --m-metadata-file $mapping_file  --p-method permanova --m-metadata-category $category_1   --o-visualization 'core-metrics-results/unweighted-unifrac-permanova-'$category_1'-significance.qzv'  --p-pairwise
	qiime diversity beta-group-significance   --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza   --m-metadata-file $mapping_file  --p-method permanova --m-metadata-category $category_2   --o-visualization 'core-metrics-results/unweighted-unifrac-permanova-'$category_2'-significance.qzv'  --p-pairwise
	qiime diversity beta-group-significance   --i-distance-matrix core-metrics-results/weighted_unifrac_distance_matrix.qza   --m-metadata-file $mapping_file  --p-method permanova --m-metadata-category $category_1   --o-visualization 'core-metrics-results/weighted-unifrac-permanova-'$category_1'-significance.qzv'  --p-pairwise
	qiime diversity beta-group-significance   --i-distance-matrix core-metrics-results/weighted_unifrac_distance_matrix.qza   --m-metadata-file $mapping_file  --p-method permanova --m-metadata-category $category_2   --o-visualization 'core-metrics-results/weighted-unifrac-permanova-'$category_2'-significance.qzv'  --p-pairwise
	qiime diversity beta-group-significance   --i-distance-matrix core-metrics-results/bray_curtis_distance_matrix.qza   --m-metadata-file $mapping_file  --p-method permanova --m-metadata-category $category_1   --o-visualization 'core-metrics-results/bray_curtis-permanova-'$category_1'-significance.qzv'  --p-pairwise
	qiime diversity beta-group-significance   --i-distance-matrix core-metrics-results/bray_curtis_distance_matrix.qza   --m-metadata-file $mapping_file  --p-method permanova --m-metadata-category $category_2   --o-visualization 'core-metrics-results/bray_curtis-permanova-'$category_2'-significance.qzv'  --p-pairwise
	qiime diversity beta-group-significance   --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza   --m-metadata-file $mapping_file  --p-method anosim --m-metadata-category $category_1   --o-visualization 'core-metrics-results/unweighted-unifrac-anosim-'$category_1'-significance.qzv'  --p-pairwise
	qiime diversity beta-group-significance   --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza   --m-metadata-file $mapping_file  --p-method anosim --m-metadata-category $category_2   --o-visualization 'core-metrics-results/unweighted-unifrac-anosim-'$category_2'-significance.qzv'  --p-pairwise
	qiime diversity beta-group-significance   --i-distance-matrix core-metrics-results/weighted_unifrac_distance_matrix.qza   --m-metadata-file $mapping_file  --p-method anosim --m-metadata-category $category_1   --o-visualization 'core-metrics-results/weighted-unifrac-anosim-'$category_1'-significance.qzv'  --p-pairwise
	qiime diversity beta-group-significance   --i-distance-matrix core-metrics-results/weighted_unifrac_distance_matrix.qza   --m-metadata-file $mapping_file  --p-method anosim --m-metadata-category $category_2   --o-visualization 'core-metrics-results/weighted-unifrac-anosim-'$category_2'-significance.qzv'  --p-pairwise
	qiime diversity beta-group-significance   --i-distance-matrix core-metrics-results/bray_curtis_distance_matrix.qza   --m-metadata-file $mapping_file  --p-method anosim --m-metadata-category $category_1   --o-visualization 'core-metrics-results/bray_curtis-anosim-'$category_1'-significance.qzv'  --p-pairwise
	qiime diversity beta-group-significance   --i-distance-matrix core-metrics-results/bray_curtis_distance_matrix.qza   --m-metadata-file $mapping_file  --p-method anosim --m-metadata-category $category_2   --o-visualization 'core-metrics-results/bray_curtis-anosim-'$category_2'-significance.qzv'  --p-pairwise
	qiime diversity alpha-rarefaction   --i-table table.qza   --i-phylogeny rooted-tree.qza   --p-max-depth $depth  --m-metadata-file $mapping_file  --o-visualization alpha-rarefaction.qzv
	##These following two commands work only for column with numeric values:
	##qiime emperor plot   --i-pcoa core-metrics-results/unweighted_unifrac_pcoa_results.qza   --m-metadata-file $mapping_file --p-custom-axis $category_2   --o-visualization 'core-metrics-results/unweighted-unifrac-emperor-'$category_2'.qzv'
	##qiime emperor plot   --i-pcoa core-metrics-results/bray_curtis_pcoa_results.qza   --m-metadata-file $mapping_file   --p-custom-axis $category_2   --o-visualization 'core-metrics-results/bray-curtis-emperor-'$category_2'.qzv'


	echo "#alpha dviersity summary"
	mkdir alpha
	qiime diversity alpha --i-table table.qza --p-metric chao1 --output-dir alpha/chao1
	qiime diversity alpha --i-table table.qza --p-metric shannon --output-dir alpha/shannon
	qiime diversity alpha --i-table table.qza --p-metric observed_otus --output-dir alpha/observed_otus
	qiime diversity alpha-phylogenetic --i-table table.qza --i-phylogeny rooted-tree.qza --p-metric faith_pd --output-dir alpha/faith_pd
 	qiime tools export alpha/chao1/alpha_diversity.qza --output-dir alpha/chao1/
 	qiime tools export alpha/shannon/alpha_diversity.qza --output-dir alpha/shannon/
 	qiime tools export alpha/observed_otus/alpha_diversity.qza --output-dir alpha/observed_otus/
 	qiime tools export alpha/faith_pd/alpha_diversity.qza --output-dir alpha/faith_pd/
 	paste alpha/observed_otus/alpha-diversity.tsv alpha/chao1/alpha-diversity.tsv alpha/shannon/alpha-diversity.tsv alpha/faith_pd/alpha-diversity.tsv | awk -F'\t' 'BEGIN{OFS="\t"}{print $1, $2, $4, $6, $8}' >  alpha/alpha-summary.tsv

	echo "#Export necessary files for future analysis"
	for f in rep-seqs.qza table.qza taxonomy.qza ; do echo $f; qiime tools export $f --output-dir exported; done
	for f in alpha-rarefaction.qzv table.qzv taxa-bar-plots.qzv; do echo $f; qiime tools export $f --output-dir exported_qzv; done
	qiime tools export rooted-tree.qza --output-dir exported/
	mv exported/tree.nwk exported/tree.rooted.nwk 
	qiime tools export unrooted-tree.qza --output-dir exported/
	mv exported/tree.nwk exported/tree.unrooted.nwk 
	biom add-metadata -i exported/feature-table.biom -o exported/feature-table.taxonomy.biom --observation-metadata-fp exported/taxonomy.tsv --observation-header OTUID,taxonomy,confidence
	biom convert -i exported/feature-table.taxonomy.biom -o exported/feature-table.taxonomy.txt --to-tsv --header-key taxonomy
	sed 's/taxonomy/Consensus Lineage/' < exported/feature-table.taxonomy.txt | sed 's/ConsensusLineage/Consensus Lineage/' > exported/feature-table.ConsensusLineage.txt

	echo "#Generate heatmaps for top OTUs with different levels with minimum frequence reads supported"
	mkdir exported/collapsed
	mkdir exported/${min_freq}
	for n in 2 3 4 5 6 7;
		do echo $n;
		qiime taxa collapse   --i-table table.qza   --i-taxonomy taxonomy.qza   --p-level $n   --o-collapsed-table exported/collapsed/table-l${n}.qza;
		qiime feature-table filter-features   --i-table exported/collapsed/table-l${n}.qza   --p-min-frequency $min_freq  --o-filtered-table exported/${min_freq}/table-l${n}.${min_freq}.qza; 
		qiime feature-table heatmap --i-table exported/${min_freq}/table-l${n}.${min_freq}.qza --m-metadata-file $mapping_file --m-metadata-category $category_1 --o-visualization exported/${min_freq}/table-l${n}.${min_freq}.qzv;
	done;

	echo "#Summarize the spreadness of OTUs"
	qiime feature-table summarize --i-table exported/collapsed/table-l7.qza --o-visualization exported/collapsed/table-l7.qzv '--m-sample-metadata-file' $mapping_file

	echo "#Generate the figure for the percentage of annotated level"
	perl ~/Desktop/Hengchuang/lib/00.Commbin/test_bin/stat_otu_tab.pl -unif min exported/feature-table.taxonomy.txt -prefix exported/Relative/otu_table --even exported/Relative/otu_table.even.txt -spestat exported/Relative/classified_stat_relative.xls
	perl ~/Desktop/Hengchuang/lib//00.Commbin/bar_diagram.pl -table exported/Relative/classified_stat_relative.xls -style 1 -x_title "Sample Name" -y_title "Sequence Number Percent" -right -textup -rotate='-45' --y_mun 1,7 > exported/Relative/Classified_stat_relative.svg

	echo "ANCOM analaysis for differential OTU"
	mkdir exported/ANCOM
	mkdir exported/ANCOM/SecondaryGroup
	for n2 in 2 3 4 5 6 7;
		do echo $n2;
		qiime composition add-pseudocount   --i-table exported/collapsed/table-l${n2}.qza --o-composition-table exported/ANCOM/composition.l${n2}.qza;
		qiime composition ancom  --i-table exported/ANCOM/composition.l${n2}.qza --m-metadata-file $mapping_file --m-metadata-category $category_1 --o-visualization exported/ANCOM/ANCOM.l${n2}.qzv;
		qiime composition ancom  --i-table exported/ANCOM/composition.l${n2}.qza --m-metadata-file $mapping_file --m-metadata-category $category_2 --o-visualization exported/ANCOM/SecondaryGroup/ANCOM.l${n2}.qzv;
	done;

	echo "#Run for PICRUST analysis and STAMP visulization"
	qiime vsearch cluster-features-closed-reference --i-sequences rep-seqs.qza --i-table table.qza --i-reference-sequences $close_reference_trained --p-perc-identity 0.97 --p-threads 0 --output-dir closedRef_forPICRUSt
	qiime feature-table summarize --i-table closedRef_forPICRUSt/clustered_table.qza --o-visualization closedRef_forPICRUSt/clustered_table.qzv --m-sample-metadata-file $mapping_file
	qiime feature-table tabulate-seqs   --i-data closedRef_forPICRUSt/unmatched_sequences.qza   --o-visualization closedRef_forPICRUSt/unmatched_sequences.qzv
	qiime tools export closedRef_forPICRUSt/clustered_table.qza --output-dir closedRef_forPICRUSt/
	biom convert -i closedRef_forPICRUSt/feature-table.biom -o closedRef_forPICRUSt/feature-table.txt --to-tsv
	normalize_by_copy_number.py -i closedRef_forPICRUSt/feature-table.biom -o closedRef_forPICRUSt/feature-table.normalized.biom
	predict_metagenomes.py -i closedRef_forPICRUSt/feature-table.normalized.biom -o closedRef_forPICRUSt/feature-table.metagenome.biom
	categorize_by_function.py -i closedRef_forPICRUSt/feature-table.metagenome.biom -o closedRef_forPICRUSt/feature-table.metagenome.L1.txt -c KEGG_Pathways -l 1 -f
	categorize_by_function.py -i closedRef_forPICRUSt/feature-table.metagenome.biom -o closedRef_forPICRUSt/feature-table.metagenome.L2.txt -c KEGG_Pathways -l 2 -f
	categorize_by_function.py -i closedRef_forPICRUSt/feature-table.metagenome.biom -o closedRef_forPICRUSt/feature-table.metagenome.L3.txt -c KEGG_Pathways -l 3 -f
	/Users/chengguo/miniconda2/bin/python ~/pipelines/Github/microbiome_helper/biom_to_stamp.py -m KEGG_Pathways closedRef_forPICRUSt/feature-table.metagenome.biom > closedRef_forPICRUSt/feature-table.metagenome.KEGG_Pathways.STAMP.spf

	cd closedRef_forPICRUSt
	for n3 in 1 2 3;
		do echo $n3;
		~/Desktop/Hengchuang/lib/HC/Predict_fun/config/convert_percent.py -i feature-table.metagenome.L${n3}.txt;
		~/Desktop/Hengchuang/MetaGenome_pipeline_V2.2/lib/04.Function/lib/KEGG/bin/get_table_head2.pl percent.feature-table.metagenome.L${n3}.txt 35 -trantab > percent.feature-table.metagenome.L${n3}.tab
		~/Desktop/Hengchuang/MetaGenome_pipeline_V2.2/lib/00.Commbin/top10/bar_diagram.pl  -right -grid -rotate='-45' -x_title 'Sample Name' -y_title 'Relative Abundance' --y_mun 0.25,4 --height 350 -table percent.feature-table.metagenome.L${n3}.tab > percent.feature-table.metagenome.L${n3}.svg
		~/Desktop/Hengchuang/MetaGenome_pipeline_V2.2/lib/00.Commbin/cluster/cluster.pl  -BC -Z -x percent.feature-table.metagenome.L${n3}.txt > level1.relative.tree
		~/Desktop/Hengchuang/MetaGenome_pipeline_V2.2/lib/00.Commbin/cluster/draw_tree.pl -bun 0.25,4 -bline -type 4  level1.relative.tree  percent.feature-table.metagenome.L${n3}.tab --flank_x 100 >  tree.feature-table.metagenome.L${n3}.svg
		~/Desktop/Hengchuang/lib/04.Diversity/lib/PCA/PCA.R.pl $PWD/percent.feature-table.metagenome.L1.txt 0.2 $PWD/PCA_L${n3}
	done;	
	cd ..

	echo "#Make phylogenetic trees for ITOL"
	mkdir phylogeny
	qiime feature-table filter-features --i-table table.qza --p-min-frequency $min_freq --o-filtered-table phylogeny/table.${min_freq}.qza
	qiime tools export phylogeny/table.${min_freq}.qza --output-dir phylogeny
	biom convert -i phylogeny/feature-table.biom -o phylogeny/feature-table.txt --to-tsv
	cut -f1 phylogeny/feature-table.txt | tail -n +3 > phylogeny/feature-table.list
	~/pipelines/Github/seqtk/seqtk subseq exported/dna-sequences.fasta phylogeny/feature-table.list > phylogeny/dna-sequences.${min_freq}.fasta
	qiime tools import   --input-path phylogeny/dna-sequences.${min_freq}.fasta  --output-path phylogeny/dna-sequences.${min_freq}.qza   --type 'FeatureData[Sequence]'
	qiime alignment mafft   --i-sequences phylogeny/dna-sequences.${min_freq}.qza  --o-alignment phylogeny/dna-sequences.${min_freq}.aligned.qza
	qiime alignment mask   --i-alignment phylogeny/dna-sequences.${min_freq}.aligned.qza   --o-masked-alignment phylogeny/dna-sequences.${min_freq}.aligned.masked.qza
	qiime phylogeny fasttree   --i-alignment phylogeny/dna-sequences.${min_freq}.aligned.masked.qza  --o-tree phylogeny/dna-sequences.${min_freq}.unrooted-tree.qza
	qiime phylogeny midpoint-root   --i-tree phylogeny/dna-sequences.${min_freq}.unrooted-tree.qza   --o-rooted-tree phylogeny/dna-sequences.${min_freq}.rooted-tree.qza
	qiime feature-classifier classify-sklearn   --i-classifier  $reference_trained  --i-reads phylogeny/dna-sequences.${min_freq}.qza  --o-classification phylogeny/taxonomy.${min_freq}.qza
	biom add-metadata -i phylogeny/feature-table.biom -o phylogeny/feature-table.taxonomy.biom --observation-metadata-fp exported/taxonomy.tsv --observation-header OTUID,taxonomy,confidence
	biom convert -i phylogeny/feature-table.taxonomy.biom -o phylogeny/feature-table.taxonomy.txt --to-tsv --header-key taxonomy
	qiime tools export phylogeny/dna-sequences.${min_freq}.rooted-tree.qza --output-dir phylogeny/
	mv phylogeny/tree.nwk phylogeny/tree.rooted.nwk
	perl $ITOLPERLPATH phylogeny/feature-table.taxonomy.txt 

<<COMMENT3
	echo "#Generate the absolute directory for enviromental factors relational analysis"
	cd exported/
	perl ~/Desktop/Hengchuang/lib/00.Commbin/test_bin/stat_otu_tab.pl -unif min feature-table.taxonomy.txt --prefix Absolute/otu_table -nomat -abs -spestat Absolute/classified_stat.xls
	cd Absolute
	python ~/Desktop/Hengchuang/lib/HC/Model/RDA.py -i otu_table.p.absolute.mat -g ../../group -e ../../env.list -o Phylum.rda.pdf
	python ~/Desktop/Hengchuang/lib/HC/Model/Permanova.py -i otu_table.p.absolute.mat -g ../../group -e ../../env.list -m t -n 50
	cd ../../
COMMENT3

	echo "#Run R script for additional R related figure generation"
	source deactivate
	mkdir R_output
	cp $READMEORIGINALPATH ./R_output/
	Rscript RRelatedOutput.R $mapping_file $category_1
	perl ~/Desktop/Hengchuang/lib/00.Commbin/test_bin/table_data_svg.pl --colors cyan-orange R_output/bray_matrix.txt R_output/wunifrac_matrix.txt R_output/unifrac_matrix.txt --symbol 'Beta Diversity' > R_output/BetaDiversity_heatmap.svg

	echo "#Organize the result files"
	organize_deliverable_structure $category_1

}

MAIN;