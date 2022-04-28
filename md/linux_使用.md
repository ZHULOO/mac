#  <i class="fa fa-user-circle-o" aria-hidden="true"></i> Linux使用

+ 远程xshell:
+ Ubuntu本机shell:

## 一. 用户管理
+ 1.添加用户
  + `useradd zhangsan`:创建一个名为zhangsan的用户,并在/home下创建一个同名的家目录,即`/home/zhangsan`;
  + `useradd -d /home/test king`:创建一个名为king的用户,但是指定用户目录在/home/test下,而不是默认的/home下;
  + `passwd king`:给king用户设置密码,给谁设置密码一定要加上用户名,否则默认给当前登录用户修改了密码;

+ 2.删除用户
  + 注意是否保留同名的家目录;
  + 自己删除不了自己;
  + `userdel king`:默认保留了家目录;
  + `userdel -r king`:删除king用户的同时也删除了king对应的家目录;

+ 3.查询用户信息
  + `id tom`:查询tom用户的信息;
  + `whoami`:查看当前工作的用户信息;

+ 4.切换用户
  + 注意当前命令终端:
    + 如果是远程shell,可以直接操作切换用户;
    + Ubuntu系统界面shell无法退出当前用户,因为已经登录;
  + 注意`su tom`和`su -tom`的区别:
    + `su tom`:只切换了用户tom,而没有切换环境;
    + `su -tom`:切换到高级用户权限,并切换相应环境;
    + `su -`:没加用户名表示切换到高级用户权限,并切换相应环境;
  + `su - tom`:直接切换到tom用户,及其环境;
  + 从权限高的用户切换到权限低的用户不需要密码,反之需要密码;
  + 当返回原来用户时,使用`exit`或`logout`命令;


+ 5.文件权限
  + 

+ 6.用户组
  + 类似于角色, 系统对多个拥有共性或权限的多个用户进行统一管理;
  + `groupadd wudang`:新增组;
  + `groupdel wudang`:删除组;
  + `useradd -g wudang zwj`:增加一个zwj用户并指定到wudang组;
  + `useradd zwj`:当增加用户时没有指定组,则会同时生成一个与用户名相同的组;
  + `usermod -g mojiao zwj`:将张无忌从wudang切换到mojiao组;
  + 用户和组相关的文件:
    + `/etc/passwd`:用户的配置文件,记录用户的各种信息;
    + `/etc/shadow`:口令的配置文件;
    + `/etc/group`:组的配置文件;

## 二. 文件操作
+ linux的隐藏文件是以`.`开头的.
+ 文件操作
  + `cd`:切换工作目录:
    + `cd ~`:回到当前用户的家目录`/home/tom`.
    + `cd ..`:回到当前目录的上一级目录.
    + `cd ../../`:回到当前目录上一级的上一级目录.
  + `ls`:list列出当前目录文件:
    + `ls -a`:all列出所有文件, 包括以`.`开头的隐藏文件.
    + `ls -al`:单列显示所有文件, 包括以`.`开头的隐藏文件.
    + `ls -la`:a 和 l表示命令选项,可以组合使用,并且不分先后.
    + `ls -la /root`:显示root目录下的所有文件.
  + `pwd`:显示当前目录文件.
  + `mkdir`:创建目录
    + `mkdir /home/dog`:创建一级目录.
    + `mkdir -p /home/animal/dog`:创建二级目录需要加参数`-p`.
  + `rmdir`:删除目录
    + `rmdir /home/dog`:删除一个目录,必须是空目录.
    + `rm -rf`:使用`-rf`选项删除非空目录,`-r`:recursive递归,`-f`:force强制.
  + `touch`:创建空文件
    + `touch hello.txt`:创建一个空的hello.txt文件.
  + `cp`:拷贝文件
    + `cp hello.txt bbb/`:将hello.txt拷贝到bbb文件夹下.
    + `cp -r /home/bbb/ /opt/`:将bbb文件夹拷贝到opt目录下.
    + `\cp -r /home/bbb/ /opt/`:如果复制时文件已存在,则覆盖.
  + `mv`:移动或重命名
    + `mv oldNameFile newNameFile`:同一目录下是重命名.
    + `mv /temp/movefile /targetFolder`:不同目录是移动文件.
    + `mv /opt/bbb /home/`:将bbb文件夹移动到home目录下.
  + `cat`:查看文件内容
    + `cat file`:只查看文件,而不能编辑,比较安全.
    + `cat -n /etc/profile`:显示行号.
    + `cat -n /etc/profile | more`:管道交给`more`命令处理.
    + `more /ect/profile`:查看文件,内置了很多快捷键,交互方式
      :one: `space`:表示向下翻页.
      :two: `enter `:向下翻一行.
      :three: `q`:退出.
      :four: `ctrl+F`:向下滚动一屏.
      :five: `ctrl+B`:返回上一屏.
      :six: `=`:输出当前行的行号.
      :seven: `:f`:输出文件名和当前行的行号.
  + `less`:逐步加载文件进行显示查看,尤其是对大文件
    + `less /opt/杂文.txt`:
    + `space`:向下翻动一页.
    + `pageup/pagedown`:向上/下翻动一页.
    + `/+字符串`:向下搜索字符串,`n`:向下查找,`N`:向上查找.
    + `?+字符串`:向上搜索字符串,`n`:向下查找,`N`:向上查找.
    + `q`:退出.
  + `echo`:输出内容到控制台
    + `echo $PATH`:输出环境变量.
    + `echo $HOSTNAME`:输出主机名.
    + `echo "hello world"`:输出hello world.
  + `head`:显示文件的开头部分,`tail`查看文件尾部
    + `head /etc/profile`:默认查看profile文件的前10行内容.
    + `head -n 5 /etc/profile`:查看profile文件的前5行内容.
    + `tail -f mydate.txt`:能实时追踪更新mydate.txt中的内容.
  + `>`和`>>`:输出重定向
    + `>`:覆盖.
    + `>>`:追加.
    + `ls -l > info.txt`:列表内容写入info.txt文件中,如果info.txt文件不存在,则会创建.
    + `ls-al >> info.txt`:列表内容写入info.txt文件,追加写入,不会覆盖.
    + `cat a.txt > b.txt`:将a.txt的内容覆盖到文件b.txt.
    + `echo "text" >> a.txt`:将text追加到a.txt.
  + `ln`:软链接,类似于win中的快捷方式
    + `ln -s /root /home/myroot`:在home目录下创建了一个myroot,但是它指向的是/root目录.
    + `rm /home/myroot`:删除刚才创建的软链接myroot.
  + `history`:查看已经运行的命令
    + `history 10`:查看最近使用过的10条指令.
    + `!5`:执行曾经执行过的第5个命令.
  + `tar`:压缩打包
    + `tar -zcvf pc.tar.gz /home/pig.txt /home/cat.txt`:将home目录下的pig.txt和cat.txt打包压缩为pc.tar.gz.
    + `tar -zcvf myhome.tar.gz /home/`:将home文件夹压缩为myhome.tar.gz.
    + `tar -zxvf pc.tar.gz`:将pc.tar.gz解压到当前目录.
    + `tar -zxvf /home/myhome.tar.gz -C /opt/tmp2`:将home下的myhome.tar.gz解压到opt/tmp2文件夹下, `-C`:C大写指定解压目录.
    + `-z`：压缩和解压缩 ".tar.gz"格式.
    + `-j`：压缩和解压缩 ".tar.bz2"格式.
    + `-x`：解打包.
    + `-t`: 用于查看压缩包内容,而不执行解压.
    + `-c`：打包.
    + `-f`：指定压缩包的文件名.
    + `-v`：显示打包文件过程.







## 三. 远程登录
+ SSHD远程服务开启


## 四. 运行级别
+ `init 0`:切换0运行别,关机.
  + 0:关机
  + 1:单用户[找回丢失的密码]
  + 2:多用户状态,没有网络服务
  + 3:多用户状态,有网络服务
  + 4:系统未使用保留给用户
  + 5:图形界面
  + 6:系统重启
+ 常用运行级别是3和5,也可以指定默认运行级别.
+ 运行级别文件保存在/etc/inittab文件中.
+ `systemctl get-default`:查看当前运行级别.
+ `systemctl set-default multi-user.target`:将默认运行级别设置为多用户, 即3级别.
+ `graphical.target`为图形界面级别, 即为5级别.

## 五.帮助指令
+ `man+指令`:查看该指令的说明,例如`man ls`, 空格下一页,`q`退出.
+ `help+指令`:获取shell内置命令的帮助信息.






## 六.vim编辑器
+ vim的三种模式:
<div align="center"> <img src="/md/linux/vim_1.png" width="500" /> </div>

+ 命令模式(一般模式):
  + 默认处于命令模式,此模式下,可使用方向键（上、下、左、右键）或 k、j、h、i 移动光标的位置，还可以对文件内容进行复制、粘贴、替换、删除等操作。

|快捷键|对应操作|
|:-|:-|
|`dd`|删除光标所在一整行|
|`ndd`|删除光标向下的n行|
|`d1G`|删除光标所在到第一行的所有数据|
|`dG`|删除光标所在到最后一行的所有数据|
|`d$`|删除光标所在到改行的最后一个字符|
|`d0`|删除光标所在到改行的第一个字符|
|`yy`|复制光标所在的那一行|
|`nyy`|复制光标所在向下的n行|
|`y1G`|复制光标所在到第一行的所有数据|
|`yG`|复制光标所在到最后一行的所有数据|
|`y$`|复制光标所在到改行的最后一个字符|
|`y0`|复制光标所在到改行的第一个字符|
|`p小写`|p将复制的数据粘贴到光标所在下一行上|
|`P大写`|P将复制的数据粘贴到光标所在上一行|
|`n<space>`|光标向右移动n个字符|
|`n<enter>`|光标向下移动n行|
|`0`|移动到当前行第一个字符|
|`$`|移动到当前行最后一个字符|
|`H`|光标移动到该屏最上方一行的第一个字符|
|`M`|光标移动到该屏中央一行的第一个字符|
|`L`|光标移动到该屏最下方一行的第一个字符|
|`G`|移动到该文件的最后一行|
|`nG`|移动到该文件的第n行|
|`gg`|移动到该档案的第一行|
|`/keys`|向下搜索"keys"的字符串|
|`?keys`|向上搜索"keys"的字符串|
|`n`|继续搜寻下一个名称为"keys"的字符串|
|`N`|反向继续搜寻下一个名称为"keys"的字符串|
|`J`|将光标所在行与下一行的数据结合成同一行|
|`c`|重复删除多个数据，例如向下删除 10 行，[ 10cj ]|
|`u`|复原前一个动作,撤销|
|`Ctrl+r`|重做上一个动作,重做|
|`Z+Z`|保存并退出,相当于`:wq`|
|`Z+Q`|不保存,强制退出,相当于`:q!`|
|`:n1,n2s/word1/word2/g`|在第 n1 与 n2 行之间寻找 word1 这个字符串，并将该字符串取代为 word2 |
|`:1,$s/word1/word2/g`|从第一行到最后一行寻找 word1 字符串，并将该字符串取代为 word2|
|`:%s/word1/word2/g`|从第一行到最后一行寻找 word1 字符串，并将该字符串取代为 word2|

+ 输入模式(编辑模式):
  + 一般键盘功能都可用.
  + `Ctrl+n`:自动补全.
  + `\p<`:插入一个include，并把光标置于<>中间.
  + `\im`:插入主函数.
  + `\ip`:插入printf，并自动添加\n，且把光标置于双引号中间.
  + `dw`:删除一个单词（配合b：将光标置于所在单词的首部）.
  + `yw`:复制一个单词（配合p：粘贴）.
  + vim快捷键补充（插入与编辑模式通用）:
    + `\rr`:运行程序.
    + `\rc`:保存并编译程序（会生成二进制文件）.

+ 末行模式(指令行模式)：

|命令|对应操作|
|:-|:-|
|`:q`|退出编辑模式|
|`:q!`|强制退出不保存|
|`:wq`|保存后退出|
|`:wq!`|强制保存后退出|
|`:set nu`|显示行号|
|`:set nonu`|取消行号|
|`:w [filename]`|将编辑的数据储存成另一个档案（类似另存新档）|
|`:r [filename]`|将『filename』这个档案内容加到游标所在行后面|
|`:n1,n2 w [filename]`|将 n1 到 n2 的内容储存成 filename 这个档案|
|`:! command`|`:! ls /home`即可在 vi 当中察看 /home 底下以 ls 输出的档案信息|
