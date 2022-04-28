# 几款编辑器、常用问题和设置
## VS Code、Atom和Sublimetext
+ VS code：
  + 借助插件，R、Python和Stata均正常使用；
  + Stata运行时插件无法提供命令自动补全，和变量提示等。
+ Atom：
  + 借助Hydrogen插件，实现类似jupyter的命令运行模式；
  + R的help命令等无法正常使用，Stata的一些外部命令(marginscontplot)无法正常使用；
+ Sublimetext：
  + 和上两款编辑器相比，Sublimetext非开源收费，需要破解使用；
  + 配置Stata do文件的编辑器最好用；
  + 运行Python时卡顿，不流畅。
+ 总结：
  + 使用VS Code配置运行R和Python；
  + 使用Atom的Hydrogen插件运行模式进行markdown的编写；
  + 使用Sublimetext运行Stata；

## 一、VS Code基本配置
### 1.1 基本概念
+ `shell`
    ```mermaid
    graph LR
    id1(user<br>用户)-->id2(shell<br>外壳)-->id3(kernel<br>内核)
    ```
    + `shell`是操作系统和外部的接口，位于系统的外层，为用户提供与操作系统核心沟通的途径；
    + shell管理用户与操作系统之间的交互，不同的操作系统有不同的shell：
        + bash ：Bourne Again shell，linus和Unix下的shell，在windows下通过安装Cygwin环境也可以使用，但一些命令无法正常运行；
        + C shell
        + windows power shell：windows下还是使用自己的PowerShell
    + windows操作系统中的资源管理器`explorer.exe`是图形shell；
    + cmd就是命令shell；
    + cmd与dos
        + cmd是一个接口，是命令shell，是windows系统的一部分；
        + dos本身就是一个操作系统，可以删除和修复windows系统。
    + 可以近似地认为linus shell = bash,windows = cmd，都是命令解释器，都是用户与操作系统的交互接口；
    + 但是bash比cmd强大的多，windows也有强大shell叫做windows power shell。

+ 脚本语言
    + 脚本语言的程序代码即最终可执行文件，通过对应的解释器解释执行即可；
    + 每一种脚本语言都有其对应的解释器，如perl、python、Ruby和javascript等，shell属于一种特殊的脚本语言。
### 1.2 snippets
+ 需要开启`Tab`自动补全功能：在settings.json中加入`"editor.tabCompletion": "on"`语句；
+ `ctrl+shift+p`-->输入`snippets`：可以分别设置单个代码语法的snippets，也可以设置全局的snippets。

### 1.3 常用快捷键

|快捷键|执行操作|
|:---|:---|
| `ctrl+shift+p` | 打开命令面板 |
| `ctrl+alt+up/down` | 向上/下对应位置添加光标 |
| `alt+shift+up/down` | 向上/下复制当前行 |
| `` |  |
| `` |  |

###1.4 好用的插件
+ 主题插件
  + 个人喜欢Atom-Material-Theme插件，插件细节详细设置：
      + 在插件的安装目录下找到package.json；
      + 在其中修改注释的字体和颜色等。
+ 优化插件
  + Settings Sync：通过gist将vscode的插件和设置进行备份
      + `alt+shift+u`：上传配置和插件信息，此时一般要关闭一切窗口；
      + `alt+shift+d`：下载配置和插件信息。
  + file-icons：优化代码文件类型的图标；
  + indent-rainbow：使用不同颜色提示缩进；
  + Rainbow-Brackets：使用不同颜色提示不同层次的括号；
## 二、 [markdown-preview-enhanced](https://shd101wyy.github.io/markdown-preview-enhanced/#/zh-cn/ "用户文档")插件　
+ 此插件在Atom下通用；　
### 2.1 修改markdown样式
+ markdown显示的格式取决于预览md文件格式的插件，例如此处的markdown-preview-enhanced插件；
+ `ctrl+shift+p`然后运行`Markdown Preview Enhanced:Customize Css`打开`style.less`样式文件；
+ `style.less`文件位于`~/.mume/style.less`；
+ 通过编辑`style.less`来修改markdown样式：
    ```
    .markdown-preview.markdown-preview {
      // 在这里编写你的样式
      // 例如：
      //  color: blue;          // 改变字体颜色；
      //  font-size: 14px;      // 改变字体大小；
      //  font-family:SimSun    // 预览字体设置为宋体；
      // 自定义 pdf 导出样式
      @media print {
      }

      // 自定义 prince pdf 导出样式
      &.prince {
      }

      // 自定义 presentation 样式
      .reveal .slides {
        // 修改所有幻灯片
      }

      // 自定义 presentation 样式
      .slides > section:nth-child(1) {
        // 修改 `第 1 个幻灯片`
      }
    }

    .md-sidebar-toc.md-sidebar-toc {
      // 边栏目录样式
    }
    ```
+ `ctrl+shift+p`然后打开`Markdown Preview Enhanced:Open MathJax Config`设置mathjax渲染公式的设置，例如equation environment自动编号的功能。
### 2.2 支持`front-matter`自定义
+ `front-matter`是文件最上方以`---`隔开的区域，用于指定个别文件的变量，例如：
  ```
  ---
  title: Hello World
  date: 2013/7/13 20:46:25
  ---
  ```
+ 常用参数：

  | 参数 | 描述 | 默认值 |
  | :----| :----| :----|
  | `layout`| 布局   |  |
  | `title`| 标题 | 文章的文件名 |
  | `date`| 建立日期 | 文件建立日期 |
  | `updated`| 更新日期 | 文件更新日期 |
  | `comments`| 开启文章评论功能 | true |
  | `tags`| 文章标签 |  |

+ Presentation和Beamer等样式需要首先在这里设置，例如：
  ```
  ---
  presentation:
    width: 800
    height: 600
  ---
  ```
+ puppeteer转pdf等格式也通过此处设置参数：
  ```
  ---
  puppeteer:
    landscape: true
    format: "A4"
    timeout: 3000 # <= 特殊设置，意味着等待（waitFor） 3000 毫秒
  ---
  ```

### 2.3 支持流程图
+ 流程图可以渲染[`mermaid`](http://mermaid-js.github.io/mermaid/#/flowchart "详细用法")语法；
+

### 2.4 代码块渲染
+ 支持多种语言代码块，preview中可以直接渲染代码块运行结果：
  + 不支持stata代码块；
  + 支持python，latex；
  + latex渲染需要安装pdf2svg,下载安装包，配置环境变量；
+ 或者在markdown中直接使用Hydrogen运行代码块；
### 2.5 目录
+ 侧边目录：
  + 转换为html格式时，侧边栏目录通过`Enable Script Excution`开启；
  + html格式，带侧边目录导航，阅读体验较好。
+ 文前目录：
  + `ctrl+shift+p`然后运行`Markdown Preview Enhanced:Create TOC`添加目录；

### 2.6 导出文档
+ 导出为`html`格式
  + 默认KaTeX解析的latex公式，和MathJax不同，将数学公式解析工具设置为MathJax；
  + 使用`Open in Browser`或者`HTML`导出为`html`格式；
+ 导出为`PDF`格式
  + 导出pdf有多种方式
  + 方法一、通过html格式下使用浏览器打印功能保存为pdf格式的方式；
  + 方法二、puppeteer也可以直接保存pdf格式：
      + puppeteer和puppeteer-core的区别：
        + 安装puppeteer时会默认自动下载chromium；
        + 而puppeteer-core不会自动下载chromium，而是使用当前chromium环境；
      + 安装pupperteer：`npm install -g pupperteer`，但是latex公式没有得到渲染；
      + 设置了`Purreteer waitFor Timeout = 3000`以后，latex也得到了完整渲染；
      + 也可以通过`front-matter`进行输出设置：
        ```
        ---
        puppeteer:
          landscape: true
          format: "A4" # A4纸较小，会使得字体很小；
          timeout: 3000 # <= 特殊设置，意味着等待（waitFor）3000 毫秒
        export_on_save: #保存时自动导出；
          puppeteer: true # 保存文件时导出 PDF
          puppeteer: ["pdf", "png"] #保存文件时导出 PDF 和 PNG
          puppeteer: ["png"] # 保存文件时导出 PNG
        ---
        ```
  + 方法三、`PDF(prince)`选项导出为pdf格式：
    + 不能渲染latex公式（KaTeX和MathJax无法工作），并且还需要安装`princexml`环境（不推荐）。

  + 方法四、`pandoc`方法：
    + 此方法导出PDF格式也存在一些问题（不推荐）。


## 三、VS Code中配置Python、R、STATA
### 3.1 配置Python
+ 首先安装Anaconda；
+ 安装Python插件，注意一些命令的区别：
  + 在python终端中运行选中行；
  + 在终端中运行python文件；
  + 以交互模式运行选中行。
### 3.2 配置R
+ 首先安装radian终端：
	+ 交互式R终端，有代码高亮和自动补全，类似于Ipython；
  + 安装：` pip install radian`;
  + 运行：cmd窗口输入`radian`;
+ 安装R插件：
  + 手动在cmd终端中输入`radian`运行后，在终端中运行选中行；

### 3.3 配置STATA
#### 3.3.1 对比VS code、Atom和jupyter下
+ VS Code下配置：
  + 下载rundo.exe等修改相应配置；
  + 下载code-runner插件运行rundo.exe;
  + 代码自动补全，变量搜索不好用，还是sublimetext好用；
+ Atom下配置：
  + 首先配置好jupyter的stata_kernel内核；
  + 然后借助Hydrogen插件运行；
  + 外部命令（marginscontplot）无法加载图片；
+ jupyter下配置：
  + 有两种方法：stata_kernel和IPyStata：
    + IPyStata需要借助于python，数据从python到stata，在stata中运行命令然后返回到python；
    + 而stata_kernel直接控制stata，所以比较快；
    + stata_kernel纯jupyter内核，而IPyStata是python内核中的Jupyter魔术命令；
    + stata_kernel不必在每个单元格开头包含`%%stata`;
    + stata_kernel可以自动补全，`;`作为分割符；
    + stata_kennel可以看到命令运行过程；
    + stata_kernel可以一个单元格创建多个图，而不必命名每个图。
  + [安装](https://kylebarron.dev/stata_kernel/getting_started/)stata_kernel;
