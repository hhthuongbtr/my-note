# install mongodb binary package linux
Step 1: Download the .tgz file of community version from here https://www.mongodb.com/try/download/community, choose correct the version you need
Step 2: Extract the downloaded file ussing below command:
```
tar -xzvf mongodb-linux-x86_64-rhel70-4.2.15.tgz
```
Step 3: Create the data directory 
``` 
mkdir - p /data/db
```
Step 4: Create mongo_user using the command
```
useradd mongo_user
```
Step 5: Change the ownership of the files in data directory using the folowing command
```
chown -R mongo_user:mngo_user /data/db
```
Step 6: Create a configuration file in any directory
```
verbose = true
dbpath = /data/db
logpath = /var/log.mongodb.log
logappend = true
port = 2701
```
Step 7: Start the mongod server
```
./mongod -quiet -f /etc/mongod.conf
```
# Test

