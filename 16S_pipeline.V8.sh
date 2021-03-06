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


tax_levels["1"]="Kingdom"
tax_levels["2"]="Phylum"
tax_levels["3"]="Class"
tax_levels["4"]="Order"
tax_levels["5"]="Family"
tax_levels["6"]="Genus"
tax_levels["7"]="Species"

#tax_levels["k"]="Kingdom"
#tax_levels["p"]="Phylum"
#tax_levels["c"]="Class"
#tax_levels["o"]="Order"
#tax_levels["f"]="Family"
#tax_levels["g"]="Genus"
#tax_levels["s"]="Species"


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

function assign_taxa() {
	loop_id=$1
	if [ $loop_id ==  1]; then 
		echo "Kingdom"
	elif [ $loop_id ==  2]; then 
		echo "Phylum"
	elif [ $loop_id ==  3]; then 
		echo "Class"
	elif [ $loop_id ==  4]; then 
		echo "Order"
	elif [ $loop_id ==  5]; then 
		echo "Family"
	elif [ $loop_id ==  6]; then 
		echo "Genus"
	elif [ $loop_id ==  7]; then 
		echo "Species"
	fi
}

#for f in 1 2 3 4 5 6 7;
#	do echo $f;
#	tax=$(assign_taxa ${f});
#	echo $tax;
#done;


MAIN() {

	##Activate Qiime2 Version
	source activate qiime2-2018.6


	echo "##############################################################\n#Initiate directory name and set up the directory structure"
	SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
	RSCRIPTORIGINALPATH=${SCRIPTPATH}/RRelatedOutput.R
	cp $RSCRIPTORIGINALPATH ./
	READMEORIGINALPATH=${SCRIPTPATH}/Result_README.pdf
	ITOLPERLPATH=${SCRIPTPATH}/generate_file_Itol.pl
	CURRENTDIR=`echo $PWD`

	#echo "##############################################################\n#Demultiplexing the single-end sequence file"
	#qiime demux emp-single --i-seqs emp-single-end-sequences.qza --m-barcodes-file $mapping_file --m-barcodes-column BarcodeSequence  --o-per-sample-sequences demux.qza
	#qiime demux summarize --i-data demux.qza --o-visualization demux.qzv

	#echo "##############################################################\n#Demultiplexing the paired-end sequence file"
	#qiime demux emp-paired --i-seqs emp-paired-end-sequences.qza --m-barcodes-file $mapping_file --m-barcodes-column BarcodeSequence  --o-per-sample-sequences demux.qza
	#qiime demux summarize --i-data demux.qza --o-visualization demux.qzv

<<COMENT1

	echo "##############################################################\n#Set up the directory structure and prepare the raw fastq sequences."
	check_file $manifest_file
	#qiime tools import   --type 'SampleData[SequencesWithQuality]'   --input-path $manifest_file --output-path demux.qza --source-format SingleEndFastqManifestPhred64
	#single-end
	#qiime demux emp-single --i-seqs emp-single-end-sequences.qza --m-barcodes-file $mapping_file --m-barcodes-column BarcodeSequence  --o-per-sample-sequences demux.qza --p-rev-comp-mapping-barcodes
	#qiime demux emp-single --i-seqs emp-single-end-sequences.qza --m-barcodes-file $mapping_file --m-barcodes-column BarcodeSequence  --o-per-sample-sequences demux.qza
	#qiime tools import   --type 'SampleData[SequencesWithQuality]'   --input-path $manifest_file --output-path demux.qza --source-format SingleEndFastqManifestPhred33
	#paired-end
	#qiime tools import   --type 'SampleData[PairedEndSequencesWithQuality]'  --input-path $manifest_file --output-path demux.qza --source-format PairedEndFastqManifestPhred33
	#qiime demux summarize --i-data demux.qza --o-visualization demux.qzv


	echo "##############################################################\n#Use DADA2 for quality control and feature table construction"
	#single-end
	qiime dada2 denoise-single --i-demultiplexed-seqs demux.qza --p-trim-left 10 --p-trunc-len 265 --o-representative-sequences rep-seqs-dada2.qza --o-table table-dada2.qza  --p-n-threads 0 --o-denoising-stats stats-dada2.qza
	#qiime dada2 denoise-single --i-demultiplexed-seqs demux.qza --p-trim-left 0 --p-trunc-len 120 --o-representative-sequences rep-seqs-dada2.qza --o-table table-dada2.qza  --p-n-threads 0 --o-denoising-stats stats-dada2.qza

	#paired-end
	#qiime dada2 denoise-paired --i-demultiplexed-seqs demux.qza --p-trunc-len-f 210 --p-trunc-len-r 210 --p-trim-left-f 24 --p-trim-left-r 25 --o-representative-sequences rep-seqs-dada2.qza --o-table table-dada2.qza  --p-n-threads 0 --o-denoising-stats stats-dada2.qza
	#qiime dada2 denoise-paired --i-demultiplexed-seqs demux.qza --p-trunc-len-f 290 --p-trunc-len-r 250 --p-trim-left-f 10 --p-trim-left-r 10 --o-representative-sequences rep-seqs-dada2.qza --o-table table-dada2.qza  --p-n-threads 0 --o-denoising-stats stats-dada2.qza

	qiime metadata tabulate --m-input-file stats-dada2.qza --o-visualization stats-dada2.qzv
	mv rep-seqs-dada2.qza rep-seqs.withCandM.qza
	mv table-dada2.qza table.withCandM.qza
COMENT1
<<COMMENT2

	echo "##############################################################\n#Filter out Choloroplast and Mitochondira"
	check_file $reference_trained
	qiime feature-classifier classify-sklearn   --i-classifier $reference_trained  --i-reads rep-seqs.withCandM.qza  --o-classification taxonomy.withCandM.qza
	qiime metadata tabulate  --m-input-file taxonomy.withCandM.qza  --o-visualization taxonomy.withCandM.qzv


	qiime taxa filter-table   --i-table table.withCandM.qza  --i-taxonomy taxonomy.withCandM.qza  --p-exclude mitochondria,chloroplast,Archaea,Unassigned  --o-filtered-table table-no-mitochondria-no-chloroplast.qza
	mv table-no-mitochondria-no-chloroplast.qza table.qza
	qiime taxa filter-seqs   --i-sequences rep-seqs.withCandM.qza   --i-taxonomy taxonomy.withCandM.qza  --p-exclude mitochondria,chloroplast,Archaea,Unassigned   --o-filtered-sequences rep-seqs-no-mitochondria-no-chloroplast.qza
	mv rep-seqs-no-mitochondria-no-chloroplast.qza rep-seqs.qza


	echo "##############################################################\n#Classify the taxonomy"
	qiime feature-classifier classify-sklearn   --i-classifier $reference_trained  --i-reads rep-seqs.qza  --o-classification taxonomy.qza
	qiime metadata tabulate   --m-input-file taxonomy.qza   --o-visualization taxonomy.qzv

	echo "##############################################################\n#Generate tree"
	qiime alignment mafft   --i-sequences rep-seqs.qza   --o-alignment aligned-rep-seqs.qza
	qiime alignment mask   --i-alignment aligned-rep-seqs.qza   --o-masked-alignment masked-aligned-rep-seqs.qza
	qiime phylogeny fasttree   --i-alignment masked-aligned-rep-seqs.qza   --o-tree unrooted-tree.qza
	qiime phylogeny midpoint-root   --i-tree unrooted-tree.qza   --o-rooted-tree rooted-tree.qza


	echo "##############################################################\n#Visulize of the table without Choloroplast and Mitochondira"
	qiime feature-table summarize --i-table table.qza --o-visualization table.qzv --m-sample-metadata-file $mapping_file
	qiime feature-table tabulate-seqs   --i-data rep-seqs.qza   --o-visualization rep-seqs.qzv	
	qiime taxa barplot   --i-table table.qza   --i-taxonomy taxonomy.qza   --m-metadata-file $mapping_file  --o-visualization taxa-bar-plots.qzv

	echo "##############################################################\n#Core alpha and beta diversity analysis"
	qiime diversity core-metrics-phylogenetic   --i-phylogeny rooted-tree.qza   --i-table table.qza   --p-sampling-depth $depth   --m-metadata-file $mapping_file  --output-dir core-metrics-results
	qiime diversity alpha-group-significance   --i-alpha-diversity core-metrics-results/faith_pd_vector.qza   --m-metadata-file $mapping_file  --o-visualization core-metrics-results/faith-pd-group-significance.qzv
	qiime diversity alpha-group-significance   --i-alpha-diversity core-metrics-results/evenness_vector.qza   --m-metadata-file $mapping_file  --o-visualization core-metrics-results/evenness-group-significance.qzv
	qiime diversity alpha-group-significance   --i-alpha-diversity core-metrics-results/shannon_vector.qza   --m-metadata-file $mapping_file  --o-visualization core-metrics-results/shannon-group-significance.qzv
	qiime diversity alpha-group-significance   --i-alpha-diversity core-metrics-results/observed_otus_vector.qza   --m-metadata-file $mapping_file  --o-visualization core-metrics-results/observed_otus-group-significance.qzv
	qiime diversity beta-group-significance   --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza   --m-metadata-file $mapping_file  --p-method permanova --m-metadata-column $category_1   --o-visualization 'core-metrics-results/unweighted_unifrac-permanova-'$category_1'-significance.qzv'  --p-pairwise
	qiime diversity beta-group-significance   --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza   --m-metadata-file $mapping_file  --p-method permanova --m-metadata-column $category_2   --o-visualization 'core-metrics-results/unweighted_unifrac-permanova-'$category_2'-significance.qzv'  --p-pairwise
	qiime diversity beta-group-significance   --i-distance-matrix core-metrics-results/weighted_unifrac_distance_matrix.qza   --m-metadata-file $mapping_file  --p-method permanova --m-metadata-column $category_1   --o-visualization 'core-metrics-results/weighted_unifrac-permanova-'$category_1'-significance.qzv'  --p-pairwise
	qiime diversity beta-group-significance   --i-distance-matrix core-metrics-results/weighted_unifrac_distance_matrix.qza   --m-metadata-file $mapping_file  --p-method permanova --m-metadata-column $category_2   --o-visualization 'core-metrics-results/weighted_unifrac-permanova-'$category_2'-significance.qzv'  --p-pairwise
	qiime diversity beta-group-significance   --i-distance-matrix core-metrics-results/bray_curtis_distance_matrix.qza   --m-metadata-file $mapping_file  --p-method permanova --m-metadata-column $category_1   --o-visualization 'core-metrics-results/bray_curtis-permanova-'$category_1'-significance.qzv'  --p-pairwise
	qiime diversity beta-group-significance   --i-distance-matrix core-metrics-results/bray_curtis_distance_matrix.qza   --m-metadata-file $mapping_file  --p-method permanova --m-metadata-column $category_2   --o-visualization 'core-metrics-results/bray_curtis-permanova-'$category_2'-significance.qzv'  --p-pairwise
	qiime diversity beta-group-significance   --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza   --m-metadata-file $mapping_file  --p-method anosim --m-metadata-column $category_1   --o-visualization 'core-metrics-results/unweighted_unifrac-anosim-'$category_1'-significance.qzv'  --p-pairwise
	qiime diversity beta-group-significance   --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza   --m-metadata-file $mapping_file  --p-method anosim --m-metadata-column $category_2   --o-visualization 'core-metrics-results/unweighted_unifrac-anosim-'$category_2'-significance.qzv'  --p-pairwise
	qiime diversity beta-group-significance   --i-distance-matrix core-metrics-results/weighted_unifrac_distance_matrix.qza   --m-metadata-file $mapping_file  --p-method anosim --m-metadata-column $category_1   --o-visualization 'core-metrics-results/weighted_unifrac-anosim-'$category_1'-significance.qzv'  --p-pairwise
	qiime diversity beta-group-significance   --i-distance-matrix core-metrics-results/weighted_unifrac_distance_matrix.qza   --m-metadata-file $mapping_file  --p-method anosim --m-metadata-column $category_2   --o-visualization 'core-metrics-results/weighted_unifrac-anosim-'$category_2'-significance.qzv'  --p-pairwise
	qiime diversity beta-group-significance   --i-distance-matrix core-metrics-results/bray_curtis_distance_matrix.qza   --m-metadata-file $mapping_file  --p-method anosim --m-metadata-column $category_1   --o-visualization 'core-metrics-results/bray_curtis-anosim-'$category_1'-significance.qzv'  --p-pairwise
	qiime diversity beta-group-significance   --i-distance-matrix core-metrics-results/bray_curtis_distance_matrix.qza   --m-metadata-file $mapping_file  --p-method anosim --m-metadata-column $category_2   --o-visualization 'core-metrics-results/bray_curtis-anosim-'$category_2'-significance.qzv'  --p-pairwise
	qiime diversity alpha-rarefaction   --i-table table.qza   --i-phylogeny rooted-tree.qza   --p-max-depth $depth  --m-metadata-file $mapping_file  --o-visualization alpha-rarefaction.qzv   --p-steps 50
	##These following two commands work only for column with numeric values:
	##qiime emperor plot   --i-pcoa core-metrics-results/unweighted_unifrac_pcoa_results.qza   --m-metadata-file $mapping_file --p-custom-axis $category_2   --o-visualization 'core-metrics-results/unweighted_unifrac-emperor-'$category_2'.qzv'
	##qiime emperor plot   --i-pcoa core-metrics-results/bray_curtis_pcoa_results.qza   --m-metadata-file $mapping_file   --p-custom-axis $category_2   --o-visualization 'core-metrics-results/bray-curtis-emperor-'$category_2'.qzv'


	echo "##############################################################\n#alpha dviersity summary"
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

	echo "##############################################################\n#Export necessary files for future analysis"
	for f in rep-seqs.qza table.qza taxonomy.qza ; do echo $f; qiime tools export $f --output-dir exported; done
	for f in alpha-rarefaction.qzv table.qzv taxa-bar-plots.qzv; do echo $f; qiime tools export $f --output-dir exported_qzv; done
	qiime tools export rooted-tree.qza --output-dir exported/
	mv exported/tree.nwk exported/tree.rooted.nwk 
	qiime tools export unrooted-tree.qza --output-dir exported/
	mv exported/tree.nwk exported/tree.unrooted.nwk 
	biom add-metadata -i exported/feature-table.biom -o exported/feature-table.taxonomy.biom --observation-metadata-fp exported/taxonomy.tsv --observation-header OTUID,taxonomy,confidence
	biom convert -i exported/feature-table.taxonomy.biom -o exported/feature-table.taxonomy.txt --to-tsv --header-key taxonomy
	biom convert -i exported/feature-table.taxonomy.biom -o exported/feature-table.txt --to-tsv
	sed 's/taxonomy/Consensus Lineage/' < exported/feature-table.taxonomy.txt | sed 's/ConsensusLineage/Consensus Lineage/' > exported/feature-table.ConsensusLineage.txt



	echo "##############################################################\n#Generate heatmaps for top OTUs with different levels with minimum frequence reads supported"
	mkdir exported/collapsed
	mkdir exported/${min_freq}
	for n in 2 3 4 5 6 7;
		do echo $n;
		qiime taxa collapse   --i-table table.qza   --i-taxonomy taxonomy.qza   --p-level $n   --o-collapsed-table exported/collapsed/collapsed-${tax_levels[${n}]}.qza;
		qiime feature-table summarize --i-table exported/collapsed/collapsed-${tax_levels[${n}]}.qza --o-visualization exported/collapsed/collapsed-${tax_levels[${n}]}.qzv '--m-sample-metadata-file' $mapping_file
		qiime feature-table filter-features   --i-table exported/collapsed/collapsed-${tax_levels[${n}]}.qza --p-min-frequency $min_freq  --o-filtered-table exported/${min_freq}/table-${tax_levels[${n}]}.${min_freq}.qza; 
		qiime feature-table heatmap --i-table exported/${min_freq}/table-${tax_levels[${n}]}.${min_freq}.qza --m-metadata-file $mapping_file --m-metadata-column $category_1 --o-visualization exported/${min_freq}/table-${tax_levels[${n}]}.${min_freq}.qzv;
	done;


	echo "##############################################################\n#Generate the figure for the percentage of annotated level"
	perl ${SCRIPTPATH}/stat_otu_tab.pl -unif min exported/feature-table.taxonomy.txt -prefix exported/Relative/otu_table --even exported/Relative/otu_table.even.txt -spestat exported/Relative/classified_stat_relative.xls
	perl ${SCRIPTPATH}/bar_diagram.pl -table exported/Relative/classified_stat_relative.xls -style 1 -x_title "Sample Name" -y_title "Sequence Number Percent" -right -textup -rotate='-45' --y_mun 1,7 > exported/Relative/Classified_stat_relative.svg
	mv exported/Relative/otu_table.k.relative.mat exported/Relative/otu_table.Kingdom.relative.txt
	mv exported/Relative/otu_table.p.relative.mat exported/Relative/otu_table.Phylum.relative.txt
	mv exported/Relative/otu_table.c.relative.mat exported/Relative/otu_table.Class.relative.txt
	mv exported/Relative/otu_table.o.relative.mat exported/Relative/otu_table.Order.relative.txt
	mv exported/Relative/otu_table.f.relative.mat exported/Relative/otu_table.Family.relative.txt
	mv exported/Relative/otu_table.g.relative.mat exported/Relative/otu_table.Genus.relative.txt
	mv exported/Relative/otu_table.s.relative.mat exported/Relative/otu_table.Species.relative.txt
	for n7 in "Pylumn" "Class" "Order" "Family" "Genus" "Species"; 
		do echo $n7; 
		#echo "mv exported/Relative/otu_table.${n7}.relative.mat exported/Relative/otu_table.${tax_levels[${n7}]}.relative.txt"
		#mv exported/Relative/otu_table.${n7}.relative.mat exported/Relative/otu_table.${tax_levels[${n7}]}.relative.txt
		#echo ${tax_levels[$n7]}
		#echo ${tax_levels[${n7}]}
		perl -lane '$,="\t";pop(@F);print(@F)' exported/Relative/otu_table.${n7}.relative.txt > exported/Relative/otu_table.${n7}.relative.lastcolumn.txt; 
		${SCRIPTPATH}/get_table_head2.pl exported/Relative/otu_table.${n7}.relative.lastcolumn.txt 35 -trantab > exported/Relative/otu_table.${n7}.relative.lastcolumn.trans; 
		${SCRIPTPATH}/bar_diagram.pl -table exported/Relative/otu_table.${n7}.relative.lastcolumn.trans -style 1 -x_title "Sample Name" -y_title "Sequence Number Percent" -right -textup -rotate='-45' --y_mun 1,1 > exported/Relative/otu_table.${n7}.relative.svg; 
	done;
	for svg_file in exported/Relative/*svg; do echo $svg_file; n=$(basename "$svg_file" .svg); echo $n; rsvg-convert -h 3200 $svg_file > exported/Relative/${n}.png; done

COMMENT2
<<COMMENT3

	echo "ANCOM analaysis for differential OTU"
	mkdir exported/ANCOM
	mkdir exported/ANCOM/SecondaryGroup
	for n2 in 2 3 4 5 6 7;
		do echo $n2;
		qiime composition add-pseudocount   --i-table exported/collapsed/collapsed-${tax_levels[${n2}]}.qza --o-composition-table exported/ANCOM/composition.${tax_levels[${n2}]}.qza;
		qiime composition ancom  --i-table exported/ANCOM/composition.${tax_levels[${n2}]}.qza --m-metadata-file $mapping_file --m-metadata-column $category_1 --o-visualization exported/ANCOM/ANCOM.${tax_levels[${n2}]}.qzv;
		qiime composition ancom  --i-table exported/ANCOM/composition.${tax_levels[${n2}]}.qza --m-metadata-file $mapping_file --m-metadata-column $category_2 --o-visualization exported/ANCOM/SecondaryGroup/ANCOM.${tax_levels[${n2}]}.qzv;
	done;


	echo "##############################################################\n#Run for PICRUST analysis and STAMP visulization"
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

	cd closedRef_forPICRUSt
	for n3 in 1 2 3;
		do echo $n3;
		${SCRIPTPATH}/convert_percent.py -i feature-table.metagenome.L${n3}.txt;
		${SCRIPTPATH}/get_table_head2.pl percent.feature-table.metagenome.L${n3}.txt 35 -trantab > percent.feature-table.metagenome.L${n3}.tab
		${SCRIPTPATH}/top10_bar_diagram.pl  -right -grid -rotate='-45' -x_title 'Sample Name' -y_title 'Relative Abundance' --y_mun 0.25,4 --height 350 -table percent.feature-table.metagenome.L${n3}.tab > percent.feature-table.metagenome.L${n3}.svg
		${SCRIPTPATH}/cluster.pl  -BC -Z -x percent.feature-table.metagenome.L${n3}.txt > level1.relative.tree
		${SCRIPTPATH}/draw_tree.pl -bun 0.25,4 -bline -type 4  level1.relative.tree  percent.feature-table.metagenome.L${n3}.tab --flank_x 100 >  tree.feature-table.metagenome.L${n3}.svg
		#${SCRIPTPATH}/PCA.R.pl ${PWD}/percent.feature-table.metagenome.L${n3}.txt 0.2 ${PWD}/PCA_L${n3}
		cp $mapping_file ./sample-metadata.PCA.txt
		perl -p -i.bak -e 's/#//' ./sample-metadata.PCA.txt
		tail -n +2 feature-table.metagenome.L${n3}.txt > feature-table.metagenome.L${n3}.PCA.txt
		perl -p -i.bak -e 's/#OTU ID/KEGG_function/' feature-table.metagenome.L${n3}.PCA.txt
	done;
	for svg_file in *svg; do echo $svg_file; base=$(basename $svg_file .svg); rsvg-convert -h 3200 $svg_file > ${base}.png; done
	cd ..


	echo "##############################################################\n#Make phylogenetic trees for ITOL"
	mkdir phylogeny
	qiime feature-table filter-features --i-table table.qza --p-min-frequency $min_freq --o-filtered-table phylogeny/table.${min_freq}.qza
	qiime tools export phylogeny/table.${min_freq}.qza --output-dir phylogeny
	biom convert -i phylogeny/feature-table.biom -o phylogeny/feature-table.txt --to-tsv
	cut -f1 phylogeny/feature-table.txt | tail -n +3 > phylogeny/feature-table.list
	${SCRIPTPATH}/seqtk subseq exported/dna-sequences.fasta phylogeny/feature-table.list > phylogeny/dna-sequences.${min_freq}.fasta
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


	echo "##############################################################\n#export all qzv files into clickable folders"
	#for f in $(find . -type f -name "*.qzv"); do echo $f; qiime tools export $f --output-dir ${f}.exported; done
	for f in $(find . -type f -name "*.qzv"); do echo $f; base=$(basename $f .qzv); dir=$(dirname $f); new=${dir}/${base}; qiime tools export $f --output-dir ${new}.qzv.exported; done 


	echo "##############################################################\n#Run Qiime1 for differOTU analysis"
	source deactivate
	source activate qiime1
	mkdir exported/DiffAbundance
	biom convert -i exported/Relative/otu_table.even.txt -o exported/DiffAbundance/otu_table.even.biom --to-hdf5 --table-type="OTU table" --process-obs-metadata taxonomy
	summarize_taxa.py -i exported/DiffAbundance/otu_table.even.biom -a -o exported/DiffAbundance/tax
	summarize_taxa.py -i exported/DiffAbundance/otu_table.even.biom -a -L 7 -o exported/DiffAbundance/tax
	source ~/.bash_profile
	for n4 in 2 3 4 5 6 7;
		do echo $n4;
		#the biom file should include taxonomy information for group_significance.py script
		cut -f1 exported/DiffAbundance/tax/otu_table.even_L${n4}.txt > exported/DiffAbundance/tax/otu_table.even_L${n4}.1stColumn.txt
		perl -p -i.bak -e 's/#OTU ID/taxonomy/' exported/DiffAbundance/tax/otu_table.even_L${n4}.1stColumn.txt
		paste exported/DiffAbundance/tax/otu_table.even_L${n4}.txt exported/DiffAbundance/tax/otu_table.even_L${n4}.1stColumn.txt > exported/DiffAbundance/tax/otu_table.even_${tax_levels[${n4}]}.taxonomy.txt
		biom convert -i exported/DiffAbundance/tax/otu_table.even_${tax_levels[${n4}]}.taxonomy.txt -o exported/DiffAbundance/tax/otu_table.even_${tax_levels[${n4}]}.taxonomy.biom --to-hdf5 --table-type="OTU table" --process-obs-metadata taxonomy
		group_significance.py -i exported/DiffAbundance/tax/otu_table.even_${tax_levels[${n4}]}.taxonomy.biom -m $mapping_file -c $category_1 -s kruskal_wallis -o exported/DiffAbundance/kruskal_wallis_${category_1}_DiffAbundance_${tax_levels[${n4}]}.txt --biom_samples_are_superset --print_non_overlap
		group_significance.py -i exported/DiffAbundance/tax/otu_table.even_${tax_levels[${n4}]}.taxonomy.biom -m $mapping_file -c $category_2 -s kruskal_wallis -o exported/DiffAbundance/kruskal_wallis_${category_2}_DiffAbundance_${tax_levels[${n4}]}.txt --biom_samples_are_superset --print_non_overlap
		group_significance.py -i exported/DiffAbundance/tax/otu_table.even_${tax_levels[${n4}]}.taxonomy.biom -m $mapping_file -c $category_1 -s ANOVA -o exported/DiffAbundance/ANOVA_${category_1}_DiffAbundance_${tax_levels[${n4}]}.txt --biom_samples_are_superset --print_non_overlap
		group_significance.py -i exported/DiffAbundance/tax/otu_table.even_${tax_levels[${n4}]}.taxonomy.biom -m $mapping_file -c $category_2 -s ANOVA -o exported/DiffAbundance/ANOVA_${category_2}_DiffAbundance_${tax_levels[${n4}]}.txt --biom_samples_are_superset --print_non_overlap
		differential_abundance.py -i exported/DiffAbundance/tax/otu_table.even_${tax_levels[${n4}]}.taxonomy.biom -o exported/DiffAbundance/DESeq2_${category_1}_Between_Control_and_DSS_DiffAbundance_${tax_levels[${n4}]}.txt  -a DESeq2_nbinom -m $mapping_file -c $category_1 -x Control -y DSS -d
		differential_abundance.py -i exported/DiffAbundance/tax/otu_table.even_${tax_levels[${n4}]}.taxonomy.biom -o exported/DiffAbundance/DESeq2_${category_1}_Between_Control_and_QCWZD_DiffAbundance_${tax_levels[${n4}]}.txt  -a DESeq2_nbinom -m $mapping_file -c $category_1 -x Control -y QCWZD -d
		differential_abundance.py -i exported/DiffAbundance/tax/otu_table.even_${tax_levels[${n4}]}.taxonomy.biom -o exported/DiffAbundance/DESeq2_${category_1}_Between_DSS_and_QCWZD_DiffAbundance_${tax_levels[${n4}]}.txt  -a DESeq2_nbinom -m $mapping_file -c $category_1 -x DSS -y QCWZD -d
	done;


	echo "##############################################################\n#Run R script for additional R related figure generation"
	source deactivate
	mkdir R_output
	#Change format of meta-data file for Rscript of PLSDA analysis
	cp $mapping_file ./R_output/sample-metadata.txt
	tail -n +2 exported/feature-table.txt > ./R_output/feature-table.PLSDA.txt
	perl -p -i.bak -e 's/#OTU ID//' ./R_output/feature-table.PLSDA.txt
	sort ./R_output/sample-metadata.txt > ./R_output/sample-metadata.PLSDA.txt
	#Change format of meta-data file for Rscript of alpha diversity analysis
	cp $mapping_file ./alpha/sample-metadata_alphadiversity.txt
	perl -p -i.bak -e 's/#SampleID//' ./alpha/sample-metadata_alphadiversity.txt
	Rscript RRelatedOutput.R $mapping_file $category_1
	Rscript ${SCRIPTPATH}/alphaboxplotwitSig.R ./alpha/sample-metadata_alphadiversity.txt $category_1 ./alpha/alpha-summary.tsv ./alpha/
	perl ${SCRIPTPATH}/table_data_svg.pl --colors cyan-orange R_output/bray_matrix.txt R_output/wunifrac_matrix.txt R_output/unifrac_matrix.txt --symbol 'Beta Diversity' > R_output/BetaDiversity_heatmap.svg
	rsvg-convert -h 3200 R_output/BetaDiversity_heatmap.svg > R_output/BetaDiversity_heatmap.png
	${SCRIPTPATH}/biom_to_stamp.py -m KEGG_Pathways closedRef_forPICRUSt/feature-table.metagenome.biom > closedRef_forPICRUSt/feature-table.metagenome.KEGG_Pathways.STAMP.txt
	for n5 in 1 2 3;
		do echo $n5;
		Rscript ${SCRIPTPATH}/Function_PCA.r ${PWD}/closedRef_forPICRUSt/feature-table.metagenome.L${n5}.PCA.txt ${PWD}/closedRef_forPICRUSt//sample-metadata.PCA.txt $category_1
	done;
COMMENT3
<<COMMENT4


	echo "##############################################################\n#Generate the absolute directory for enviromental factors relational analysis"
	source deactivate
	cd exported/
	perl ${SCRIPTPATH}/stat_otu_tab.pl -unif min feature-table.taxonomy.txt --prefix Absolute/otu_table -nomat -abs -spestat Absolute/classified_stat.xls
	cd Absolute
	mv otu_table.k.absolute.mat otu_table.Kingdom.absolute.txt
	mv otu_table.p.absolute.mat otu_table.Pylumn.absolute.txt
	mv otu_table.c.absolute.mat otu_table.Class.absolute.txt
	mv otu_table.o.absolute.mat otu_table.Order.absolute.txt
	mv otu_table.f.absolute.mat otu_table.Family.absolute.txt
	mv otu_table.g.absolute.mat otu_table.Genus.absolute.txt
	mv otu_table.s.absolute.mat otu_table.Species.absolute.txt
	mkdir RDA
	for n6 in "Pylumn" "Class" "Order" "Family" "Genus" "Species";
		do echo $n6;
		mkdir RDA/${n6}
		cp otu_table.${n6}.absolute.txt RDA/${n6}
		cd RDA/${n6}
		python ${SCRIPTPATH}/RDA.py -i otu_table.${n6}.absolute.txt -g ../../../../group -e ../../../../env.list -o RDA_CCA_plot.${n6}.pdf
		cd ../../
	done;
	cd ../../


	echo "##############################################################\n#Run LEFSE for Group1"
	########Don't work for docker... LEFSE has to be done by hand for now.
	########lefse.txt is made by using the species level collapsed number from qiime2 taxa-bar-plot with the mapping file group information. Also remember to replace ; to | sign in the lefse.txt file.
	#cd exported
	#docker run -v $PWD:/home/linuxbrew/inputs -it biobakery/lefse
	#cd inputs
	#for f in *lefse.txt; do echo $f; base=$(basename $f .txt); perl -p -i.bak -e 's/\r/\n/g' $f; echo $base; format_input.py ${base}.txt ${base}.lefseinput.txt -c 1 -u 2 -o 1000000; run_lefse.py ${base}.lefseinput.txt ${base}.LDA.txt;  plot_res.py --dpi 300 ${base}.LDA.txt ${base}.png; plot_cladogram.py ${base}.LDA.txt --dpi 300 ${base}.cladogram.png --format png; done
	#exit
COMMENT4

	echo "##############################################################\n#Organize the result files"
	cp -r ${SCRIPTPATH}/Result_AmpliconSequencing ./
	sh ${SCRIPTPATH}/organize_dir_structure_V2.sh $mapping_file $category_1 $READMEORIGINALPATH


}

MAIN;