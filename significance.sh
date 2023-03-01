qiime diversity alpha-group-significance \
--i-alpha-diversity core-metrics-results/faith_pd_vector.qza \
--m-metadata-file sample-metadata.tsv \
--o-visualization core-metrics-results/faith-pd-group-significance.qzv

#Evenness
qiime diversity alpha-group-significance \
--i-alpha-diversity core-metrics-results/evenness_vector.qza \
--m-metadata-file sample-metadata.tsv \
--o-visualization core-metrics-results/evennes-alpha-correlation.qzv

#Shannon_diversity
qiime diversity alpha-group-significance \
--i-alpha-diversity core-metrics-results/shannon_vector.qza \
--m-metadata-file sample-metadata.tsv \
--o-visualization core-metrics-results/shannon-diversity.qzv

#Beta Diversity Analyses
#There are both Orrdination analyses and Principal Coordinates Analysis
#Ordination
qiime emperor plot \
--i-pcoa core-metrics-results/unweighted_unifrac_pcoa_results.qza \
--m-metadata-file sample-metadata.tsv \
--o-visualization core-metrics-results/unweighted-unifrac-emperor.qzv

#Alpha rare-faction
#Pick whatever sampling depth is ideal for your samples
qiime diversity alpha-rarefaction \
--i-table table-dada2.qza \
--i-phylogeny rooted-tree.qza \
--p-max-depth 25000 \
--m-metadata-file sample-metadata.tsv \
--o-visualization alpha-rarefaction.qzv

#Group significance
qiime diversity beta-group-significance \
--i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza \
--m-metadata-file sample-metadata.tsv \
--m-metadata-column Counties \
--p-pairwise \
--o-visualization core-metrics-results/unweighted-unifrac-Counties-significance.qzv

