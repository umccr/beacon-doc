[![DOI](https://zenodo.org/badge/574717809.svg)](https://zenodo.org/badge/latestdoi/574717809)


# UMCCR Beacon Doc

Contains documentation and notes for UMCCR Beacon exploration and setup

## Context

Enhancing Australia's capability for secure and responsible sharing of human genome research data 

- https://www.biocommons.org.au/hgpp


## Implementations

### Serverless Beacon

- See https://github.com/umccr/sbeacon-exploration

### Java Beacon

- See [beacon/README.md](beacon)

## Demo

Our Java Beacon demo instance is available at https://faro.demo.umccr.org/beacon/

_Please note that this is for testing only. We may change the service without notice._

### Example Query

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


---


> DISCLAIMER: Unless otherwise noted specifically; instruction given here in this repo are not ready for production. You should consult with your organisation IT counterpart for appropriateness of the approach discussed here. See [LICENSE](LICENSE) 
