# Java Beacon

This section contains investigation of [_Open source Java implementation of the Beacon v2 API_](https://doi.org/10.7490/f1000research.1118980.1).

> - For most part, you should try upstream deployment guide avail at https://gitlab.bsc.es/inb/ga4gh/beacon-v2-docker-demo/
> - We (UMCCR) as just another user of this Open Source tool; to explore as POC Java Beacon demo instance. It is better that you seek upstream original author's support for more serious production quality setup.

If that does not work for you then continue with the following for our fork and setup arrangement.

## Implementation

### Fork

At the mo, we maintain our fork of BSC/INB Java Beacon implementation at the following.

- https://github.com/victorskl/service-info-data-model
- https://github.com/victorskl/beacon-v2-api
- https://github.com/victorskl/beacon-v2-bsc

### Branch

- `upstream` branch contains things that we found bug or shortfall of upstream code base.
- `j8` branch contains downgrade to JakartaEE / JavaEE 8 runtime target.
- `umccr` branch contains modification made specific to organization needs.
- See https://github.com/victorskl/beacon-v2-bsc/branches

### Release

- We build `beta.N` pre-release out from respective branches.
- See https://github.com/victorskl/beacon-v2-bsc/releases


## Setup

- You can grab either `j8` or `umccr` WAR file from release page to deploy it into JBoss WildFly application server. Use `WildFly-26.1.2.Final` (_not Preview_) with `JDK 11`.
- We have also provided `docker-compose.yml` stack as starter in this repo. As follows.

### Checkout

```
git clone https://github.com/umccr/beacon-doc.git
cd beacon-doc/beacon
```

### Download WAR

```
wget https://github.com/victorskl/beacon-v2-bsc/releases/download/umccr-beta.1/beacon-nosql-server-2.0.0-umccr-beta.1.war
```

### Up

```
docker compose pull
docker compose up -d
docker compose ps
```

Overriding Docker Compose

- Copy [docker-compose.override.sample.yml](docker-compose.override.sample.yml) to `docker-compose.override.yml`
- Make your modification in compose override yaml

```
cp docker-compose.override.sample.yml docker-compose.override.yml
vi docker-compose.override.yml
```

### Deploy WAR

```
docker cp beacon-nosql-server-2.0.0-umccr-beta.1.war wildfly:/opt/jboss/wildfly/standalone/deployments/
```

### Log

```
docker compose logs wildfly -f
(ctrl + c)
```

### Using

- Go to http://localhost:8080/beacon

```bash
curl -s 'http://localhost:8080/beacon/v2.0.0/info' | jq
curl -s 'http://localhost:8080/beacon/v2.0.0/service-info' | jq
curl -s 'http://localhost:8080/beacon/v2.0.0/map' | jq
curl -s 'http://localhost:8080/beacon/v2.0.0/configuration' | jq
curl -s 'http://localhost:8080/beacon/v2.0.0/cohorts' | jq
curl -s 'http://localhost:8080/beacon/v2.0.0/datasets' | jq
curl -s 'http://localhost:8080/beacon/v2.0.0/runs' | jq
curl -s 'http://localhost:8080/beacon/v2.0.0/analyses' | jq
curl -s 'http://localhost:8080/beacon/v2.0.0/individuals?limit=10' | jq
curl -s 'http://localhost:8080/beacon/v2.0.0/biosamples?limit=10' | jq
curl -s 'http://localhost:8080/beacon/v2.0.0/g_variants?limit=10' | jq
```

## Data Ingestion

The [scratch](scratch) directory contain some test cohort dataset that has already built for ingesting into MongoDB backend.

Please follow README instruction guided there.

## Scaling

When appropriate,

- Consider MongoDB cluster and sharding
  - Or comparable alternate, if you are on Cloud (Atlas, DocumentDB, ...)
- Consider WildFly in domain mode and cluster 
  - Or more lightweight Servlet container such as Tomcat or Undertow in JVM cluster setup
