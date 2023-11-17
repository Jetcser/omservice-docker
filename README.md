# 奥维地图企业服务器（docker镜像）  
# Docker Image for Ovital Map Enterprise Server  
1.源镜像采用官方centos 6.10，软件源采用清华大学centos vault软件仓库。由于docker中的centos7存在systemd问题，启动服务会失败，难以解决，故弃用。  
2.镜像预装mysql-server，omservice 3.3.3。  
3.奥维企业服务器官方安装手册：[https://www.gpsov.com/appdoc/index.php?id=45#1090201](url)。  
4.可自行构建docker镜像，内容参考Dockfile，编辑好之后，使用make-docker-image.sh来构建。  
5.可用docker-compose来部署，docker-compose.yml文件如下：  
```
version: '2.0'
services:
  omservice:
    image: oakdb/omservice:3.3.3
    container_name: omservice
    restart: always
    volumes:
      - /volume1/service/omservice/mysql/db:/var/lib/mysql # mysql数据库存放目录
      - /volume1/service/omservice/omservice.conf:/etc/etc/omservice.conf # omservice服务配置文件
    ports:
      - "1616:1616" # 奥维服务器端口
    networks:
      om-net:
        ipv4_address: 172.8.0.2 # 自定义容器IP
networks:
  om-net:
    driver: bridge
    ipam:
      config: # 自定义容器网关
        - subnet: 172.8.0.0/16
          gateway: 172.8.0.1
```
6.数据库备份及恢复可参考bakup_cfg_only.sh，以及recover-db.sh两个脚本。  
7.注意：  
奥维企业服务器内网部署不需要任何审核手续；  
若要外网部署奥维企业服务器，需要在奥维互动地图注册企业账户，进行单位审核，以及服务器的公网IP或域名审核，链接：[https://www.gpsov.com/cn2/index.php](url)。
