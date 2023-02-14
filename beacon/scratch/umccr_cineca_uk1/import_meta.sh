#! /bin/bash

date

( time mongoimport --uri="mongodb://admin:admin@localhost:27017/beacon2?authSource=admin" --collection=Cohorts --type=json --jsonArray --file <(gzip -d -c -k -q ./beacon-data/cohorts.json.gz) )           2>&1 | tee import_cohorts.log
( time mongoimport --uri="mongodb://admin:admin@localhost:27017/beacon2?authSource=admin" --collection=Datasets --type=json --jsonArray --file <(gzip -d -c -k -q ./beacon-data/datasets.json.gz) )         2>&1 | tee import_datasets.log
( time mongoimport --uri="mongodb://admin:admin@localhost:27017/beacon2?authSource=admin" --collection=Analyses --type=json --jsonArray --file <(gzip -d -c -k -q ./beacon-data/analyses.json.gz) )         2>&1 | tee import_analyses.log
( time mongoimport --uri="mongodb://admin:admin@localhost:27017/beacon2?authSource=admin" --collection=Runs --type=json --jsonArray --file <(gzip -d -c -k -q ./beacon-data/runs.json.gz) )                 2>&1 | tee import_runs.log
( time mongoimport --uri="mongodb://admin:admin@localhost:27017/beacon2?authSource=admin" --collection=Biosamples --type=json --jsonArray --file <(gzip -d -c -k -q ./beacon-data/biosamples.json.gz) )     2>&1 | tee import_biosamples.log
( time mongoimport --uri="mongodb://admin:admin@localhost:27017/beacon2?authSource=admin" --collection=Individuals --type=json --jsonArray --file <(gzip -d -c -k -q ./beacon-data/individuals.json.gz) )   2>&1 | tee import_individuals.log

date

echo Done.
