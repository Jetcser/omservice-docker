#! /bin/bash
OM_BAKFILE="/path/to/mybak.sql"
sudo docker exec -it omservice service omservice stop
sudo docker cp $OM_BAKFILE omservice:/tmp/ovibakup.sql
sudo docker exec -it omservice /bin/sh -c "mysql -uroot -povital ovsrv < /tmp/ovibakup.sql"
sudo docker exec -it omservice service omservice start
