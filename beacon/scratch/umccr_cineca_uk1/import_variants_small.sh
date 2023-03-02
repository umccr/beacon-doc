#! /bin/bash

date

( time mongoimport --uri="mongodb://admin:admin@localhost:27017/beacon2?authSource=admin" --collection=Variants --file <(gzip -d -c -k -q ./beacon-data/genomicVariations.json.gz) )           2>&1 | tee import_variants_small.log

date

echo Done.
