[![DOI](https://zenodo.org/badge/574717809.svg)](https://zenodo.org/badge/latestdoi/574717809)


# UMCCR Beacon Doc

Contains documentation and notes for UMCCR Beacon exploration and setup

## Context

Enhancing Australia's capability for secure and responsible sharing of human genome research data 

- https://www.biocommons.org.au/hgpp

Virtual Cohort Assembly Discovery Phase Report: National Community Needs & Candidate Solutions

- https://doi.org/10.5281/zenodo.7439886


## Implementations

We are investigating 2 Beacon v2 implementations as follows.

### Serverless Beacon

- See https://github.com/umccr/sbeacon-exploration

### Java Beacon

- See [beacon/README.md](beacon)

## Demo instance

Our Java Beacon demo instance is available at https://faro.demo.umccr.org/beacon/

_Please note that this is for testing only. We may change the service without notice._

## Example queries

```
curl -s 'https://faro.demo.umccr.org/beacon/v2.0.0/info' | jq
curl -s 'https://faro.demo.umccr.org/beacon/v2.0.0/service-info' | jq
curl -s 'https://faro.demo.umccr.org/beacon/v2.0.0/map' | jq
curl -s 'https://faro.demo.umccr.org/beacon/v2.0.0/configuration' | jq
curl -s 'https://faro.demo.umccr.org/beacon/v2.0.0/cohorts' | jq
curl -s 'https://faro.demo.umccr.org/beacon/v2.0.0/datasets' | jq
curl -s 'https://faro.demo.umccr.org/beacon/v2.0.0/runs' | jq
curl -s 'https://faro.demo.umccr.org/beacon/v2.0.0/analyses' | jq
curl -s 'https://faro.demo.umccr.org/beacon/v2.0.0/individuals?limit=10' | jq
curl -s 'https://faro.demo.umccr.org/beacon/v2.0.0/biosamples?limit=10' | jq
curl -s 'https://faro.demo.umccr.org/beacon/v2.0.0/g_variants?limit=10' | jq
```

## Scenarios

- Give me some 10 counts of G>C at POS between start 150000, end 150100
```
curl -s 'https://faro.demo.umccr.org/beacon/v2.0.0/g_variants?start=150000&end=150100&referenceBases=G&alternateBases=C&limit=10' | jq > out_pos.json
```

- How many found?

```
jq -c '.responseSummary' out_pos.json
{"exists":true,"numTotalResults":2}
```

- Give me some 10 counts of Chromosome 22 G>A SNP
```
curl -s 'https://faro.demo.umccr.org/beacon/v2.0.0/g_variants?variantType=SNP&referenceName=22&referenceBases=G&alternateBases=A&limit=10' | jq > out.json
```

- Does this SNP exist and are there at least 10 count?

```
jq -c '.responseSummary' out.json
{"exists":true,"numTotalResults":10}
```

- Let grab the first variant record "variantInternalId"

```
jq -c '.response.resultSets[0].results[0].variantInternalId' out.json
"chrchr22_10584988_G_A"
```

- Let check details for this variant

```
curl -s 'https://faro.demo.umccr.org/beacon/v2.0.0/g_variants/chrchr22_10584988_G_A' | jq
```

- Give me all BioSamples of this variant record

```
curl -s 'https://faro.demo.umccr.org/beacon/v2.0.0/g_variants/chrchr22_10584988_G_A/biosamples' | jq
```

## Known Issues

### Need back filling caseLevelData

At the moment, the following associated entities fetching query does not work.

```
curl -s 'https://faro.demo.umccr.org/beacon/v2.0.0/g_variants/chrchr22_10584988_G_A/individuals' | jq
curl -s 'https://faro.demo.umccr.org/beacon/v2.0.0/g_variants/chrchr22_10584988_G_A/analyses' | jq
curl -s 'https://faro.demo.umccr.org/beacon/v2.0.0/g_variants/chrchr22_10584988_G_A/runs' | jq
```

This is due to the fact that it missed `caseLevelData` of related meta info for the variant; except `biosampleId` that has transformed from VCF sample ID; during VCF2JSON data processing step.

```
    "caseLevelData": [
      {
        "individualId": null,
        "biosampleId": "HG00128",
        "analysisId": null,
        "zigosity": null,
        "alleleOrigin": null,
        "clinicalInterpretations": null,
        "phenotypicEffects": null
      },
      ...
```

If we attempt to back-fill this data lineage, we will have to go through all variants [~85mil](beacon/scratch/umccr_cineca_uk1). Computation cost is -- `per variant * number of caseLevelData points`.

This highlight the importance of data processing step in this approach. Alternatively, we could solve it at the application implementation end. At the moment, we would not further pursuit for either solution. But noted as known issue. 

- https://github.com/EGA-archive/beacon2-ri-tools/issues/15

---


> DISCLAIMER: Unless otherwise noted specifically; instruction given here in this repo are not ready for production. You should consult with your organisation IT counterpart for appropriateness of the approach discussed here. See [LICENSE](LICENSE) 
