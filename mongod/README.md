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
Access mongod 
```
./mongo 127.0.0.1:27017
```
Create user
```
use database name
db.createUser(
   {
     user: "Username",
     pwd: "Password",
     roles: [ "readWrite", "dbAdmin" ]
   }
)
```
Show databases
```
show collections
```
# Loging
Slow log
```
First, you must set up your profiling, specifying what the log level that you want. The 3 options are:

0 - logger off
1 - log slow queries
2 - log all queries
You do this by running your mongod deamon with the --profile and slowns (time in iliseconds) options:

mongod --profile 2 --slowms 1000

With this, the logs will be written to the system.profile collection, on which you can perform queries as follows:

find all logs in some collection, ordering by ascending timestamp:
db.system.profile.find( { ns:/<db>.<collection>/ } ).sort( { ts: 1 } );

looking for logs of queries with more than 5 milliseconds:
db.system.profile.find( {millis : { $gt : 5 } } ).sort( { ts: 1} );
```
# TUNING
Memory tuning
```
vm.swappiness = 10
Cho kernel biết khi nào thì nên dùng swap memory. Giá trị càng cao thì hệ thống sẽ thường xuyên dùng bộ nhớ swap.
VD: Giá trị 10 có nghĩa là nếu dung lượng ram trống còn dưới 10%, hệ thống sẽ chuyển sang dùng swap memory.
```
```
vm.dirty_background_ratio = 5
Thông số này là số phần trăm bộ nhớ RAM dùng để chứa dirty page (những trang nhớ được cache lại trước khi ghi xuống đĩa cứng vật lý).
Khi số dirty page vượt quá giá trị này, các tiến trình chạy ngầm như pdflush/flush/kdmflush sẽ bắt đầu ghi các giá trị cache này xuống đĩa cứng.

Giá trị ở đây là 5 có nghĩa là 5% tổng số RAM của hệ thống, nếu hệ thống có 8GB RAM thì sẽ có 5% * 8GB tức là 400MB RAM chứa dirty page trước khi các tiến trình chạy ngầm ghi bớt dữ liệu xuống ổ đĩa. (Thực hiện chạy ngầm I/O vẫn nhận tín hiệu mới luôn nhỏ hơn giá trị vm.dirty_ratio)
```
```
vm.dirty_ratio = 10
Phần trăm bộ nhớ RAM tối đa để chứa các dirty page trước khi ghi toàn bộ các dữ liệu này xuống đĩa cứng.
Khi lượng dữ liệu đạt mức này, toàn bộ các thao tác I/O mới sẽ tạm thời bị block cho tới khi toàn bộ các dirty page được các process lưu lại an toàn dưới ổ cứng.
```
```
vm.overcommit_memory = 0
Ta có thể đặt 3 giá trị cho tham số này:
Với cờ là 0, mỗi khi ứng dụng yêu cầu thêm bộ nhớ, kernel sẽ ước tính lượng bộ nhớ trống còn lại trước khi cấp phát.
Với cờ là 1, kernel sẽ luôn cấp phát thêm bộ nhớ khi ứng dụng yêu cầu.
Với cờ là 2, kernel sẽ không bao giờ overcommit bộ nhớ.
Trong nhiều trường hợp, tính năng này sẽ rất hữu dụng vì sẽ có nhiều ứng dụng yêu cầu cấp lượng bộ nhớ nhiều hơn cần thiết.
```
```
vm.overcommit_ratio = 50
Nếu cờ của vm.overcommit_memory là 2 thì tổng bộ nhớ mà kernel được cấp phát cho các ứng dụng là: Swap Space + vm.overcommit_ratio * RAM Memory
```
Network tuning
```
net.ipv4.tcp_fin_timeout = 30
Giảm thời gian chờ ở trạng thái FIN-WAIT-2. Mặc định là 60s.
```
```
Giảm thời gian chờ của cơ chế keep alive
net.ipv4.tcp_keepalive_time = 120
net.ipv4.tcp_keepalive_probes = 5
net.ipv4.tcp_keepalive_intvl = 30
TCP keep alive là cơ chế xác định các TCP connection còn hoạt động hay không.

Giá trị này mặc định là 7200s (2 giờ), nếu connection không có bất cứ hoạt động nào thì socket sẽ chờ trong thời gian tcp_keepalive_time trước khi gởi đi lần lượt gởi đi 5 gói tin giữ kết nối, mỗi gói tin cách nhau 15s.

Tổng cộng lại, ứng dụng sẽ biết được một kết nối TCP có còn hoạt động hay không sau 270s (120s + 30s + 30s + 30s + 30s + 30s)
```


