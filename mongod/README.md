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
vm.overcommit_ratio = 50
Nếu cờ của vm.overcommit_memory là 2 thì tổng bộ nhớ mà kernel được cấp phát cho các ứng dụng là: Swap Space + vm.overcommit_ratio * RAM Memory
```

