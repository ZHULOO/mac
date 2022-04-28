# 腾讯云+notebook
## 一. 购买云服务器
+ 网址:https://cloud.tencent.com/product/lighthouse

## 二. 服务器上配置jupyter
### 2.1 安装python
+ Ubuntu 18.04预装了Python 3和Python 2。为了确保我们的版本是最新的版本，让我们用apt命令更新并升级系统，使其可以适用于Ubuntu系统的Advanced Packaging Tool：

```ubuntu
sudo apt update
sudo apt -y upgrade
python3 -v                        # 检查系统中安装的Python 3的版本
sudo apt install -y python3-pip   # 要管理Python的软件包，让我们安装pip
pip3 install numpy                # 使用pip安装模块或软件包
sudo apt install build-essential libssl-dev libffi-dev python-dev # 软件包和开发工具可以安装，来确保我们可以为编程环境提供强大的设置
```

### 2.2 设置虚拟环境
+ 有几种方法可以在Python中实现编程环境，但我们将在这里使用venv模块，它是标准Python 3库的一部分。我们输入以下命令安装venv：
```ubuntu
sudo apt install -y python3-venv
cd ~ 
mkdir envs                  # 创建envs文件夹用来存放环境
cd envs
python3 -m venv my_env1      # 创建my_env1环境
ls my_env1                  # 可以查看my_env1环境下的项目文件
source my_env1/bin/activate # 激活创建的my_env1环境,此时命令提示符前显示(my_env1)
vim hello.py 
python hello.py 
deactivate 
```

### 2.3 安装jupyter
#### 2.3.1 进入虚拟环境后执行安装命令
```
cd ~
source envs/my_env1/bin/activate
python3 -m pip install jupyter

```

#### 2.3.2 创建jupyter文件目录
```ubuntu
cd ~
mkdir jupyter_data_root             # 用来存放.ipynb文件
```

#### 2.3.3 生成登录jupyter密码sha
```ubuntu
python -c "import IPython;print(IPython.lib.passwd())" # 生成登录jupyter的密文,接下来要将密文复制到jupyter配置文件中;
```

#### 2.3.4 生成jupyter配置文件
```ubuntu
jupyter notebook --generate-config --allow-root  # 生成jupyter配置文件 
# 配置文件位于:当前用户文件夹下的.jupyter文件夹中:jupyter_notebook_config.py
vim jupyter_notebook_config.py # 打开配置文件输入以下内容:
c.NotebookApp.ip = '*'                 # 允许所有IP登录
c.NotebookApp.allow_root = True        # 
c.NotebookApp.open_browser = False     # 不自动打开浏览器
c.NotebookApp.port = 8888              # 登录端口为8888,后边服务器防火墙上要开启8888端口
c.NotebookApp.password = u'刚才生成的密文(sha:...)' # 上面生成的密文,和登录的密码对应;
c.ContentsManager.root_dir = '/home/lighthouse/jupyter_data_root' # jupyter运行根目录

```

#### 2.3.5 启动jupyter notebook
```ubuntu
jupyter notebook                                                                 # 直接在shell启动, shell不能关闭,麻烦;
nohup jupyter notebook > /home/lighthouse/jupyter_data_root/jupyter.log 2>&1 &   # 常驻进程, 并且将shell中运行代码保存到jupyter.log中,不需要一直开启shell窗口;
```
+ 关闭jupyter



### 2.4 `python -m pip install` 和 `pip install`的区别;
+ 如果下载缓慢,修改服务器pip镜像源,参考:https://cloud.tencent.com/document/product/213/8623

+ Ubuntu镜像源文件位置:
```
/etc/pip.conf
~/.pip/pip.conf
~/.config/pip/pip.conf
```

  + 编辑pip.conf
```
  vim pip.conf # 输入以下内容:
  [global]
  index-url = http://mirrors.cloud.tencent.com/pypi/simple
  trusted-host = mirrors.cloud.tencent.com
```
+ 如果去看源码的话，你会发现 pip 作为执行文件的入口点是 pip._internal.main;
+ pip 作为模块运行时入口是 _main.py，而该模块也只是调用 pip.internal.main;
+ 两种方式本质上是一样的，需要注意的是，如果系统中同时存在多个 python 解释器，最好检查一下 python 和 pip 是不是来自同一个版本;
+ 如果Python -m pip -version（或-V） 和pip -version（或-V）如果一致，就没有区别.

## 三. 远程使用jupyter notebook
+ 浏览器输入: http://82.157.50.164:8888 可直接访问
+ 注册datana.top域名,绑定82.157.50.164
+ 浏览器输入:http://datana.top:8888/ 可直接访问

## 四. 安装R语言内核
+ 参考:https://blog.csdn.net/penker_zhao/article/details/109406108
### 4.1 安装R语言
#### 4.1.1 Ubuntu添加最新的镜像地址
将`deb https://cloud.r-project.org/bin/linux/ubuntu xenial-cran35/`添加到 /etc/apt/sources.list
#### 4.1.2、添加安全密钥
+ 运行
`sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9`（这个E084DAB9会安装失败，请根据提示的key替换这个E084值）

#### 4.1.3、更新和安装
逐一运行下列语句

sudo apt update
sudo apt install r-base


apt-get install libxml2-dev

apt-get install libcurl4-openssl-dev

apt-get install libssl-dev

sudo R

update.packages(checkBuilt=TRUE,ask=FALSE)

install.packages(c('httr'))
### 4.2 安装jupyter R内核
#### 4.2.1 安装所需的R包
+ 最后第一步：
`install.packages(c('repr', 'IRdisplay', 'evaluate', 'crayon', 'pbdZMQ', 'devtools', 'uuid', 'digest'))`

+ 最后第二步：
`devtools::install_github('IRkernel/IRkernel')`

+ 最后第三步：
`IRkernel::installspec(user = FALSE)` 出错,参考下面的步骤

#### 4.2.2 新建ipynb无法加载R内核
```
install.packages("devtools")
devtools::install_github("IRkernel/IRkernel")
```
+ 帮jupyter找到R内核的位置
`system.file('kernelspec', package = 'IRkernel')`
+ The last line should give you the location of Jupyter will need to find the kernel. Mine was 
`/home/ubuntu/R/x86_64-pc-linux-gnu-library/4.0/IRkernel/kernelspec`

+ From the command line:
  + 1. inspect the path that you receive when you were in R. There should be a .json file in it.
  + 2. `jupyter kernelspec list` run this to be sure that jupyter is in your path, you should see information about the current available kernels.
  + 3. `jupyter kernelspec install /home/ubuntu/R/x86_64-pc-linux-gnu-library/4.0/IRkernel/kernelspec --name 'R' --user` (you will use path that you received while working in R which could be different)
  + 4. `jupyter kernelspec list` (this list should now include R)

  + 5. restart jupyter





## 五. 配置codiMD(Markdown)
### 5.1. 安装并配置MySQL
#### 5.1.1 安装MySQL
```
sudo apt-get update
sudo apt-get install mysql-server
```
#### 5.1.2 配置MySQL
##### 1 初始化配置
```ubuntu
sudo mysql_secure_installation # 配置项较多,用户密码/权限等,根据相应提示输入Y或N;
```
##### 2 检查MySQL服务状态
```ubuntu
systemctl status mysql.service # activate(running)服务正常;
#停止
sudo service mysql stop
#启动
sudo service mysql start
```
##### 3 配置访问权限
+ 配置远程访问权限
```ubuntu
# 登陆mysql
sudo mysql -uroot -p
#切换数据库
use mysql;    # mysql是数据库默认保存用户信息的数据库;
#查询用户表命令：查看用户是否可以从任意IP访问
select User,authentication_string,Host from user;
```
+ 客户主机权限  
  + `%`表示所有主机,包括本地和远程都可以访问;
  + `localhost`表示只有本地主机可以连接;
+ 创建用户
```mysql
# 设置权限与密码
# 新版本的MySQL8.0中创建用户与授权要分开执行:
CREATE USER zhulu@% IDENTIFIED BY 20465879;
GRANT ALL PRIVILEGES ON *.* TO zhulu@%;
# 下面的格式会出错:
GRANT ALL PRIVILEGES ON *.* TO zhulu@% IDENTIFIED BY 20465879;
#刷新cache中配置
flush privileges;  
```
##### 4 新建数据库和用户
```mysql
# 1 创建数据库studentService
CREATE DATABASE studentService;
create schema codimd default character set utf8 collate utf8_general_ci;
# 2 创建用户teacher(密码admin) 并赋予其studentService数据库的远程连接权限
GRANT ALL PRIVILEGES ON teacher.* TO studentService@% IDENTIFIED BY "admin";
```
##### 5 开放3306端口
+ 查看3306端口是否打开
`netstat -an|grep 3306`
+ 打开MySQL配置文件
`sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf`
+ 将`bind-address = 127.0.0.1`注销​
+ 重启动ubuntu
`sudo reboot`
##### 6 数据库简单操作
+ 切换数据库
`USE codimd;`
+ 查看数据库
`SHOW DATABASES;`
+ 查看数据库中的表
`SHOW TABLES;`
+ 查看数据表结构
`DESCRIBE Users`
+ 查看表内字段
`SELECT id,email FROM Users;` 

### 5.2 安装并配置Docker
#### 5.2.1 安装Docker
```ubuntu
sudo apt-get install docker
sudo apt-get install docker-compose
```
#### 5.2.3 配置Docker
+ 创建md文件夹
```ubuntu
cd /root/md
vim docker-compose.yml # 填入以下内容
```
+ `docker-compose.yml`内容
  + 使用docker中alphine构造的database数据库
```
version: "3"
services:
  database:  # 不用在Ubuntu中安装MySQL了,此处使用docker在容器中运行了alpine构造的数据库;
    image: postgres:11.6-alpine
    environment:
      - POSTGRES_USER=codimd
      - POSTGRES_PASSWORD=change_password
      - POSTGRES_DB=codimd
    volumes:
      - "database-data:/var/lib/postgresql/data"
    restart: always
  codimd:
    image: hackmdio/hackmd:2.4.1
    environment:
      - CMD_DB_URL=postgres://codimd:change_password@database/codimd #此处的database就是上面的容器启动的数据库,直接访问上面的数据库,而不用访问容器外的数据库了;
      - CMD_USECDN=false
    depends_on:
      - database
    ports:
      - "3000:3000"
    volumes:
      - upload-data:/home/hackmd/app/public/uploads
    restart: always
volumes:
  database-data: {}
  upload-data: {}
```
+ 使用上面自行安装和配置的MySQL数据库
```
version: "3"
services:
  codimd:
    image: nabo.codimd.dev/hackmdio/hackmd:2.4.1    # 镜像地址和名称;
    environment:
      - CMD_DB_URL=mysql://zhulu:20465879@172.17.0.1:3306/codimd # 使用上面自行安装和船舰的MySQL数据库的地址和用户信息;
      # 这里的ip是指装有MySQL的宿主机ip,通过ip addr show docker0查看;
      - CMD_USECDN=false
    ports:
      - "3000:3000"
    volumes:
      - upload-data:/home/hackmd/app/public/uploads # 这是容器内路径,Ubuntu上保存在/var/lib/docker/volumes/md_upload-data/_data里
    restart: always
volumes:
  upload-data: {}
```
#### 5.2.4 Docker启动
+ 启动docker
`docker-compose up -d`
+ 启动出现错误`RROR: Get https://registry-1.docker.io/v2/: net/http: TLS handshake timeout`
  + 连接不到镜像库所致,修改镜像库:
  + `vim /etc/docker/daemon.json`加入`{ "registry-mirrors":["https://docker.mirrors.ustc.edu.cn"] }`;
  + 然后重启守护进程`systemctl daemon-reload`;
+ 查看是否已开启`docker ps`
+ 查看连接日志`docker logs -f -t --tail 1 md_codimd_1`
+ 出现`HTTP Server listening at 0.0.0.0:3000`说明搭建成功
+ 报错`ERROR: ALTER command denied to user ‘codimduser’@’172.18.0.2’ for table ‘Notes’`是权限问题,修改:
  + `GRANT ALL PRIVILEGES ON *.* TO 用户名@%;`
#### 5.2.5 Docker的使用
+ 关闭容器
`docker stop md_codimd_1`
+ 启动容器
`docker start md_codimd_1`
+ 查看正在运行的容器
`docker ps`
+ 查看已退出的容器
`docker ps -a`
+ 查看正在运行的镜像
`docker images`
+ 删除正在运行的容器
`docker rm md_codimd_1` # 删除容器必须先停止容器;
+ 删除正在运行的镜像
`docker rmi 镜像id`      # 删除镜像必须先删除容器;

#### 5.2.6 远程访问端口
+ 要开启腾讯云的3000端口
+ 输入http://datana.top:3000 即可访问搭建的codimd网页


### 5.3 部署wordpress
+ `/root/wordpress/docker-compose.yml`输入以下内容:

```
version: '3.3'
services:
  wordpress:
    image: wordpress:latest
    volumes:
      - wordpress_data:/var/www/html  # 实际路径:/var/lib/docker/volumes/wordpress_wordpress_data/_data, 删除此路径下的数据才能卸载干净
    ports:
      - "8000:80"
    restart: always
    environment:
      WORDPRESS_DB_HOST: 172.17.0.1:3306
      WORDPRESS_DB_USER: zhulu
      WORDPRESS_DB_PASSWORD: 20465879
      WORDPRESS_DB_NAME: db
volumes:
  wordpress_data: {}
```
+ 要开启腾讯云的8000端口
+ 输入http://datana.top:8000 即可访问搭建的codimd网页

## 六、Vscode使用密钥对免密登录
+ 原理:云服务器生成密钥对,私钥保存到本地,稍后配置在VSCode的config中,公钥分发到服务器上,然后通过密钥配对来登录。
+ 或者:本地利用ssh-keygen生成一对公钥和私钥，将公钥配置在服务器上，将私钥配置在VSCode的config中，通过密钥配对来登录。

### 1. [云服务器控制台](https://console.cloud.tencent.com/lighthouse/sshkey/index)创建密钥，私钥将会自动下载到电脑上，请自行保存；
### 2. 然后将公钥分发给云服务器上的实例，也就是自己的云服务器：
  + 必须是服务器关机状态下，才能分发；
  + 分发后服务器默认保存在`/home/ubuntu/authorized_keys`下
    + 云服务器上保存`authorized_keys`的位置有两个:
    + `/home/用户/.ssh/`目录和`root/.ssh/`根目录;
  + 服务器上ssh配置
    + 管理员账号打开`/etc/ssh/sshd_config.d`,修改相应参数:`PubkeyAuthentication yes`;
    + 密码登录:`PasswordAuthentication yes`,密码登录一定要设置为yes才能使用密码登录;
    + `AuthorizedKeysFile  .ssh/authorized_keys`:公钥保存到认证文件中;
    + `service ssh restart`:重启;

### 3. vscode上配置参数:
+ `C:\Users\Administrator\.ssh`目录下保存有登录服务器所需的参数和密钥文件:

<div align="center"> <img src="media/cloud1.png" width="50%" /> </div>

+ 其中:
  + `config`:
    <div align="center"> <img src="media/cloud2.png" width="70%" /> </div>

  + `id_rsa`:私钥
  + `known_hosts`:连接上远程服务器以后本地的保存信息;
+ 为什么需要`known_hosts`
  + 当我们第一次通过SSH登录远程主机的时候,如果我们选择`yes`，那么该`host key`就会被加入到`Client`的`known_hosts`中;
  + 这个文件主要是通过`Client`和`Server`的双向认证，从而避免中间人`man-in-the-middle attack`攻击，每次`Client`向`Server`发起连接的时候，不仅仅`Server`要验证`Client`的合法性，`Client`同样也需要验证`Server`的身份，`SSH client`就是通过`known_hosts`中的`host key`来验证`Server`的身份的。

### 4. linux上的相关目录
+ `/home/lighthouse/.ssh/authorized_keys`:用户的授权公钥文件保存在这里；
+ `/home/ubuntu/.ssh/authorized_keys`    :腾讯云自行分发的公钥保存在这里；
+ `/root/.ssh/authorized_keys`           :管理员的公钥保存在这里；
+ `/etc/sshd_config.d`                   :密钥登录、密码登录等选项都在这里；
+ ``
