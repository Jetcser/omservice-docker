#! /bin/bash
OM_BAKFILE="/path/to/mybak.sql"
sudo docker exec -it omap /bin/sh -c "mysqldump --add-drop-table -uroot -povtial ovsrv user user_detail ugroup user_cfg ugroot admin_cfg > /tmp/ovsrv_cfg.sql"
sudo docker cp omap:/tmp/ovsrv_cfg.sql" $OM_BAKFILE
