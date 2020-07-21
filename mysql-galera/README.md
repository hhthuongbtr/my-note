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
Khi có duy nhất 1 node đang chạy thì ```safe_to_bootstrap``` có giá trị 1, cần tìm và start node này đầu tiên để đảm bảo đầy đủ dữ liệu, mysql chỉ cho phép start bootstrap node khi ```safe_to_bootstrap: 1```
```seqno:   ``` Snapshot transaction cuối cùng được replicate, mặc định là -1 khi đang hoạt động, stop mysql sẽ có được giá trị transaction cuối cùng

Note: Nếu bootstap không lên có thể do còn đụng port 4567, kill porocess sinh port 4567 đi sẽ bootstrap lại bình thường.

4. Cơ chế replicate
Mỗi node có 1 engine write-set  chạy đồng bộ thông qua port 4567
Khi có transaction commit ở 1 host thì trước khi ghi host này sẽ multicast data mới lên group sau đó sẽ được write-set ghi dữ liệu mới cho mỗi node thuộc cluster
5. Monitor
```wsrep_last_committed```
Global transaction commit cuối cùng, Transaction id của các node khớp nhau sẽ đảm bảo dữ liệu thống nhất
```wsrep_local_state_comment``` Trạng thái join cluster của host: Synced|Connecting|Join, trạng thái Synced là replicate tốt nhất