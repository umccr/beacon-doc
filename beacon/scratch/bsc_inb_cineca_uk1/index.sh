#! /bin/bash

# Source from https://gitlab.bsc.es/inb/ga4gh/beacon-v2-docker-demo/-/blob/master/mongo/mongodb-data-import.sh
# observed at commit 9e954e9435f36927ca61d797addea70d66896710

mongosh "mongodb://admin:admin@localhost:27017/beacon?authSource=admin" --eval "db.Analyses.createIndex({'id': 1}, {name: 'id', unique: true, background: true})"
mongosh "mongodb://admin:admin@localhost:27017/beacon?authSource=admin" --eval "db.Biosamples.createIndex({'id': 1}, {name: 'id', unique: true, background: true})"
mongosh "mongodb://admin:admin@localhost:27017/beacon?authSource=admin" --eval "db.Variants.createIndex({'id': 1}, {name: 'id', unique: true, background: true})"
mongosh "mongodb://admin:admin@localhost:27017/beacon?authSource=admin" --eval "db.Variants.createIndex({'molecularAtrributes.geneIds': 1}, {name: 'geneId', background: true})"
mongosh "mongodb://admin:admin@localhost:27017/beacon?authSource=admin" --eval "db.Variants.createIndex({'variantInternalId': 1}, {name: 'variantInternalId', background: true})"
mongosh "mongodb://admin:admin@localhost:27017/beacon?authSource=admin" --eval "db.Variants.createIndex({'molecularAttributes.aminoacidChanges': 1}, {name: 'aaChanges', background: true})"
mongosh "mongodb://admin:admin@localhost:27017/beacon?authSource=admin" --eval "db.Variants.createIndex({'position.refseqId': 1}, {name: 'referenceName', background: true})"
mongosh "mongodb://admin:admin@localhost:27017/beacon?authSource=admin" --eval "db.Variants.createIndex({'caseLevelData.analysisId': 1}, {name: 'analysisId', background: true})"
mongosh "mongodb://admin:admin@localhost:27017/beacon?authSource=admin" --eval "db.Variants.createIndex({'caseLevelData.biosampleId': 1}, {name: 'biosampleId', background: true})"
mongosh "mongodb://admin:admin@localhost:27017/beacon?authSource=admin" --eval "db.Variants.createIndex({'caseLevelData.individualId': 1}, {name: 'individualId', background: true})"
mongosh "mongodb://admin:admin@localhost:27017/beacon?authSource=admin" --eval "db.Variants.createIndex({'caseLevelData.runId': 1}, {name: 'runId', background: true})"
mongosh "mongodb://admin:admin@localhost:27017/beacon?authSource=admin" --eval "db.Individuals.createIndex({'id': 1}, {name: 'id', unique: true, background: true})"
mongosh "mongodb://admin:admin@localhost:27017/beacon?authSource=admin" --eval "db.Runs.createIndex({'id': 1}, {name: 'id', unique: true, background: true})"
