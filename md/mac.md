# MAC使用
## 一、常用快捷键

|快捷键|功能|
|:-- |:-- |
|`command + c` | 复制|
|`command + v`|粘贴 |
|`command + option + v`| 剪切 |
|`command + h`| 隐藏 |
|`command + m `| 最小化 |
|`command + w `| 关闭 |
|`command + z `| 撤销 |
|`command + shift + z `| 重做 |

## 二、常用文件夹
+ MAC硬盘中各个文件夹，打开Macintosh HD你会发现内中有四个文件夹：
  + 应用程序(Applications)；
  + 系统(System)；
  + 用户(User)；
  + 资料库(Library)。
+ 四个文件夹中又分别各有若干数量的文件夹存在。

### 1. Applications（应用程序）
+ 这个是存放各种软件的位置。

### 2. System（系统）
+ 包含由Apple安装的系统软件。这此资源是系统正常运行所必须的，位于启动卷宗中。
+ `/System/Library/CFMSupport CFM, Code Fragment Manager,` 等同旧Mac OS应用程序都会使用的共有程式库. 以确保Mac OS环境的一致性. 当中储存有一个在OS X中极为重要的档桉—CarbonLib, 是执行炭火软件时必不可欠的档桉. 此外还有DiscRecordingLib(CD/R-RW用的程式库), OpenGLLib(OpenGL), stbCLib(c语言)。
+ `/System/Library/DTDs` 作为存放系统所使用的各种XML档桉, 并为其格式定义之档桉. Mac OS X Data形式製成的文书, 分别由三个档桉管理, 分别是PropertyList.dtd, KeyboardLayout.dtd及sdef.dtd三个档桉所组成. 而DTD, 全名为Document Type Definition. 此外, .plist档桉亦是由XML撰写出来的。
+ `/System/Library/Extensions` 其实这裡就是用作存放硬件驱动的地方,苹果不称驱动程序为driver, 而是称为Extension。
+ `/System/Library/Filesystems` 主要就是用以存放OS X对应及支持何种档桉格式的资料. 例同标准的AppleShare(苹果档桉分享标准), ISO 9660/FTP/HFS及至网络上用的如Samba等。
+ `/System/Library/HelpViewer` 一切和Mac OS Help有关的档桉及文件都存放于此。
+ `/System/Library/Find` 就是搜寻机能了. 是对应多国语言的。
+ `/System/Library/OpenSSL` 全名为Secure Sockets Layer. 是一套通讯加密技术, 一般用于Web服务器上, 会将密码传送时以加密的暗号处理, 从而减低第三方成功盗 取资料的可能. 一般应用于以https开首的URL上. Mac OS X内置的WebServer—Apache, 亦包含这个服务。
+ `/System/Library/CoreServices/Dock`这是OS X的特徵之一, 这部份是有关Dock的资料。
+ `/System/Library/CoreServices/Finder.app`这个比较特别, 因为这是一个应用而非一个档桉夹, Finder.app可说是负责掌控整个OS上的一切资源。
+ `/System/Library/CoreServices/Kerberos`由MIT(麻省理工大学)开发的网络认证技术. 能够很简单地以单一ID登入系统的检证技术. Mac OS X支援其版本4的Kerberos. 所谓Kerberos, 在希腊神话中是一头住在冥界, 拥三头, 蛇尾的地狱守门犬。
+ `/System/Library/CoreServices/Menu ExtrasStatus bar`上面所有系统自带工具的原文件，双击打开可以直接在status bar上添加相应文件。
+ `/System/Library/CoreServices/Setup Assistant`所有有关设定助理的资料都存放于此。
+ `/System/Library/CoreServices/Software Update`这裡就是负责Software update的地方。

### 3. Library（资料库）
+ 系统资源库。
  + 比如字体、ColorSync 配置、偏好设置以及插件都应该安装在 Library 目录下适当的子目录中。
  + `Application Support`包含了应用相关的数据以及支持文件，比如第三方的插件，帮助应用，模板以及应用使用到但是并不需要用来支持运行的额外资源文件。按照惯例，所有这些内容都会被存储在以应用名称命名的子目录当中。
  + `Assistants`包含了帮助用户进行配置或者其它任务的程序。
  + `ColorPickers`包含了用来选择色彩的资源，它们根据某种模型，比如 HLS (色彩角、饱和度、亮度) 选择器或者 RGB 选择器。
  + `ColorSync`包含了 ColorSync 配置和脚本。
  + `Components`包含了系统包和扩展。
  + `Contextual Menu Items`包含了用于扩展系统级菜单的插件。
  + `Dictionaries`包含了系统自带的字典文件。
  + `Desktop Pictures`桌面图片目录。
  + `Documentation`包含了供计算机用户和管理员参考的文档文件和 Apple 帮助包。(Apple 帮助包在Help 子目录当中。) 在本地域中，这个目录包含了 Apple 公司发布的帮助包(不包括开发者文档)。
  + `Extensions`包含了设备驱动和其它内核扩展。(只存在于系统域当中。)
  + `Favorites`包含了指向经常访问的文件夹、文件或者网站的别名。(仅仅存在于用户域当中。)
  + `Fonts`包含了用于显示和打印的字体文件。
  + `Java`包含了Java运行环境。
  + `StartupItems`包含了在系统导入时刻运行的系统以及第三方脚本和程序。 (更多有关系统导入时刻启动步骤的信息请参考系统启动程序主题)

### 4. User（用户）
+ 包含了某个用户专有的资源。这里也有一个Library文件夹，不同与上边的那个Library，是专为你的帐号服务，里面放的是你自己的个性化字体、配置文件等。
+ `Applications`包含仅仅当前用户可用的应用。
+ `Desktop` 包含了 Finder 在当前登录用户桌面上显示的桌面项。
+ `Documents` 包含了用户的个人文档。
+ `Download` 包含了下载的各种文档。
+ `Library` 包含了应用设置、偏好设置一起其他用户专有的系统资源。
+ `Documentation`包含了供计算机用户和管理员参考的文档文件和 Apple 帮助包。(Apple 帮助包在Help 子目录当中。) 在本地域中，这个目录包含了 Apple 公司发布的帮助包(不包括开发者文档)。
+ `Extensions`包含了设备驱动和其它内核扩展。(只存在于系统域当中）

### 5.硬盘中还有几个隐藏文件夹
+ 1、bin———储存有基本的UNIX指令
+ 2、sbin——–UNIX 系统指令的储存地方, 是比较进阶的指令
+ 3、etc———系统设定档桉储存地方     
+ 4、var———改动频繁的档桉, 都置放于此, 例如各log档桉      
+ 5、tmp——–系统的暂存档      
+ 6、usr———UNIX的使用者专用档桉夹      

## 三、环境变量配置
- 一般bash环境变量保存在`～/.bashrc`中；
  - 如果修改`.bashrc`文件，zsh终端中依然不能直接使用，需要在`.zshrc`中添加`source .bashrc`语句；
- 而`mac`默认使用`zsh`终端，环境变量信息保存在`～/.zshrc`，直接编辑`.zshrc`添加：
- 以`python`为例添加环境变量：
  - `vim`打开`.zshrc`添加：`export PATH="/opt/anaconda3/envs/geo/bin:$PATH"`语句，然后运行`source .zshrc`生效；
## 四、安装brew
+ 参考：[国内源](https://gitee.com/cunkai/HomebrewCN)

