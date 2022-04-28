# WSL教程:
## 一. win10安装
+ 更新到WSL2需要win10 1903版本或者内部版本18362以上版本;
### 1.1 自动安装
+ 管理员模式打开命令行输入: `wsl.exe --install`;
+ 重启计算机;
+ 默认安装Linux分发版为Ubuntu;
+ 查看Linux分发版列表, 输入: `wsl --list --online`;
+ 可以使用`wsl --install -d <Distribution Name>`安装指定的分发版到计算机.
### 1.2 手动安装
+ 管理员模式打开PowerShell;
+ 输入`dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart`启用win10的WSL功能;
+ 输入`dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart`启用虚拟机功能;
+ 重启后安装 [适用于x64计算机的WSL2 Linux内核更新包](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi);
+ 输入`wsl --set-default-version 2`设置WSL2为默认;
+ 运行Microsoft Store安装Ubuntu;

## 二. 管理员
+ `$` 普通用户
+ `#` 管理员
+ 初始状态下未设置管理员密码,输入`sudo passwd`后输入要设置的`root`的密码;
+ 进入管理员权限: 输入`sudo`后输入上面设置的`root`密码;
+ 退出管理员模式: 输入`exit`回车;
+ 用户模式下使用管理员命令: `sudo apt...`;
+ 安装包: `sudo apt-get install tree`;
+ "Unable to locate package"时,请更新: `sudo apt-get update`;

## 三. 常用命令
+ `watch -n -1 -d find .`:每一秒刷新显示一次当前目录的文件;
+ `ls -la`:显示当前目录下的所有文件;
+ `rm -rf .git/hooks/*.sample`:删除一定目录下所有后缀为`.sample`的文件;
+ `cat .git/config`:查看当前代码仓库的局部配置文件`config`;
+ `cat .~/.gitconfig`:查看用户全局配置文件, 在用户目录下, 相当于: `cat /mnt/c/Users/Administrator/.gitconfig`;
+ `CTRL+L`: 清屏;
+ 