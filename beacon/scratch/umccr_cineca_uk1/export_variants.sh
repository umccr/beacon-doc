#!/usr/bin/env bash

mongoexport --uri="mongodb://admin:admin@localhost:27017/beacon2?authSource=admin" --collection="Variants" --query="{}" --limit=1000 --out="genomicVariations.json"
