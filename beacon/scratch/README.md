# Scratch

Please note that in the following data, repo and work under this directory may further apply LICENSE and Acknowledgement which may differ from LICENSE apply to work under this UMCCR `beacon-doc` repo. Should you of any concern, please consult with respective upstream repos or sources.

Please see each subdirectory `README.md` for further details. 

## MongoDB Tools

- (Optional) Follow https://www.mongodb.com/docs/mongodb-shell/install/ to install MongoDB CLI tools i.e. `mongosh`, `mongoimport`, etc..

```
sudo apt-get install gnupg
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -

echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

sudo apt-get update
sudo apt-get install -y mongodb-mongosh mongodb-org-tools

which mongosh
/usr/bin/mongosh

which mongoimport
/usr/bin/mongoimport

mongosh -u admin -p admin
test> show databases;
test> quit
```
