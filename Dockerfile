# 获取官方源镜像
FROM centos:6.10
MAINTAINER oakdb
ENV MYSQL_CFG="/etc/my.cnf"
ENV OM_START="/opt/omservice-start.sh"
# 启用清华centos vault 6.10软件仓库
RUN sed -e "s|^mirrorlist=|#mirrorlist=|g" \
    -e "s|^#baseurl=http://mirror.centos.org/centos/\$releasever|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos-vault/6.10|g" \
    -e "s|^#baseurl=http://mirror.centos.org/\$contentdir/\$releasever|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos-vault/6.10|g" \
    -i.bak \
    /etc/yum.repos.d/CentOS-*.repo
# 更新yum缓存
RUN yum makecache
# 安装服务管理工具
RUN yum install initscripts -y
# 安装奥维地图企业服务器，参考文档https://www.gpsov.com/appdoc/index.php?id=45#1250203
# 安装mysql数据库
RUN yum install mysql-server -y
# 安装奥维服务器rpm包
RUN rpm -ivh https://download.ovital.com/pub/omservice-3.3.3-2.x86_64.rpm
# 清理yum下载缓存
RUN yum clean all
# 删除奥维服务器rpm安装包

# 添加my.cnf参数max_long_data_size=268435456
RUN cat $MYSQL_CFG | grep "max_long_data_size=268435456" > /dev/null  && echo "my.cnf参数已存在"|| { sed -i '/\[mysqld\]/amax_long_data_size=268435456' $MYSQL_CFG && echo "my.cnf参数已设置"; }
# 写入奥维服务器初始化脚本
RUN echo "#! /bin/sh" > $OM_START \
    && echo "service mysqld start && chkconfig mysqld on" >> $OM_START \
    && echo "echo -e '\n' | /usr/local/bin/initomservice.sh" >> $OM_START \
	&& echo "service omservice start && chkconfig omservice on" >> $OM_START \
    && echo "tail -f /dev/null" >> $OM_START \
    && chmod +x $OM_START
CMD ["/opt/omservice-start.sh"]
