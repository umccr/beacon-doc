echo "Importing GIAB_TESTING cohort datasets"

mongoimport --jsonArray --uri "mongodb://admin:admin@127.0.0.1:27017/beacon?authSource=admin" --file json/analyses*.json --collection Analyses
mongoimport --jsonArray --uri "mongodb://admin:admin@127.0.0.1:27017/beacon?authSource=admin" --file json/biosamples*.json --collection Biosamples
mongoimport --jsonArray --uri "mongodb://admin:admin@127.0.0.1:27017/beacon?authSource=admin" --file json/cohorts*.json --collection Cohorts
mongoimport --jsonArray --uri "mongodb://admin:admin@127.0.0.1:27017/beacon?authSource=admin" --file json/datasets*.json --collection Datasets
mongoimport --jsonArray --uri "mongodb://admin:admin@127.0.0.1:27017/beacon?authSource=admin" --file json/individuals*.json --collection Individuals
mongoimport --jsonArray --uri "mongodb://admin:admin@127.0.0.1:27017/beacon?authSource=admin" --file json/runs*.json --collection Runs
mongoimport --jsonArray --uri "mongodb://admin:admin@127.0.0.1:27017/beacon?authSource=admin" --file json/genomicVariations*.json --collection Variants
