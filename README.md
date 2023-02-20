# githubtestfatma
# impoting data to qiime2
qiime tools import \
  --type 'SampleData[SequencesWithQuality]' \
  --input-path demultiplexeddata \
  --input-format CasavaOneEightSingleLanePerSampleDirFmt \
  --output-path demux-single-end.qza
  
 # demultiplexing, it’s useful to generate a summary of the demultiplexing results. This allows you to determine how many sequences were obtained per sample
 qiime demux summarize \
  --i-data demux-single-end.qza \
  --o-visualization demux.qzv

# Denoising, Trimming and Truncating (Quality Control) using DADA2
qiime dada2 denoise-single \
  --i-demultiplexed-seqs demux-single-end.qza \
  --p-trim-left 20 \
  --p-trunc-len 240 \
  --o-representative-sequences rep-seqs-dada2.qza \
  --o-table table-dada2.qza \
  --o-denoising-stats stats-dada2.qza

qiime metadata tabulate \
  --m-input-file stats-dada2.qza \
  --o-visualization stats-dada2.qzv

# Feature Table and Feature Data Summary
qiime feature-table summarize \
  --i-table table.qza \
  --o-visualization table.qzv \
  --m-sample-metadata-file sample-metadata.tsv
qiime feature-table tabulate-seqs \
  --i-data rep-seqs.qza \
  --o-visualization rep-seqs.qzv

# Phylogenetic Tree Construction
 qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences rep-seqs.qza \
  --o-alignment aligned-rep-seqs.qza \
  --o-masked-alignment masked-aligned-rep-seqs.qza \
  --o-tree unrooted-tree.qza \
  --o-rooted-tree rooted-tree.qza

# Visualization of the tree
qiime tools export \
--input-path rooted-tree.qza \
--output-path rooted-tree.nwk

# Alpha Diversity Analysis
qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/faith_pd_vector.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization core-metrics-results/faith-pd-group-significance.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/evenness_vector.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization core-metrics-results/evenness-group-significance.qzv

# Beta Diversity Analysis
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny rooted-tree.qza \
  --i-table table.qza \
  --p-sampling-depth 24467 \
  --m-metadata-file sample-metadata.tsv \
  --output-dir core-metrics-results

# Beta Group Significance Analysis (PERMANOVA)
qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file sample-metadata.tsv \
  --m-metadata-column Counties \
  --o-visualization core-metrics-results/unweighted-unifrac-county-significance.qzv \
  --p-pairwise

qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/weighted_unifrac_distance_matrix.qza \
  --m-metadata-file sample-metadata.tsv \
  --m-metadata-column Counties \
  --o-visualization core-metrics-results/weighted-unifrac-county-significance.qzv \
  --p-pairwise
  
  # Alpha Rarefraction Plotting
  qiime diversity alpha-rarefaction \
  --i-table table.qza \
  --i-phylogeny rooted-tree.qza \
  --p-max-depth 24462 \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization alpha-rarefaction.qzv

# Taxonomic Analysis
# Download the trained naive Bayes classifier for the v4 hypervariable region
wget "https://data.qiime2.org/2021.4/common/gg-13-8-99-515-806-nb-classifier.qza"

qiime feature-classifier classify-sklearn \
  --i-classifier gg-13-8-99-515-806-nb-classifier.qza \
  --i-reads rep-seqs.qza \
  --o-classification taxonomy.qza
 
 wget "https://data.qiime2.org/2021.4/common/silva-138-99-515-806-nb-classifier.qza"
 # if you use silva database 
  qiime feature-classifier classify-sklearn \
  --i-classifier silva-138-99-515-806-nb-classifier.qza \
  --i-reads rep-seqs.qza \
  --o-classification taxonomy.qza

qiime metadata tabulate \
  --m-input-file taxonomy.qza \
  --o-visualization taxonomy.qzv
  
  # For fungi use UNITE
  qiime feature-classifier classify-sklearn \
  --i-classifier unite-ver7-99-classifier-01.12.2017.qza \
  --i-reads rep-seqs-dada2.qza\
  --o-classification taxonomy-single-end.qza
  
  qiime taxa barplot \
  --i-table table.qza \
  --i-taxonomy taxonomy.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization taxa-bar-plots.qzv




