.
├── 1-Demux 											1-Demux
│   ├── demux.qza											demultiplexedQiime2数据文件
│   ├── demux.qzv											demultiplexedQiime2展示文件
│   └── raw													原fastq文件夹
├── 2-OTUAnalysis 										2-OTUAnalysis
│   ├── 1000												在不同分类水平上丰度超过1000的所有OTU文件夹
│   │   ├── table-l2.1000.qza								门水平Qiime2数据文件
│   │   ├── table-l2.1000.qzv								门水平Qiime2展示文件
│   │   ├── table-l3.1000.qza								纲水平Qiime2数据文件
│   │   ├── table-l3.1000.qzv								纲水平Qiime2展示文件
│   │   ├── table-l4.1000.qza								目水平Qiime2数据文件
│   │   ├── table-l4.1000.qzv								目水平Qiime2展示文件
│   │   ├── table-l5.1000.qza								科水平Qiime2数据文件
│   │   ├── table-l5.1000.qzv								科水平Qiime2展示文件
│   │   ├── table-l6.1000.qza								属水平Qiime2数据文件
│   │   ├── table-l6.1000.qzv								属水平Qiime2展示文件
│   │   ├── table-l7.1000.qza								种水平Qiime2数据文件
│   │   └── table-l7.1000.qzv								种水平Qiime2展示文件
│   ├── Bacteria.phylogeny.pdf 								全部微生物的系统分析树图
│   ├── Bacteroidetes.phylogeny.pdf 						Bacteroidetes的系统分析树图
│   ├── Classified_stat_relative.svg 						注释程度
│   ├── Firmicutes.phylogeny.pdf 							Firmicutes的系统分析树图
│   ├── Proteobacteria.phylogeny.pdf 						Proteobacteria的系统分析树图
│   ├── dna-sequences.fasta 								OTU代表序列
│   ├── feature-table.ConsensusLineage.txt 					OTU文本文件1
│   ├── feature-table.biom									OTUbiom文件
│   ├── feature-table.taxonomy.biom 						OTUbiom文件有注释
│   ├── feature-table.taxonomy.txt 							OTU文本文件2
│   ├── phylogeny											iTOL文件夹
│   │   ├── dna-sequences.1000.aligned.masked.qza			iTOL分析绘图中间文件
│   │   ├── dna-sequences.1000.aligned.qza					iTOL分析绘图中间文件
│   │   ├── dna-sequences.1000.fasta 						iTOL分析绘图中间文件
│   │   ├── dna-sequences.1000.qza							iTOL分析绘图中间文件
│   │   ├── dna-sequences.1000.rooted-tree.qza 				iTOL分析绘图中间文件	
│   │   ├── dna-sequences.1000.unrooted-tree.qza			iTOL分析绘图中间文件
│   │   ├── feature-table.biom 								iTOL分析绘图中间文件
│   │   ├── feature-table.list 								iTOL分析绘图中间文件
│   │   ├── feature-table.taxonomy.biom 					iTOL分析绘图中间文件
│   │   ├── feature-table.taxonomy.txt 						iTOL分析绘图中间文件
│   │   ├── feature-table.txt  								iTOL分析绘图中间文件
│   │   ├── labels.txt 										iTOL绘图文件
│   │   ├── labels2.txt 									iTOL绘图文件
│   │   ├── table.1000.qza 									iTOL分析绘图中间文件
│   │   ├── taxonomy.1000.qza								iTOL分析绘图中间文件
│   │   ├── tol_multibar10.txt.txt 							iTOL绘图文件
│   │   ├── tol_ranges.txt 									iTOL绘图文件
│   │   └── tree.rooted.nwk 								iTOL绘图文件
│   ├── table.qzv											OTU基本数据Qiime2展示文件
│   ├── taxa-bar-plots.qzv									OTU分类Qiime2展示文件
│   ├── taxonomy.qzv										注释Qiime2展示文件
│   ├── tree.rooted.nwk										有根树
│   └── tree.unrooted.nwk									无根树
├── 3-AlphaDiversity									3-AlphaDiversity
│   ├── alpha 												alpha指数文件夹
│   │   ├── alpha-summary.tsv								alpha指数汇总
│   │   ├── chao1											chao1指数文件夹
│   │   │   ├── alpha-diversity.tsv							文本文件
│   │   │   └── alpha_diversity.qza 						Qiime2数据文件
│   │   ├── faith_pd 										faithpd指数文件夹
│   │   │   ├── alpha-diversity.tsv 						文本文件
│   │   │   └── alpha_diversity.qza 						Qiime2数据文件
│   │   ├── observed_otus 									observedOTU指数文件夹
│   │   │   ├── alpha-diversity.tsv 						文本文件
│   │   │   └── alpha_diversity.qza 						Qiime2数据文件
│   │   └── shannon 										shannon指数文件夹
│   │       ├── alpha-diversity.tsv 						文本文件
│   │       └── alpha_diversity.qza 						Qiime2数据文件
│   ├── alpha-rarefaction.qzv								alpha指数稀释曲线Qiime2展示文件			
│   ├── evenness-group-significance.qzv						evenness显著性Qiime2展示文件
│   ├── evenness_vector.qza									evenness显著性Qiime2数据文件
│   ├── faith-pd-group-significance.qzv 					faith-pd显著性Qiime2展示文件
│   ├── faith_pd_vector.qza									faith_pd显著性Qiime2数据文件
│   ├── observed_otus_vector.qza							observed_otus显著性Qiime2数据文件
│   ├── shannon-group-significance.qzv						shannon显著性Qiime2展示文件
│   └── shannon_vector.qza									shannon显著性Qiime2数据文件
├── 4-BetaDiversity 									4-BetaDiversity
│   ├── BetaDiversity_heatmap.svg							BetaDiversityheatmap图
│   ├── bray_NMDS.pdf 										BrayCurtisNMDS图
│   ├── bray_betadiversity_heatmap.pdf 						BrayCurtisheatmap图
│   ├── bray_curtis-Group1-significance.qzv					BrayCurtis显著性Qiime2展示文件
│   ├── bray_curtis-anosim-Group1-significance.qzv			BrayCurtis显著性Qiime2展示文件	
│   ├── bray_curtis-permanova-Group1-significance.qzv		BrayCurtis显著性Qiime2展示文件
│   ├── bray_curtis_distance_matrix.qza						BrayCurtis显著性Qiime2数据文件
│   ├── bray_curtis_emperor.qzv								BrayCurtisPCoAQiime2展示文件
│   ├── bray_curtis_pcoa_results.qza						BrayCurtisPCoAQiime2数据文件
│   ├── bray_matrix.csv 									BrayCurtis文本文件
│   ├── jaccard_NMDS.pdf   									jaccardNMDS图
│   ├── jaccard_betadiversity_heatmap.pdf 					jaccardheatmap图
│   ├── jaccard_matrix.csv 									jaccard文本文件	
│   ├── unifrac_NMDS.pdf 									unweighted-unifracdNMDS图
│   ├── unifrac_betadiversity_heatmap.pdf 					unweighted-unifracheatmap图
│   ├── unifrac_matrix.csv 									unweighted-unifrac文本文件		
│   ├── unweighted-unifrac-Group1-significance.qzv 			unweighted-unifracc显著性Qiime2展示文件
│   ├── unweighted-unifrac-anosim-Group1-significance.qzv 	unweighted-unifracc显著性Qiime2展示文件	
│   ├── unweighted-unifrac-permanova-Group1-significance.qzvunweighted-unifracc显著性Qiime2展示文件
│   ├── unweighted_unifrac_distance_matrix.qza 				unweighted-unifracQiime2数据文件
│   ├── unweighted_unifrac_emperor.qzv 						unweighted-unifracPCoAQiime2展示文件
│   ├── unweighted_unifrac_pcoa_results.qza 				unweighted-unifracPCoAQiime2展示文件
│   ├── weighted-unifrac-Group1-significance.qzv	  		weighted-unifrac显著性Qiime2展示文件
│   ├── weighted-unifrac-anosim-Group1-significance.qzv 	weighted-unifrac显著性Qiime2展示文件
│   ├── weighted-unifrac-permanova-Group1-significance.qzv 	weighted-unifrac显著性Qiime2展示文件
│   ├── weighted_unifrac_distance_matrix.qza 				weighted-unifracQiime2数据文件
│   ├── weighted_unifrac_emperor.qzv						weighted-unifracPCoAQiime2展示文件
│   ├── weighted_unifrac_pcoa_results.qza					weighted-unifracPCoAQiime2展示文件
│   ├── wunifrac_NMDS.pdf 									weighted-unifracheatmap图
│   ├── wunifrac_betadiversity_heatmap.pdf 					weighted-unifracheatmap图
│   └── wunifrac_matrix.csv 								weighted-unifrac文本文件							
├── 5-OTUComparision									5-OTUComparision
│   ├── ANCOM
│ 	│   ├── ANCOM.l2.qzv 									门水平OTU显著性分析Qiime2数据文件
│ 	│   ├── ANCOM.l3.qzv 									纲水平OTU显著性分析Qiime2数据文件
│ 	│   ├── ANCOM.l4.qzv 									目水平OTU显著性分析Qiime2数据文件	
│ 	│   ├── ANCOM.l5.qzv 									科水平OTU显著性分析Qiime2数据文件	
│ 	│   ├── ANCOM.l6.qzv 									属水平OTU显著性分析Qiime2数据文件	
│ 	│   ├── ANCOM.l7.qzv 									种水平OTU显著性分析Qiime2数据文件	
│ 	│   ├── composition.l2.qza 								门水平OTU显著性分析中间文件
│ 	│   ├── composition.l3.qza 								纲水平OTU显著性分析中间文件
│ 	│   ├── composition.l4.qza 								目水平OTU显著性分析中间文件
│ 	│   ├── composition.l5.qza 								科水平OTU显著性分析中间文件
│ 	│   ├── composition.l6.qza 								属水平OTU显著性分析中间文件
│ 	│   ├── composition.l7.qza 								种水平OTU显著性分析中间文件
│   └── table-l7.qzv 										共享OTUQiime2展示文件
├── 6-FunctionAnalysis									6-FunctionAnalysis
│   ├── PCA_L1												PICRUSt结果一级功能PCA图
│   ├── PCA_L2												PICRUSt结果一级功能PCA图
│   ├── PCA_L3 												PICRUSt结果一级功能PCA图				
│   ├── clustered_table.qzv 								功能分析中间文件
│   ├── clustered_table.qzv 								功能分析中间文件			
│   ├── feature-table.biom 									功能分析中间文件
│   ├── feature-table.metagenome.KEGG_Pathways.STAMP.spf 	STAMP输入文件
│   ├── feature-table.metagenome.L1.txt 					PICRUSt结果一级功能文件
│   ├── feature-table.metagenome.L2.txt 					PICRUSt结果二级功能文件
│   ├── feature-table.metagenome.L3.txt 					PICRUSt结果三级功能文件
│   ├── feature-table.metagenome.biom						功能分析中间文件
│   ├── feature-table.normalized.biom 						功能分析中间文件			
│   ├── feature-table.txt 									功能分析中间文件	
│   ├── level1.relative.tree 								功能分析中间文件	
│   ├── percent.feature-table.metagenome.L1.svg				PICRUSt结果一级功能柱形图
│   ├── percent.feature-table.metagenome.L1.tab 			功能分析中间文件		
│   ├── percent.feature-table.metagenome.L1.txt 			功能分析中间文件	
│   ├── percent.feature-table.metagenome.L2.svg 			PICRUSt结果二级功能柱形图
│   ├── percent.feature-table.metagenome.L2.tab 			功能分析中间文件
│   ├── percent.feature-table.metagenome.L2.txt       		功能分析中间文件
│   ├── percent.feature-table.metagenome.L3.svg 			PICRUSt结果三级功能柱形图
│   ├── percent.feature-table.metagenome.L3.tab 			功能分析中间文件
│   ├── percent.feature-table.metagenome.L3.txt 			功能分析中间文件
│   ├── tree.feature-table.metagenome.L1.svg 				PICRUSt结果一级功能树图
│   ├── tree.feature-table.metagenome.L2.svg 				PICRUSt结果二级功能树图	
│   ├── tree.feature-table.metagenome.L3.svg 				PICRUSt结果三级功能树图	
│   ├── unmatched_sequences.qza  							功能分析中间文件
│   └── unmatched_sequences.qzv 							功能分析中间文件
├── FigureandTable 										FigureandTable表格及图表文件夹
│   ├── Figure3-1.svg -> ../2-OTUAnalysis/Classified_stat_relative.svg
│   ├── Figure3-10.pdf -> ../4-BetaDiversity/unifrac_NMDS.pdf
│   ├── Figure3-11.qzv -> ../4-BetaDiversity/unweighted-unifrac-permanova-Group1-significance.qzv
│   ├── Figure3-12.qzv -> ../5-OTUComparision/ANCOM/ANCOM.l7.qzv
│   ├── Figure3-14.svg -> ../6-FunctionAnalysis/percent.feature-table.metagenome.L1.svg
│   ├── Figure3-15.pdf -> ../6-FunctionAnalysis/PCA_L1/PCA-2D.pdf
│   ├── Figure3-16.svg -> ../6-FunctionAnalysis/tree.feature-table.metagenome.L1.svg
│   ├── Figure3-2.qzv -> ../2-OTUAnalysis/taxa-bar-plots.qzv
│   ├── Figure3-3.qzv -> ../2-OTUAnalysis/1000/table-l2.1000.qzv
│   ├── Figure3-6.qzv -> ../3-AlphaDiversity/shannon-group-significance.qzv
│   ├── Figure3-7.qzv -> ../3-AlphaDiversity/faith-pd-group-significance.qzv
│   ├── Figure3-8.svg -> ../4-BetaDiversity/BetaDiversity_heatmap.svg
│   ├── Figure3-9.qzv -> ../4-BetaDiversity/unweighted_unifrac_emperor.qzv
│   ├── Table3-2.tsv -> ../3-AlphaDiversity/alpha/alpha-summary.tsv
│   ├── Table3-3.qzv -> ../3-AlphaDiversity/faith-pd-group-significance.qzv
│   ├── Table3-4.qzv -> ../4-BetaDiversity/unweighted-unifrac-permanova-Group1-significance.qzv
│   ├── Table3-5.qzv -> ../5-OTUComparision/ANCOM/ANCOM.l7.qzv
│   └── Table3-6.qzv -> ../5-OTUComparision/table-l7.qzv
└── Result_README.txt                               				说明文件
