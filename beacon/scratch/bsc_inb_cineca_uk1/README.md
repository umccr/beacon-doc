# BSC INB CINECA UK1 Cohort

This _(VCF down-sampled)_ CINECA UK1 cohort dataset prepared by BSC/INB Java implementation at the following.

https://gitlab.bsc.es/inb/ga4gh/beacon-v2-docker-demo/-/tree/master/beacon-data

## Notes

- This dataset contains **only Chromosome 22 variants** i.e. ~1.3% of original joint called VCF.
- See --
  - https://b2ri-documentation.readthedocs.io/en/latest/synthetic-dataset/
  - https://github.com/ga4gh-beacon/B2RI_Documentation/blob/main/docs/synthetic-dataset.md

Quote:

> - We have included the [CINECA_synthetic_cohort_EUROPE_UK1](https://www.cineca-project.eu/cineca-synthetic-datasets) (license: CC-BY) dataset to test B2RI functionalities.
> - The dataset was acquired from EGA (EGAD00001006673), please see the full description [here](https://ega-archive.org/datasets/EGAD00001006673).
> - The [original VCF](https://www.nature.com/articles/nature15393) for this dataset contains >85M variants for 2,504 samples (low coverage WGS). Here, we have included only genomicVariations for chromosome 22 that contains ~1.1M variants. Please contact `helpdesk@ega-archive.org` should you want get access to the whole dataset.


## Download

First, download the data. Typically, this should be executed on the host VM.

> Tip: Download may take a while. You might want to run it in `screen` or `tmux` session! 

```
bash download.sh
```

After download completed, they should have the following checksum. If not, upstream might have updated the dataset.

```
md5sum beacon-data/*.lzma
47a4e46f5e62a01f512c32789a0f7357  beacon-data/analyses.json.lzma
8dce4faa9deb81aa5b8b6f04d255af32  beacon-data/biosamples.json.lzma
5331feecbec2db55b38561541a2f1dbf  beacon-data/cohorts.json.lzma
0c35e06a1d4eadecc2f318a93520d255  beacon-data/datasets.json.lzma
43d7c81451cbabf351c3b0715de99b8b  beacon-data/genomicVariationsVcf.json.lzma
4392c976126c2c9a60e9e04023f9caea  beacon-data/individuals.json.lzma
765210cfcb982afbc79ae5b713eacc2c  beacon-data/runs.json.lzma
484110836b8d0c2ea793e9c248abb41e  beacon-data/usecase-1.patients.json.lzma
dc3f756fc0150715fa44df44ef493f98  beacon-data/usecase-1.variants.json.lzma
```

## Import

We can import this dataset from host VM or, inside mongodb container. Choose whichever suit for your case. In the following, we will perform this task inside mongodb container.

```
docker compose exec -it mongodb bash

root@mongodb:/# apt-get update -y
root@mongodb:/# apt-get install -y xz-utils

root@mongodb:/# cd /scratch/bsc_inb_cineca_uk1/

root@mongodb:/scratch/bsc_inb_cineca_uk1# bash import.sh
root@mongodb:/scratch/bsc_inb_cineca_uk1# bash index.sh
root@mongodb:/scratch/bsc_inb_cineca_uk1# exit
```

See [import.log](import.log) for example run and time taken. Approx 30 minutes on some _slow_ laptop. :)

## Disk Usage

> "The Docker Compose git repository contains synthetic cohorts datasets provided by the CINECA project. The datasets are compressed with lzma compressor. Note that compressed genomic variation data is 269 Mb big, while uncompressed it occupies almost 12 Gb. The script that initializes the database decompresses it on-the-fly, but it is still needed around 2 Gb of disk space."
> -- [_Open source Java implementation of the Beacon v2 API_](https://f1000research.com/posters/11-610)

Disk usage comparison as follows.

```
chr22.Test.1000G.phase3.joint.vcf.gz                            248MB  (0.248GB)
genomicVariationsVcf.json.lzma                                  269MB  (0.269GB)
genomicVariationsVcf.json (size required for data processing)   12GB
genomicVariationsVcf.json (MongoDB table size)                  2GB
```

Therefore, storage space required for the target VCF file by approximately:
- 13x during data processing and 
- 3x for running "Genomic Table" as MongoDB table backend

### MongoDB Indexing

TODO // MongoDB required minimal operational indexes to meet the transactional application REST query response time -- _to capture indexing time and space_ and, _need work on indexing script_

FIXME // _double-check with Flo on above Maths_ :)

---


Source: https://github.com/EGA-archive/beacon2-ri-tools/tree/main/CINECA_synthetic_cohort_EUROPE_UK1#external-files-crg-public-ftp-site

```
md5sum chr22.Test.1000G.phase3.joint.vcf.gz
db14d823817114a2d4fdcbf3749bf76d  chr22.Test.1000G.phase3.joint.vcf.gz
```
