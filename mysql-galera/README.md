# MySQL-Galera
1. Start mysql galera server
	- Node dầu tiên khởi động start với mysqld_bootstrap mysqld sẽ tự thêm option --new-cluster-server vào để khởi động node mới
	- Node thứ 2 trở đi start service mysqld bình thường, sau khi jion vào cluter thì các node join sẽ tự đồng bộ data của node chính (đồng bộ cả directory) thông qua rsync (mặc định dùng rsync), vì thế user/pasword của các node tham giam cluster là như nhau.

2. Cơ chế đồng bộ các node mơi join vào cluster
	- Đầu tiên mysql khởi tạo directory data và các file cơ bản như các version khác
	- Kết nối đến các node tham gia cluster để lấy thông tin cluster, so sánh uuid thông qua port 4567
	- Khởi tạo tiến tình rsync port 4444 đồng bộ dữ liệu nod khác về
	- Khởi động hoàn tất server và tiêp tục tiến tình write-set để đồng bộ dữ liệu

3. Cơ chế bootstrap node

Thông tin của 1 file state snapshot trên 1 host
```
# GALERA saved state
version: 2.1
uuid:    92ddd084-ca3c-11ea-8083-627febe638c2
seqno:   -1
safe_to_bootstrap: 0
```
Khi có nhiều hơn 1 node đang chạy và đồng bộ với nhau thì ```safe_to_bootstrap``` có giá trị 0
khi có duy nhất 1 node đang chạy thì ```safe_to_bootstrap``` có giá trị 1, cần tìm và start node này đầu tiên để đảm bảo đầy đủ dữ liệu, mysql chỉ cho phép start bootstrap node khi ```safe_to_bootstrap: 1```