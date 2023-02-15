#! /bin/bash

echo `date` >> index.log
echo "--------------------------------" >> index.log

( time mongosh "mongodb://admin:admin@localhost:27017/beacon2?authSource=admin" --eval "db.Cohorts.createIndex({'id': 1}, {name: 'id', unique: true, background: true})" )                                    2>&1 | tee -a index.log
echo "--------------------------------" >> index.log

( time mongosh "mongodb://admin:admin@localhost:27017/beacon2?authSource=admin" --eval "db.Datasets.createIndex({'id': 1}, {name: 'id', unique: true, background: true})" )                                   2>&1 | tee -a index.log
echo "--------------------------------" >> index.log

( time mongosh "mongodb://admin:admin@localhost:27017/beacon2?authSource=admin" --eval "db.Analyses.createIndex({'id': 1}, {name: 'id', unique: true, background: true})" )                                   2>&1 | tee -a index.log
echo "--------------------------------" >> index.log

( time mongosh "mongodb://admin:admin@localhost:27017/beacon2?authSource=admin" --eval "db.Biosamples.createIndex({'id': 1}, {name: 'id', unique: true, background: true})" )                                 2>&1 | tee -a index.log
echo "--------------------------------" >> index.log

( time mongosh "mongodb://admin:admin@localhost:27017/beacon2?authSource=admin" --eval "db.Individuals.createIndex({'id': 1}, {name: 'id', unique: true, background: true})" )                                2>&1 | tee -a index.log
echo "--------------------------------" >> index.log

( time mongosh "mongodb://admin:admin@localhost:27017/beacon2?authSource=admin" --eval "db.Runs.createIndex({'id': 1}, {name: 'id', unique: true, background: true})" )                                       2>&1 | tee -a index.log
echo "--------------------------------" >> index.log

( time mongosh "mongodb://admin:admin@localhost:27017/beacon2?authSource=admin" --eval "db.Variants.createIndex({'id': 1}, {name: 'id', unique: true, background: true})" )                                   2>&1 | tee -a index.log
echo "--------------------------------" >> index.log

( time mongosh "mongodb://admin:admin@localhost:27017/beacon2?authSource=admin" --eval "db.Variants.createIndex({'variantInternalId': 1}, {name: 'variantInternalId', background: true})" )                   2>&1 | tee -a index.log
echo "--------------------------------" >> index.log

( time mongosh "mongodb://admin:admin@localhost:27017/beacon2?authSource=admin" --eval "db.Variants.createIndex({'_position.refseqId': 1}, {name: 'referenceName', background: true})" )                      2>&1 | tee -a index.log
echo "--------------------------------" >> index.log

( time mongosh "mongodb://admin:admin@localhost:27017/beacon2?authSource=admin" --eval "db.Variants.createIndex({'_position.assemblyId': 1}, {name: 'assemblyId', background: true})" )                       2>&1 | tee -a index.log
echo "--------------------------------" >> index.log

( time mongosh "mongodb://admin:admin@localhost:27017/beacon2?authSource=admin" --eval "db.Variants.createIndex({'molecularAtrributes.geneIds': 1}, {name: 'geneId', background: true})" )                    2>&1 | tee -a index.log
echo "--------------------------------" >> index.log

( time mongosh "mongodb://admin:admin@localhost:27017/beacon2?authSource=admin" --eval "db.Variants.createIndex({'molecularAttributes.aminoacidChanges': 1}, {name: 'aaChanges', background: true})" )        2>&1 | tee -a index.log
echo "--------------------------------" >> index.log

( time mongosh "mongodb://admin:admin@localhost:27017/beacon2?authSource=admin" --eval "db.Variants.createIndex({'caseLevelData.analysisId': 1}, {name: 'analysisId', background: true})" )                   2>&1 | tee -a index.log
echo "--------------------------------" >> index.log

( time mongosh "mongodb://admin:admin@localhost:27017/beacon2?authSource=admin" --eval "db.Variants.createIndex({'caseLevelData.biosampleId': 1}, {name: 'biosampleId', background: true})" )                 2>&1 | tee -a index.log
echo "--------------------------------" >> index.log

( time mongosh "mongodb://admin:admin@localhost:27017/beacon2?authSource=admin" --eval "db.Variants.createIndex({'caseLevelData.individualId': 1}, {name: 'individualId', background: true})" )               2>&1 | tee -a index.log
echo "--------------------------------" >> index.log

( time mongosh "mongodb://admin:admin@localhost:27017/beacon2?authSource=admin" --eval "db.Variants.createIndex({'caseLevelData.runId': 1}, {name: 'runId', background: true})" )                             2>&1 | tee -a index.log
echo "--------------------------------" >> index.log

echo `date` >> index.log

echo Done.
