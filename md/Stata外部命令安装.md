# Stata命令安装和常用命令
## 一、命令路径设置
+ 命令存放路径：
  + 命令格式为.ado；
  + stata安装目录下存在一个【ado】的文件夹，用来存放不同命令：
    + 【base】文件夹：存储stata自带的基础命令；
    + 【plus】文件夹：存储外部命令；
    + 【personal】文件夹：存储自己编写的命令和dofiles；
+ 命令路径设置：
  + 可以在安装目录下新建一个profile.do文件，用来初始化一些设置：
  ```
  adopath + "D:\stata16\ado\plus"               //添加plus文件夹到搜索目录；
  sysdir set PLUS "D:\stata16\ado\plus"         //外部命令存放位置；
  sysdir set PERSONAL "D:\stata16\ado\personal" //个人文件夹位置；
  cd `c(sysdir_personal)'
  ```
## 二、命令安装
### 2.1 官方命令
+ 官方命令是从波士顿大学档案馆中查询安装的，常用命令如下：
  + `ssc install package`：安装；
  + `ssc uninstall package`：卸载；
  + `ssc describe package`：描述；
  + `ssc hot,n(10)`：查询ssc上最热门的10个命令；
  + `ssc new`：查询ssc上最新命令；
  + `ado dir`：显示已安装的ado文件；
  + `ado find(winsor2)`：查看winsor2命令是否安装；
  + `help ssc`：更多ssc相关。
### 2.2 外部命令
+ 根据来源外部命令有以下几种来源：
  + `search`
    + :比`ssc`搜索范围更广，语法：`search word [word...] [,options]`,例如：
      ```
      search linear regression, all
      search linear regression, net
      search linear regression, sj
      search linear regression, faq
      search linear regression, manual
      ```
    + 当定义 all 时，其搜索范围很广，包括软件自带的系统文件，Stata 网站的常见问题集，Stata journal 期刊及其他网络相关资料。因此，与 ssc 不同，search 命令不仅可以搜索外部命令，也能搜索其他相关文档资料。
    + search + net: 与 net search 等价，通过该命令可以搜索发布在 Stata Journal (SJ) 和Stata Technical Bulletin (STB)上的相关资料。资料不仅包括 ado 命令 文件，还包括帮助文件 (help files) 和数据集 (datasets).
    + search + sj: 仅搜索 Stata Journal 和 Stata Technical Bulletin 上的资源。
    + search + faq: 仅搜索到发布在 Stata 官网 http://www.stata.com 中的 FAQS 条目下的资源。
    + search + manual: 仅搜索 Stata 电子手册文档上的资源。
  + `net`
    + 与`search`语法类似，功能也较多，可以通过`help net`查看；
    + `net search word [word ...] [, search_options]` 该命令与上面介绍的 `search + net` 等价；
    + `net install` 语法如下:
      ```
      net install pkgname [, all replace force from(directory_or_url)]
      net install github, from("https://haghish.github.io/github/")
      ```
    + net sj vol-issue [insert] 这个用法很强大，有时候我们想把 Stata Journal 某一期所涉及的外部命令都下载到本地，比如想安装 2018年第 3 期文中的所有文件，可以使用如下命令：`net sj 18-3`，等价于：
      `net from "http://www.stata-journal.com/software/sj18-3"`
  + `findit`
    + `findit + keyword` 等价于 `search keyword [keyword ...], all`；
    + 可以搜索的资料包括： 系统文件 the system help, the FAQs, the Stata Journal, and all Stata-related Internet sources including user-written additions. 如我们想了解 Stata 中有关面板单位根检验方面命令与资料，可以执行如下命令：
      `findit panel unit root`
  + `github`
    + 在 GitHub 中，用户可以十分轻易地找到海量的开源代码。
    + 为了使用这一外部命令，首先要通过以下命令进行安装：
      `net install github, from("https://haghish.github.io/github/")`
    + 完成 github 安装，通过 help github，可以发现其语法如下：
      `github [ subcommand ] [ keyword | username/repository ] [, options]`      
    + github search: 该命令可以对托管到 github 平台的 Stata 相关命令进行搜索，比如我们想知道在 github 平台上有哪些面板数据模型相关命令，可以输入：
    `github search panel data model, in(all)`
    + 点击 Install 会自动安装最新版本，若想安装此前的某个版本，则可以使用 github install 命令的 version() 选项加以控制：
    `github install haghish/MarkDoc , version("3.8.0")`
    + 通过query将所有的版本罗列出来，自己选择安装：
    `github query haghish/weaver`
    + 检查程序是否安装,在stata中安装GitHub网站的程序，不仅需要有程序的安装包文件packagename.pkg，而且需要放置一个文件stata.toc在Stata文件的目录中。这时候您就可以使用check子命令，它会自动检查stata.toc、packagename.pkg是否存在，并且说明对应命令是否安装。例如：
    `github check gvegayon/devtools`
### 2.3 总结
+ 可将本部分内容归结为两点：
  + 当知道外部包的具体命令写法时，通常可以利用 ssc install, net install ，github install 等命令直接安装；
  + 若只知道该命令的大体功能或关键词，而不知道具体名称，可以通过 findit，search，github search 等命令进行搜索，在返回的结果中查找安装。
  + 为了保证外部命令能够被 Stata 自动检索到，需要在 profile.do 文档中设定文件路径。

## 三、常用命令
### 3.1 文件操作
