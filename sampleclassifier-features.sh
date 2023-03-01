qiime taxa collapse \
  --i-table bacteria-OTU-table.qza \
  --i-taxonomy taxonomy-bacteria.qza \
  --p-level 6 \                                         
  --o-collapsed-table collapsed-six-table.qza

biom convert -i bacteria-feature-table.tsv -o convertedbacteria_table.biom --to-hdf5

qiime tools import \
  --input-path convertedbacteria_table.biom \
  --type 'FeatureTable[Frequency]' \
  --input-format BIOMV210Format \
  --output-path bacteria-OTU-table.qza

qiime feature-table summarize \
  --i-table bacteria-OTU-table.qza \
  --o-visualization bacteria-OTU-table.qzv \
  --m-sample-metadata-file sample-metadata.tsv

qiime tools import \
  --type 'FeatureData[Taxonomy]' \
  --input-format HeaderlessTSVTaxonomyFormat \
  --input-path taxonomy.bacteria.OTU.txt \
  --output-path taxonomy-bacteria.qza

qiime metadata tabulate \
 --m-input-file taxonomy-bacteria.qza \
 --o-visualization taxonomy-bacteria.qzv

qiime taxa barplot \
 --i-table bacteria-OTU-table.qza \
 --i-taxonomy taxonomy-bacteria.qza \
 --m-metadata-file sample-metadata.tsv \
 --o-visualization bacteria-taxa-barplot.qzv

qiime sample-classifier classify-samples \
  --i-table bacteria-OTU-table.qza \
  --m-metadata-file sample-metadata.tsv \
  --m-metadata-column Counties \
  --p-test-size 0.2 \
  --p-cv 3 \
  --p-optimize-feature-selection \
  --p-parameter-tuning \
  --p-estimator RandomForestClassifier \
  --p-n-estimators 100 \
  --output-dir sample-classifier-bacteria-OTU-results

qiime sample-classifier classify-samples \
  --i-table bacteria-OTU-table.qza \
  --m-metadata-file sample-metadata.tsv \
  --m-metadata-column Counties \
  --p-cv 3 \
  --p-optimize-feature-selection \
  --p-no-parameter-tuning \
  --p-estimator RandomForestClassifier \
  --p-n-estimators 20 \
  --p-random-state 123 \
  --output-dir sample-classifier-bacteria-OTU11-results

qiime metadata tabulate \
  --m-input-file feature_importance.qza \
  --o-visualization feature_importance.qzv

qiime feature-table filter-features \
  --i-table bacteria-OTU-table.qza \
  --m-metadata-file feature_importance.qza \
  --o-filtered-table important-bacteria-feature-table.qza

qiime sample-classifier heatmap \
  --i-table bacteria-OTU-table.qza \
  --i-importance feature_importance.qza \
  --m-sample-metadata-file sample-metadata.tsv \
  --m-sample-metadata-column Counties \
  --p-group-samples \
  --p-feature-count 20 \
  --o-filtered-table important-bacteria-feature-table-top-20.qza \
  --o-heatmap important-bacteria-feature-heatmap.qzv

#visualize
qiime metadata tabulate \
  --m-input-file important-bacteria-feature-table-top-20.qza \
  --o-visualization important-bacteria-feature-table-top-20.qzv
