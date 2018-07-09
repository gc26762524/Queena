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
	
	mkdir Result
	mkdir Result/1-Demux Result/2-OTUAnalysis Result/3-AlphaDiversity Result/4-BetaDiversity Result/5-OTUPhylogenetics Result/6-AssociationAnalysis Result/7-FunctionAnalysis Result/FigureandTable
	cp $READMEORIGINALPATH ./Result/
	cp $mapping_file ./Result/
	#cp -r raw demux.qzv demux.qza Result/1-Demux
	cp -r demux.qzv Result/1-Demux
	cp -r taxa-bar-plots.qzv* taxonomy.qzv* table.qzv* rep-seqs.qzv* phylogeny exported/feature-table* exported/dna-sequences.fasta exported/tree* exported/1000 exported/kruskal_wallis* exported/Relative exported/Relative/Classified_stat_relative.svg exported/ANCOM exported/collapsed/table-l7.qzv Result/2-OTUAnalysis
	cp -r alpha alpha-rarefaction.qzv* core-metrics-results/*evenness* core-metrics-results/*faith* core-metrics-results/*observed* core-metrics-results/*shannon* Result/3-AlphaDiversity
	cp -r core-metrics-results/*bray_curtis* core-metrics-results/*unifrac* R_output/*matrix* R_output/*NMDS* R_output/*heatmap* R_output/PLSDA_plot.pdf Result/4-BetaDiversity 
	cp -r R_output/*phylogeny*  phylogeny Result/5-OTUPhylogenetics
	cp -r exported/Absolute/*pdf Result/6-AssociationAnalysis
	cp -r closedRef_forPICRUSt/* Result/7-FunctionAnalysis

	cd Result/FigureandTable

	ln -s ../2-OTUAnalysis/ANCOM/ANCOM.l7.qzv Table3-1.qzv
	ln -s ../2-OTUAnalysis/table-l7.qzv  Table3-2.qzv
	ln -s ../3-AlphaDiversity/alpha/alpha-summary.tsv Table3-3.tsv
	ln -s ../3-AlphaDiversity/shannon-group-significance.qzv Table3-4.qzv
	ln -s ../4-BetaDiversity/unweighted-unifrac-permanova-${group_1}-significance.qzv Table3-5.qzv
		
	ln -s ../2-OTUAnalysis/Classified_stat_relative.svg Figure3-1.svg
	ln -s ../2-OTUAnalysis/taxa-bar-plots.qzv Figure3-2.qzv
	ln -s ../2-OTUAnalysis/1000/table-l2.1000.qzv Figure3-3.qzv
	ln -s ../2-OTUAnalysis/ANCOM/ANCOM.l7.qzv Figure3-4.qzv
	ln -s ../3-AlphaDiversity/alpha-rarefaction.qzv Figure3-6.qzv
	ln -s ../3-AlphaDiversity/shannon-group-significance.qzv Figure3-7.qzv
	ln -s ../4-BetaDiversity/BetaDiversity_heatmap.svg Figure3-8.svg
	ln -s ../4-BetaDiversity/unweighted_unifrac_emperor.qzv Figure3-9.qzv
	ln -s ../4-BetaDiversity/unifrac_NMDS.pdf Figure3-10.pdf
	ln -s ../4-BetaDiversity/unweighted-unifrac-permanova-${group_1}-significance.qzv Figure3-11.qzv
	ln -s ../5-OTUPhylogenetics/Bacteria.phylogeny.pdf Figure3-12.pdf
	ln -s ../6-AssociationAnalysis/Phylum.rda.pdf Figure3-14.pdf
	ln -s ../6-AssociationAnalysis/permanova.pdf Figure3-15.pdf
	ln -s ../7-FunctionAnalysis/percent.feature-table.metagenome.L1.svg Figure3-18.svg
	ln -s ../7-FunctionAnalysis/PCA_L1/PCA-2D.pdf Figure3-19.pdf
	ln -s ../7-FunctionAnalysis/tree.feature-table.metagenome.L1.svg Figure3-20.svg

	cd ..
	mkdir Detailed
	mv 1-Demux 2-OTUAnalysis 3-AlphaDiversity 4-BetaDiversity 5-OTUPhylogenetics 6-AssociationAnalysis 7-FunctionAnalysis FigureandTable Detailed
	cd ..
}

MAIN() {

	echo "##############################################################\n#Organize the Detailed folder"
	organize_deliverable_structure $category_1

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

}

MAIN;