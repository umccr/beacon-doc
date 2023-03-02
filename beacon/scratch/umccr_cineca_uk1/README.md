# UMCCR CINECA UK1

This activity contains data preparation steps for the full CINECA dataset into MongoDB

## Required

- The following dataset is prepared for BSC/INB Java Beacon implementation (See [beacon/README](../../../beacon))
- It may not be compatible with any other Beacon implementation

## VCF2JSON

This is prepared as follows.

- Request the original [VCF from EGA](https://www.cineca-project.eu/synthetic-data/scd-europe-uk1)
- Perform Hg38 liftover for VCF
- Split VCF by chromosomes
- Use [beacon2-ri-tools](https://github.com/EGA-archive/beacon2-ri-tools#containerized) to process them

## Metadata

This is prepared as follows.

- Download `Beacon-v2-Models_CINECA_UK1MS.xlsx` from the following --
  - https://github.com/umccr/sbeacon-exploration/tree/main/data/CINECA_synthetic_cohort_EUROPE_UK1
- Use [CINECA_UK1C-MSJ.ipynb](CINECA_UK1C-MSJ.ipynb) to transform metadata from Excel to JSON

## Import

This is done as follows.

- _NOTE: We will use database name `beacon2`_
- Use [import_variants.sh](import_variants.sh) for importing Variants JSONs into MongoDB
- Use [import_meta.sh](import_meta.sh) for importing Metadata JSONs into MongoDB
- Use [export_variants.sh](export_variants.sh) for exporting some first 1000 records from Variants collection
- Use [import_variants_small.sh](import_variants_small.sh) for importing exported Variants (first 1000 documents) for local development and/or quick demo purpose

![mongoimport_gzip.png](mongoimport_gzip.png)

_Observe that `mongoimport` CLI tool internally parallelize the process. We feed it with gzip decompression stdout stream._

## Update DB User Role

```
mongosh -u admin -p admin

test> use admin
switched to db admin

admin> db.grantRolesToUser("beacon", [{ role: 'readWrite', db: 'beacon2' }])
{ ok: 1 }

admin> db.getUsers({})
{
  users: [
    {
      <snip>
    },
    {
      user: 'beacon',
      db: 'admin',
      roles: [
        { role: 'readWrite', db: 'beacon' },
        { role: 'readWrite', db: 'beacon2' }
      ],
      mechanisms: [ 'SCRAM-SHA-1', 'SCRAM-SHA-256' ]
    }
  ],
  ok: 1
}

admin> quit
```

## Update Application

### Change DB Connection

- Update either [docker-compose.yml](../../../beacon/docker-compose.yml) or, better yet, use [docker-compose.override.yml](../../../beacon/docker-compose.override.sample.yml) to override to use `beacon2` database

```
wildfly:
    ...
    environment:
      - mongodb.url=mongodb://beacon:beacon@mongodb:27017/beacon2?authSource=admin
```

### Restart the stack

```
docker compose down
docker compose up -d
```

### Deploy App

- It is required to run with releases `-beta.2` (or above) war application; avail as follows.
  - https://github.com/victorskl/beacon-v2-bsc/releases

```
wget https://github.com/victorskl/beacon-v2-bsc/releases/download/umccr-beta.2/beacon-nosql-server-2.0.0-umccr-beta.2.war
docker cp beacon-nosql-server-2.0.0-umccr-beta.2.war wildfly:/opt/jboss/wildfly/standalone/deployments/
```

## Index

- Use [index.sh](index.sh) to create indexes

---

## Stats

### Logs

Observed timing of data transforming, importing and indexing can be scraped from the following logs.

- [logs/vcf2json/](logs/vcf2json)
- [logs/import_variants/](logs/import_variants)
- [logs/import_meta/](logs/import_meta)
- [logs/indexing/](logs/indexing)

### Checksum

```
root@ip-172-31-21-157:/data/workdir# md5sum Test.1000G.phase3.joint.vcf.gz
ceb93a557c48e8c897383296acafc509  Test.1000G.phase3.joint.vcf.gz
```

```
root@ip-172-31-21-157:/data/workdir# md5sum Test.1000G.phase3.joint.lifted.vcf.gz
cdba7d15ac3d918ed220a68f71299921  Test.1000G.phase3.joint.lifted.vcf.gz
```

### Size on Disk

```
root@ip-172-31-21-157:/data/workdir# ls -l | grep vcf.gz$
-rw-r--r--  1 root root 22028229498 Dec  9 06:01 Test.1000G.phase3.joint.lifted.vcf.gz
-rw-r--r--  1 root root 20611152395 Sep  1 02:38 Test.1000G.phase3.joint.vcf.gz
```

```
root@ip-172-31-21-157:/data/workdir# ls -lrS split/ | grep cosmic.vcf.gz$
-rw-r--r-- 1 root root  333552296 Jan 30 10:13 Test.1000G.phase3.joint.lifted.21.norm.ann.dbnsfp.clinvar.cosmic.vcf.gz
-rw-r--r-- 1 root root  347235001 Jan 30 09:59 Test.1000G.phase3.joint.lifted.22.norm.ann.dbnsfp.clinvar.cosmic.vcf.gz
-rw-r--r-- 1 root root  533813355 Jan 30 10:24 Test.1000G.phase3.joint.lifted.20.norm.ann.dbnsfp.clinvar.cosmic.vcf.gz
-rw-r--r-- 1 root root  641899952 Jan 30 10:29 Test.1000G.phase3.joint.lifted.19.norm.ann.dbnsfp.clinvar.cosmic.vcf.gz
-rw-r--r-- 1 root root  649994892 Jan 30 10:42 Test.1000G.phase3.joint.lifted.18.norm.ann.dbnsfp.clinvar.cosmic.vcf.gz
-rw-r--r-- 1 root root  719127382 Jan 30 10:57 Test.1000G.phase3.joint.lifted.15.norm.ann.dbnsfp.clinvar.cosmic.vcf.gz
-rw-r--r-- 1 root root  732356816 Jan 30 10:47 Test.1000G.phase3.joint.lifted.17.norm.ann.dbnsfp.clinvar.cosmic.vcf.gz
-rw-r--r-- 1 root root  783919101 Jan 30 11:06 Test.1000G.phase3.joint.lifted.14.norm.ann.dbnsfp.clinvar.cosmic.vcf.gz
-rw-r--r-- 1 root root  803440018 Jan 30 10:51 Test.1000G.phase3.joint.lifted.16.norm.ann.dbnsfp.clinvar.cosmic.vcf.gz
-rw-r--r-- 1 root root  814490940 Jan 30 11:02 Test.1000G.phase3.joint.lifted.13.norm.ann.dbnsfp.clinvar.cosmic.vcf.gz
-rw-r--r-- 1 root root 1042921688 Jan 30 11:30 Test.1000G.phase3.joint.lifted.9.norm.ann.dbnsfp.clinvar.cosmic.vcf.gz
-rw-r--r-- 1 root root 1150596123 Jan 30 11:11 Test.1000G.phase3.joint.lifted.12.norm.ann.dbnsfp.clinvar.cosmic.vcf.gz
-rw-r--r-- 1 root root 1188151643 Jan 30 11:24 Test.1000G.phase3.joint.lifted.10.norm.ann.dbnsfp.clinvar.cosmic.vcf.gz
-rw-r--r-- 1 root root 1214094284 Jan 30 11:17 Test.1000G.phase3.joint.lifted.11.norm.ann.dbnsfp.clinvar.cosmic.vcf.gz
-rw-r--r-- 1 root root 1312093336 Jan 30 11:37 Test.1000G.phase3.joint.lifted.8.norm.ann.dbnsfp.clinvar.cosmic.vcf.gz
-rw-r--r-- 1 root root 1396107208 Jan 30 11:48 Test.1000G.phase3.joint.lifted.7.norm.ann.dbnsfp.clinvar.cosmic.vcf.gz
-rw-r--r-- 1 root root 1494976655 Jan 30 12:01 Test.1000G.phase3.joint.lifted.5.norm.ann.dbnsfp.clinvar.cosmic.vcf.gz
-rw-r--r-- 1 root root 1501888993 Jan 30 11:55 Test.1000G.phase3.joint.lifted.6.norm.ann.dbnsfp.clinvar.cosmic.vcf.gz
-rw-r--r-- 1 root root 1639837756 Jan 30 12:08 Test.1000G.phase3.joint.lifted.4.norm.ann.dbnsfp.clinvar.cosmic.vcf.gz
-rw-r--r-- 1 root root 1696646122 Jan 30 12:14 Test.1000G.phase3.joint.lifted.3.norm.ann.dbnsfp.clinvar.cosmic.vcf.gz
-rw-r--r-- 1 root root 1929349880 Jan 30 12:32 Test.1000G.phase3.joint.lifted.1.norm.ann.dbnsfp.clinvar.cosmic.vcf.gz
-rw-r--r-- 1 root root 1978544440 Jan 30 12:38 Test.1000G.phase3.joint.lifted.X.norm.ann.dbnsfp.clinvar.cosmic.vcf.gz
-rw-r--r-- 1 root root 2024550004 Jan 30 12:25 Test.1000G.phase3.joint.lifted.2.norm.ann.dbnsfp.clinvar.cosmic.vcf.gz
```

```
root@ip-172-31-21-157:/data/workdir# ls -lrS split/ | grep .json.gz$
-rw-r--r-- 1 root root  906635236 Jan 23 22:55 Test.1000G.phase3.joint.lifted.22.norm.ann.dbnsfp.clinvar.cosmic.json.gz
-rw-r--r-- 1 root root  985159125 Jan 24 02:00 Test.1000G.phase3.joint.lifted.21.norm.ann.dbnsfp.clinvar.cosmic.json.gz
-rw-r--r-- 1 root root 1429617181 Jan 24 03:34 Test.1000G.phase3.joint.lifted.20.norm.ann.dbnsfp.clinvar.cosmic.json.gz
-rw-r--r-- 1 root root 1541183365 Jan 24 05:34 Test.1000G.phase3.joint.lifted.19.norm.ann.dbnsfp.clinvar.cosmic.json.gz
-rw-r--r-- 1 root root 1834432433 Jan 24 09:35 Test.1000G.phase3.joint.lifted.17.norm.ann.dbnsfp.clinvar.cosmic.json.gz
-rw-r--r-- 1 root root 1902188846 Jan 24 07:36 Test.1000G.phase3.joint.lifted.18.norm.ann.dbnsfp.clinvar.cosmic.json.gz
-rw-r--r-- 1 root root 1966005781 Jan 24 23:22 Test.1000G.phase3.joint.lifted.15.norm.ann.dbnsfp.clinvar.cosmic.json.gz
-rw-r--r-- 1 root root 2072491616 Jan 24 12:31 Test.1000G.phase3.joint.lifted.16.norm.ann.dbnsfp.clinvar.cosmic.json.gz
-rw-r--r-- 1 root root 2161976304 Jan 25 06:51 Test.1000G.phase3.joint.lifted.14.norm.ann.dbnsfp.clinvar.cosmic.json.gz
-rw-r--r-- 1 root root 2215204293 Jan 28 08:28 Test.1000G.phase3.joint.lifted.X.norm.ann.dbnsfp.clinvar.cosmic.json.gz
-rw-r--r-- 1 root root 2495228191 Jan 25 03:18 Test.1000G.phase3.joint.lifted.13.norm.ann.dbnsfp.clinvar.cosmic.json.gz
-rw-r--r-- 1 root root 2842394341 Jan 26 01:21 Test.1000G.phase3.joint.lifted.9.norm.ann.dbnsfp.clinvar.cosmic.json.gz
-rw-r--r-- 1 root root 3200414404 Jan 25 10:14 Test.1000G.phase3.joint.lifted.12.norm.ann.dbnsfp.clinvar.cosmic.json.gz
-rw-r--r-- 1 root root 3352960724 Jan 25 19:16 Test.1000G.phase3.joint.lifted.10.norm.ann.dbnsfp.clinvar.cosmic.json.gz
-rw-r--r-- 1 root root 3358357700 Jan 25 14:25 Test.1000G.phase3.joint.lifted.11.norm.ann.dbnsfp.clinvar.cosmic.json.gz
-rw-r--r-- 1 root root 3601816666 Jan 26 05:02 Test.1000G.phase3.joint.lifted.8.norm.ann.dbnsfp.clinvar.cosmic.json.gz
-rw-r--r-- 1 root root 3876063063 Jan 26 09:39 Test.1000G.phase3.joint.lifted.7.norm.ann.dbnsfp.clinvar.cosmic.json.gz
-rw-r--r-- 1 root root 4112163376 Jan 27 00:36 Test.1000G.phase3.joint.lifted.5.norm.ann.dbnsfp.clinvar.cosmic.json.gz
-rw-r--r-- 1 root root 4360379210 Jan 26 14:10 Test.1000G.phase3.joint.lifted.6.norm.ann.dbnsfp.clinvar.cosmic.json.gz
-rw-r--r-- 1 root root 4712410883 Jan 27 11:32 Test.1000G.phase3.joint.lifted.3.norm.ann.dbnsfp.clinvar.cosmic.json.gz
-rw-r--r-- 1 root root 4918337273 Jan 27 05:25 Test.1000G.phase3.joint.lifted.4.norm.ann.dbnsfp.clinvar.cosmic.json.gz
-rw-r--r-- 1 root root 5199988200 Jan 28 02:43 Test.1000G.phase3.joint.lifted.1.norm.ann.dbnsfp.clinvar.cosmic.json.gz
-rw-r--r-- 1 root root 5540999842 Jan 27 17:14 Test.1000G.phase3.joint.lifted.2.norm.ann.dbnsfp.clinvar.cosmic.json.gz
```

### Size on MongoDB

```
root@ip-172-31-21-157:/data/workdir# du -sh /data/beacon-doc/beacon/mongo/
262G	/data/beacon-doc/beacon/mongo/
```

```
test> show databases
admin    148.00 KiB
beacon     3.25 GiB
beacon2  258.78 GiB
config   108.00 KiB
local     72.00 KiB

test> use beacon2
switched to db beacon2

beacon2> db.stats()
{
  db: 'beacon2',
  collections: 7,
  views: 0,
  objects: 85104889,
  avgObjSize: 13281.147998806508,
  dataSize: 1130290626231,
  storageSize: 209381543936,
  indexes: 23,
  indexSize: 68477546496,
  totalSize: 277859090432,
  scaleFactor: 1,
  fsUsedSize: 381205291008,
  fsTotalSize: 536608768000,
  ok: 1
}
```
