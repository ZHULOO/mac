# atom安装和使用教程:
+ `ctrl+shift+=` --> `window:Reload` :重启

## 一、便携版安装：
+ 1、进入官网，下载便携版atom x64 64位版本
+ 2、移动用户目录：
  + 用户目录原本位于C盘user的.atom下；
  + 在D盘新建一个atom文件夹；
  + 用CMD命令在atom下新建一个.atom文件夹：
    ```
    cd D:\atom
    mkdir .atom
    # 不能直接新建.atom文件夹，只能通过cmd命令创建
    ```
  + 然后将软件解压缩目录atom x64和.atom文件夹同放在atom文件夹下；
  + atom会自动将用户配置文件及packages自动转移至刚创建的.atom文件夹下；
+ 3、配置环境变量：
  + 便携版的环境path为：D:\Program Files\Atom\Atom x64\resources\app\apm\bin
  + 将以上path添加到用户和系统path中，就可以在CMD窗口中直接运行apm命令；
  + 打开CMD,输入`apm ls`看是否配置成功,区别npm和apm;
+ 4、修改国内镜像源：
  + 方法一：修改配置文件：
    + 找到目录：D:\Program Files\Atom\.atom；
    + 打开此文件夹下的名为 .apmrc(不是~\.atom\.apm\.apmrc) 的文件并编辑；
    + 添加以下的两行内容：
    ```
    registry=https://registry.npm.taobao.org # 淘宝镜像
    strict-ssl=false
    ```
  + 方法二：CMD命令：
    + 已配置环境变量下，直接打开CMD窗口，输入：
    ```
    apm config set registry https://registry.npm.taobao.org
    ```
  + 最后: 检验看是否修改成功:
    + 运行以下命令:
    ```
    apm install --check
    ```
    + 或者执行以下命令看 https-proxy 是否出现在输出中，可以证实设置是生效的：
    ```
    apm config list
    ```
+ 5、三种插件安装方法
  + 方法一：菜单操作
    + atrl+，打开设置菜单；
    + 找到packages项直接搜索和安装。
  + 方法二：apm命令：
    + 输入以下命令：
    ```
    apm install xxx packages_name #命令方式又安装到C盘user下的.atom目录下了;
    ```
  + 方法三：github安装：
    + 菜单操作安装连接不上的时候采用此种方法;
    + 进入packages文件夹；
    + clone github代码文件夹；
    + 进入clone到本地的代码文件件；
    + apm安装,例如:
    ```
    cd ~/.atom/packages
    git clone https://github.com/emmetio/emmet-atom
    cd emmet-atom
    apm install
    ```
  + 插件更新错误处理：
    + 清空`.atom/.apm`文件夹，再次尝试更新。

## 二、atom下配置stata,R和Python
### 1、atom运行Stata,R和Python有两种方法:
  + 方法一：将代码发送到原终端运行
      + 此方法对比Rstudio等无优势,
      + 尤其Stata,借助stata-exec插件,设置繁琐;
  + 方法二：借助hydrogen插件连接jupyter运行(推荐)
    + 此方法方便快捷;
    + 类似于jupyter的思路;

### 2、方法一无优势不再介绍，下面详细介绍方法二：
+ 方法二的思路：
  + a、jupyter lab已正常安装和使用Stata、R和Python内核;
  + b、在atom中安装hydrogen插件，下面详细介绍：

+ a、jupyter lab中内核安装：
  + 为jupyter安装stata内核:
		+ 注册stata:
			+ 管理员身份打开CMD,cd进入stata安装目录;
			+ 输入StataMP-64.exe/Register;
			+ 取消注册输入StataMP-64.exe/Unregister;
    + CMD命令安装stata_kernel内核：
    ```
    pip install stata_kernel
    python -m stata_kernel.install
    ```
    + stata语法高亮:
    ```
    conda install -c conda-forge nodejs -y
    jupyter labextension install jupyterlab-stata-highlight #在此之前需要安装node.js.
    ```
    + stata_kernel更新:
    ```
    pip install stata_kernel --upgrade
    python -m stata_kernel.install
    ```
  + 为jupyter安装R内核
    + 方法一、R语言环境下运行以下代码：
      ```
      install.packages('IRkernel')
      IRkernel::installspec() #参见主页: https://github.com/IRkernel/IRkernel
      ```
    + 方法二、CMD终端下运行一下代码
      ```
      conda install -c r r-irkernel # 安装r-irkernal库;
      ```
  + 为jupyter安装Python内核
    + 推荐使用anaconda安装python套件,自带安装jupyter lab;
    + jupyter是python语言实现，默认已安装好python内核；

+ b、atom中hydrogen插件安装：
  + Hydrogen插件：连接jupyter和atom, jupyter lab下各内核安装运行正常的话，在atom中均可以借助hydrogen插件直接运行各语言（R,STATA,PYTHON)；
  + 安装Hydrogen：选择菜单键安装，命令会安装到c盘user目录下。
  + 分别对应安装：
  ```
  atom-language-r
  language-python
  language-stata # 这是三语言对应的语法匹配和高亮插件。
  ```
  + 使用hydrogen运行代码
  ```
  ctrl+shift+p -->输入"hydrogen"-->run
  shift+enter # 设置快捷键
  ```

## 三、md文件中运行标记的三种代码段
+ md使用以下方式标记代码块可以直接运行：
  + python代码块：
    ```
        ```python
        print("hello,world")
        ```
    ```

  + R代码块：
    ```
        ```r
        print("hello,world")
        ```
    ```

  + Stata代码块：
    ```
        ```stata
        sysuse auto,clear
        reg price mpg
        ```
+ 在代码文件中使用hydrogen运行；
  + 快捷方式
+ 在preview预览中运行：

## 四、快捷键
+ 设置快捷键:
```
File-->keymap # 打开快捷键设置文件;
unset         # 取消绑定快捷键
```
+ 常用快捷键:

|快捷键|对应操作|
|:-----|:-----|
|`enter`|换行或选中自动补全代码|
|`tab`|自动补全并选中|
|`shift+enter`|hydrogen中运行当前行,并跳到下一行|
|`alt+enter`|强制换行|
|`alt+1/2/3...`|切换第1/2/3...个tab|
|`alt+F1/F2`|向右/下分屏|
|`ctrl+enter`|.py代码中,在终端中运行选中的代码|
|`ctrl+shift+d`|复制行|
|`ctrl+shift+p`|打开命令面板|
|`ctrl+alt+up/down`|向上/下复制光标|
|`ctrl+up/down`|向上/下移动当前行|
|`ctrl+d`|先向下选中相同代码|
|`ctrl+"+"`|代码字体变大|
|`ctrl+"-"`|代码字体变小|
|`ctrl+L`|选中一行|
|`ctrl+shift+left/right`|向左/右增加选中一个word|
|`shift+left/right`|向左/右增加选中一个字母|
|`ctrl+shift+home/end`|向前/后选中全部|
|`ctrl+"."`|向前/后选中全部|

## 五、插件备份
  + 安装sync-settings插件;
  + 创建gist
    + github中
  + `ctrl+shift+p-->输入sync-->backup`同步插件至gist,失败了多试几次;
  + `ctrl+shift+p-->输入sync-->restore`恢复插件;

## 六、常用的几种插件
+ snippets插件：设置特定的代码段，使用tab键调出。
  + 首先要分清什么语言代码：
    使用`ctrl+shift+p-->"Editor:Log Cursor Scope"`查看当前代码是那种类型,例如:
    ```
    text.md :language-markdown的scope;
    source.coffee
    text.plain
    source.gfm...   # github flavored markdown
    ...
    ```
  + 为特定的语言类型设置snippets快捷键:
    例如为`source.gfm`设置snippets:
    打开snippets.cson输入以下代码并保存:
    ```
    '.source.gfm':
      'blue-font-in-markdown':
        'prefix': '<fb'
        'body': '<font color=blue>$1</font>'
    ```
  + 当在.gfm即github flavored md代码中输入`<fb`然后按`tab`键就能输入它代表的`<font color=blue>$1</font>`的内容.


## 七、配置atom作为latex编辑器：
+ 1、安装texlive2019终端；
+ 2、安装下面三个插件：
```
atom-latex      # 编译,语法等设置,比latex插件好用；
language-latex  # 语法高亮；
pdf-view        # 编译成pdf后预览；
```
+ 3、atom-latex插件设置:
	+ 通过`custom toolchain commands`设置编译顺序
	+ 默认的顺序:xelatex-->bibtex-->xelatex-->xelatex
		`%TEX %ARG %DOC.%EXT && %BIB %DOC && %TEX %ARG %DOC.%EXT && %TEX %ARG %DOC.%EXT`
	+ 如果只使用xelatex编译一次,则将`custom toolchain commands`设置为:
		`%TEX %ARG %DOC.%EXT`
	+ 也可以设置为如下,使用xelatex编译三次:
		`%TEX %ARG %DOC.%EXT && %TEX %ARG %DOC.%EXT && %TEX %ARG %DOC.%EXT`;
	+ 通过`latex compiler to use`设置使用的编译工具,例如设置为`xelatex`;
	+ 通过`latex compiler execution parameters`设置命令行运行参数,例如`--shell-escape`;

## 八、npm和apm
+ `npm`: 随同NodeJS一起安装的包管理工具,NodeJS packages management;
+ 本机使用anaconda安装了NodeJS,在`D:\Anaconda\node.exe`目录下;
+ `apm`: atom封装的`npm`用来实现atom packages management的功能,安装在`D:\Program Files\Atom\Atom x64\resources\app\apm\bin\node.exe`目录下;
+ 两个命令使用的`node.exe`不一样;
+ 可以分别使用`apm config list`和`npm config list`来查看二者的设置和区别;
+ `npm`常用命令`apm`也可以使用,二者还是要分开用,实现的功能不同,如下:
  + `apm`是将`packages`从GitHub安装到`~/.atom/.packages`文件夹,
  + npm`是将`packages`从npmjs.com安装到`node_modules`文件夹；
```
npm -v              # 检查看是否安装成功;
npm install npm -g  # 升级;
npm install -g cnpm --registry=https://registry.npm.taobao.org # 使用淘宝镜像安装;
cnpm install <Module Name>
npm config set registry https://registry.npm.taobao.org # 修改淘宝镜像源;
npm config get registry # 如果返回淘宝镜像地址,说明修改成功;
npm install <Module Name> # 安装模块;
npm install express          # 本地安装：安装在运行npm时所在的目录;
npm install express -g       # 全局安装：安装在user/local或者node的安装目录;
npm list            # 列出全部模块；
npm list grunt      # 查看grunt模块的版本号；
npm uninstall xxx   # 卸载；
npm update xxx      # 更新；
npm search xxx      # 搜索；
npm config list     # 列出npm的配置信息;
```
## 九、atom下的apm命令
+



## 九、代码类型（扩展名）
+ `ctrl+shift+L`快捷键，然后根据需要选择代码类型；
