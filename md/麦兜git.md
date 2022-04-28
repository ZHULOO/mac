# [麦兜搞IT](https://space.bilibili.com/364122352/channel/detail?cid=150242)

+ 关于WSL的一些操作命令参考WSL2.md

## 一. 代码仓库的初始化
+ 新建文件夹,初始化以后看发生了什么:
  + `watch -n -1 -d find .`:每一秒刷新显示一次当前目录的文件;
  + `ls -la`:显示当前目录下的所有文件(包括隐藏文件);
  + `ls`: 仅显示非隐藏文件;
  + `git init`: 初始化生成一个git目录;
  + `rm -rf .git/hooks/*.sample`:删除一定目录下所有后缀为`.sample`的文件;
+ .git目录下的config文件, 保存了用户配置信息:
  + `cat .git/config`:查看当前代码仓库的局部配置文件`config`;
  + `cat .~/.gitconfig`:查看用户全局配置文件, 在用户目录下, 相当于: `cat /mnt/c/Users/Administrator/.gitconfig`;
+ 配置局部用户信息:
  + `git config user.name "demo"`
  + `git config user.email "demo@demo.con`
  + `cat .git/config`: 可以看到新配置的用户信息;
  + `git config -l`: 列出配置信息
## 二. git add背后到底发生了什么
+ 生成新的文件并使用`git add`:
  + `echo "hello git">hello.txt`: 生成一个新的hello.txt文档,并写入"hello git";
  + `cat hello.txt`: 查看上面生成的文档;
  + `tree`命令需要安装:`sudo apt-get install tree`;
  + `tree .git`: 查看.git目录下的文件树;
+ 关于add后多出的object目录:
  + git add后生成的git对象object,保存了以下内容:
  + `git cat-file -t 8d0e41`: 查看object目录下生成sha1对象的类型type, 返回一个blob类型;
  + `git cat-file -p 8d0e41`: 查看object目录下生成sha1对象的内容, 返回`git add`提交文件的内容;
  + `git cat-file -s 8d0e41`: 查看object目录下生成sha1对象的内容, 返回`git add`提交文件的内容;
  + 这个sha1命名的blob对象只保存了文件的内容, 而没有保存文件名,下面的命令证实这一过程:
    + `echo "hello git">tmp.txt`: 生成一个内容完全一样的文档, 只是文件名不同;
    + `git add tmp.txt`: 发现object目录下并未发生任何变化;
    + `echo "hello git git">tmp1.txt`: 生成一个内容完全一样的文档, 只是文件名不同;
    + `git add tmp1.txt`: 此时发现object目录发生了变化, 生成了新的sha1;

## 三. 聊聊blob对象和SHA哈希
+ `blob`对象:
  + `git add`后生成一个`blob`对象,保存在`object`中:

+ `hash`值算法:
  + `echo "blob 10\0hello git" | shasum`
+ 




## 四. 聊聊工作去和索引区

## 五. git commit背后到底发生什么

## 二. add
## 二. add
## 二. add
## 二. add
## 二. add