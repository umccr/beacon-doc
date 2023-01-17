# Beacon Compose Stack

Terraform-based VM instance provisioning on AWS for hosting Java Beacon [docker compose stack](../beacon).

## Prerequisite

### Skills

- AWS
- Terraform

### Route53 Public Hosted Zone

- Create Route53 public hosted zone for `base_domain`
- See https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingHostedZone.html for how to
- This task requires ability to modify your root domain DNS setting

### ACM SSL Certificate

- Create ACM SSL certificate for `base_domain` and `app_domain`
  - Most part, this can be just one SSL certificate request such that 
    - base domain: `demo.umccr.org`
    - alternate name: `*.demo.umccr.org`
- See https://docs.aws.amazon.com/acm/latest/userguide/gs-acm-request-public.html for how to


## TL;DR

- Stack Arch: 
```
  ACM
   |
Route53 > ALB > (hibernating) EC2 Instance
```

```
export AWS_PROFILE=demo
terraform init
terraform plan
terraform apply
```

## Setup

- Use `instance_id` from terraform output to gain access into Ec2 instance. 
  - e.g. `aws ssm start-session --target <instance_id>`
- Follow https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-using-volumes.html to format and mount EBS data disk to, say, mount point `/data`.

```
aws ssm start-session --target i-1234561117085dce1
sudo su - root
lsblk | grep 300G
ll /dev/nvme1n1
mkfs -t xfs /dev/nvme1n1
blkid | grep nvme1n1
echo "UUID=edb1f321-82ef-4702-bda6-e143c07e2e73  /data  xfs  defaults,nofail  0  2" >> /etc/fstab
mkdir -p /data
mount -a
df -h
```

- Install [Docker Engine on Ubuntu](https://www.google.com/search?q=ubuntu+install+docker) and [relocate](https://www.google.com/search?q=relocate+docker+directory+linux) its `/var/lib/docker` directory to data disk, e.g. `/data/docker`

```
mkdir -p /data/docker
ln -s /data/docker /var/lib/docker
apt-get remove docker docker-engine docker.io containerd runc
apt-get install ca-certificates curl gnupg lsb-release
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
docker run hello-world
docker info

docker info | grep Root
 Docker Root Dir: /data/docker
```

- Now, you are ready to setup Java Beacon under `/data` location. Follow steps in [beacon/README.md](../beacon). Example as follows.

```
cd /data
git clone https://github.com/umccr/beacon-doc.git
cd beacon-doc/beacon

wget https://github.com/victorskl/beacon-v2-bsc/releases/download/umccr-beta.1/beacon-nosql-server-2.0.0-umccr-beta.1.war

docker compose pull
docker compose up -d
docker compose ps

docker cp beacon-nosql-server-2.0.0-umccr-beta.1.war wildfly:/opt/jboss/wildfly/standalone/deployments/

docker compose logs wildfly -f
(ctrl + c)

apt-get install jq -y
curl -s http://localhost:8080/beacon/v2.0.0/info | jq
curl -s http://localhost:8080/beacon/v2.0.0/service-info | jq
```

- Next. Ingest your choice of test cohort dataset from pre-built [scratch](../beacon/scratch) directory. :) 


## Configuration

### Variables

(Optional) You can override variables as follows.

```
cp terraform.tfvars.sample terraform.tfvars
vi terraform.tfvars
```

### Remote Backend

(Optional) You can use terraform remote backend as follows.

```
cp backend.tf.sample backend.tf
vi backend.tf
terraform init -migrate-state
```

### Scaling

(Optional) You may vertically scale up the VM. The more MEM is the better. Try `t3.xlarge`, `m6i.xlarge`, `m6a.xlarge` or; for more punch, try `r6in.xlarge` or `r6a.xlarge`.

If data disk is running low, follow https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/recognize-expanded-volume-linux.html to extend it.
