#! /bin/bash

# Source from https://gitlab.bsc.es/inb/ga4gh/beacon-v2-docker-demo/-/blob/master/mongo/mongodb-data-import.sh
# observed at commit 9e954e9435f36927ca61d797addea70d66896710

mongoimport --uri="mongodb://admin:admin@localhost:27017/beacon?authSource=admin" --collection=Analyses --type=json --jsonArray --file <(xz -d -c -q -q ./beacon-data/analyses.json.lzma)
mongoimport --uri="mongodb://admin:admin@localhost:27017/beacon?authSource=admin" --collection=Biosamples --type=json --jsonArray --file <(xz -d -c -q -q ./beacon-data/biosamples.json.lzma)
mongoimport --uri="mongodb://admin:admin@localhost:27017/beacon?authSource=admin" --collection=Cohorts --type=json --jsonArray --file <(xz -d -c -q -q ./beacon-data/cohorts.json.lzma)
mongoimport --uri="mongodb://admin:admin@localhost:27017/beacon?authSource=admin" --collection=Datasets --type=json --jsonArray --file <(xz -d -c -q -q ./beacon-data/datasets.json.lzma)
mongoimport --uri="mongodb://admin:admin@localhost:27017/beacon?authSource=admin" --collection=Variants --type=json --jsonArray --file <(xz -d -c -q -q ./beacon-data/genomicVariationsVcf.json.lzma)
mongoimport --uri="mongodb://admin:admin@localhost:27017/beacon?authSource=admin" --collection=Individuals --type=json --jsonArray --file <(xz -d -c -q -q ./beacon-data/individuals.json.lzma)
mongoimport --uri="mongodb://admin:admin@localhost:27017/beacon?authSource=admin" --collection=Runs --type=json --jsonArray --file <(xz -d -c -q -q ./beacon-data/runs.json.lzma)

#mongoimport --uri="mongodb://admin:admin@localhost:27017/beacon?authSource=admin" --collection=Individuals --type=json --jsonArray --file <(xz -d -c -q -q ./beacon-data/usecase-1.patients.json.lzma)
#mongoimport --uri="mongodb://admin:admin@localhost:27017/beacon?authSource=admin" --collection=Variants --type=json --jsonArray --file <(xz -d -c -q -q ./beacon-data/usecase-1.variants.json.lzma)
