# power shell相关
## power shell,terminal和cmd的区别:
+ cmd:命令提示符;
+ power shell增强版的命令提示符;
+ 还有bash等命令窗口;
+ 它们是不同的命令终端窗口,可以互相切换,但是用起来切换还是比较麻烦;
+ 可以使用windows terminal来综合管理它们;

## 配置最新power shell:
+ [下载安装](https://github.com/powershell/powershell "点击下载");
+ 默认安装就行;
+ 进行配置:
+ 管理员身份打开powershell,然后运行一下命令:
```
install-module posh-git     # 为git状态信息添加到提示，并为git命令参数添加自动补全；
install-module oh-my-posh   # 为PowerShell提示符提供主题功能；
import-module posh-git
import-module oh-my-posh
set-theme paradox
set-prompt # 使用；
```
+ 需要安装Cascadia字体，否则一些符号乱码；

## power shell常用命令;
+ `get-command`
+ `get-help 命令名`
+ ``
+ ``
+ `start .`:打开当前目录;
+ ``
+ ``
+ ``
