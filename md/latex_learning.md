# 优雅的Latex
+ Tex发行自带的编辑器:TeX Live和MiKTeX,都带有TeXworks编辑器;
+ 专为Tex设置的编辑器:TeXmaker,TeXstudio和WinEdt等;
+ 通用文本编辑器:Sublime Text,Atom和VScode等;
+ 先学习TeXworks:
  + TeX Live自带的编辑器,TeX User Group发行跨操作系统平台的编辑器;
  + 几乎所有TeX发行版都带有TeXworks;
  + 简洁,可以将精力集中在TeX学习上.

<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [优雅的Latex](#优雅的latex)
  - [启动TeXworks](#启动texworks)
  - [文件格式及宏包安装](#文件格式及宏包安装)
  - [排版工具](#排版工具)
  - [第一篇文档](#第一篇文档)
  - [实现中英文混排](#实现中英文混排)
  - [宏包](#宏包)
    - [<font color="red">CTeX宏集区别于CTeX套装:</font>](#font-colorredctex宏集区别于ctex套装font)
  - [以UTF8编码保存,使用XeLaTeX编译](#以utf8编码保存使用xelatex编译)
  - [组织你的文章(一本书较大的项目)](#组织你的文章一本书较大的项目)
    - [文档结构复杂,分多个tex文档的情况](#文档结构复杂分多个tex文档的情况)
    - [作者,标题和日期](#作者标题和日期)
  - [章节和段落](#章节和段落)
  - [插入目录](#插入目录)
  - [插入数学公式](#插入数学公式)
  - [上下标](#上下标)
  - [根式与分式](#根式与分式)
  - [运算符](#运算符)
  - [定界符](#定界符)
  - [省略号](#省略号)
  - [矩阵](#矩阵)
  - [多行公式](#多行公式)
  - [公式组](#公式组)
  - [分段函数](#分段函数)
  - [插入图片和表格](#插入图片和表格)
    - [图片](#图片)
  - [表格](#表格)
  - [浮动体](#浮动体)
  - [版面设置](#版面设置)
    - [页边距](#页边距)
    - [页眉页脚](#页眉页脚)
    - [首行缩进](#首行缩进)
    - [行间距](#行间距)
    - [段间距](#段间距)
  - [TeX家族](#tex家族)
    - [TeX-LaTeX](#tex-latex)
    - [pdfTeX-pdfLaTeX](#pdftex-pdflatex)
    - [XeTeX-XeLaTeX](#xetex-xelatex)
    - [LuaTeX](#luatex)
  - [文中代码块语法高亮宏包minted](#文中代码块语法高亮宏包minted)

<!-- /TOC -->

## 启动TeXworks
 + 开始菜单启动;
 + 右下角三个按钮,分别是:
  + 换行符`CRLF`
  + 编码模式
  + 光标位置

## 文件格式及宏包安装
+ `.cls`格式


## 排版工具
+ pdfTeX
+ pdfLaTeX
+ XeTeX
+ XeLaTeX

## 第一篇文档
+ 编辑框中输入以下内容:
```
\documentclass{article}
% 这里是导言区
\begin{document}
Hello,world!
\end{document}
```
+ documentclass表示文档类,调用名为article的文档类;
+ TeX对控制序列的大小写敏感;
+ % 注释标记;
+ 若要使用%号,前面加\%转义;
+ `\begin...\end`成对儿出现,中间内容被称为环境;
+ `document`环境中的内容才会输出到文档;`\end{document}`之后插入的内容是无效的;
+ `\documentclass{article}`和`\begin{document}`之间的部分是导言区,整篇文档的设置区域,会影响整篇文档的格式(页眉页脚,页面大小和章节标题等);

## 实现中英文混排
+ `CJK`宏包虽然支持中文,但应该被摒弃;
+ XeTeX原生支持Unicode,至此需要几个简单的宏包就完成中文支持了;

## 宏包
+ 一系列控制序列的合集,由于太经常使用,人们每次写在导言区太过繁琐,所以将它们打包放在同一个文件中,简称宏包,用`\usepackage{}`来调用宏包;
+ CTeX宏集一次性解决了中文支持,版式和标点等问题,且适配于多种编译方式;
### <font color="red">CTeX宏集区别于CTeX套装:</font>
  + CTeX宏集是一个LaTeX宏的集合,包含文档类`.cls`和宏包`.sty`;
  + 新版CTeX宏集默认能够自动检测用户操作系统,并为之适配字库,用户都不用做任何配置,就能使用CTeX宏集来排版中文;
  + CTeX套装是一个过时的TeX系统;

## 以UTF8编码保存,使用XeLaTeX编译
```
\documentclass[UTF8]{ctexart}
\begin{document}
你好,world!
\end{document}
```

+ 也可以直接使用`XeCJK`宏包来支持中英文混排,但不推荐这样做,再输入以下内容,并使用XeLaTeX编译:

```
\documentclass{article}
\usepackage{xeCJK} %调用xeCJK宏包;
\setCJKmainfont{SimSun} %设置CJK主字体为宋体;
\begin{document}
你好,world!
\end{document}
```
+ `\setCJKmainfont{.}`是定义在`xeCJK`宏包中的控制序列,它可以用来设置CJK主字体;
+ 如果TeX系统提示找不到字体,使用以下命令:
  + 一定要以系统管理员方式打开`CMD`输入:`fc-list :lang=zh-cn > C:\font_zh-cn.txt`
  + C盘根目录下的font_zh-cn.txt就保存了系统全部可用字体,例如:
  `C:/WINDOWS/fonts/STSONG.TTF: STSong,华文宋体:style=Regular`
  + 在`\setCJKmainfont{.}`处填入`华文宋体`或者`STSong`都可以;

## 组织你的文章(一本书较大的项目)
### 文档结构复杂,分多个tex文档的情况
+ 以atom-latex插件为例,可以设置编译命令;
+ 可以设置不同的目录存放相应的tex文件:`..\github_atom\sections`存放各章文档的`.tex`文件,`..\github_atom\images`存放图片文件等;
+ root文件为`main.tex`,编译时要选择它;

### 作者,标题和日期
+ 编译以下文档:
```
\documentclass[UTF8]{ctexart}
\title{我是标题}
\author{作者}
\date{\today}
\begin{document}
\maketitle
你好,world!
\end{document}
```
+ 导言区定义了作者,标题和日期
+ `document`环境中多了一个控制序列`maketitle`,能将导言区的标题,作者和日期按照预定的格式展现出来;

## 章节和段落
+ 保存并编译以下文档:
```
\documentclass[UTF8]{ctexart}
\title{我是标题}
\author{我是作者}
\date{\today}
\begin{document}
\maketitle
\section{你好中国}
中国在东亚地区.
\subsection{hello beijing}
北京是中国的首都.
\subsubsection{hello dongcheng district}
\paragraph{tiananmen square}
is in the center of beijing
\subparagraph{chairman mao}
is in the center of 天安门广场.
\subsection{hello 山东}
\paragraph{山东大学}is one of the best university in 山东.
\end{document}
```
+ 在文档类`article/ctexart`中,定义了五个序列来调整行文组织结构,它们分别是:
  + `\section{.}`
  + `\subsection{.}`
  + `\subsubsection{.}`
  + `\paragraph{.}`
  + `\subparagraph{.}`
+ 在报告类`report/ctexrep`中还有`\chapter{.}`;
+ 在书籍类`book/ctexbook`中还有`\part{.}`;

## 插入目录
+ 在上面文档中找到`maketitle`,在它下面插入控制序列`\tableofcontents`,保存,并使用XeLaTeX编译两次,观察结果:
```
\documentclass[UTF8]{ctexart}
\title{我是标题}
\author{我是作者}
\date{\today}
\begin{document}
\maketitle
\tableofcontents   %插入目录
\section{你好中国}
中国在东亚地区.
\subsection{hello beijing}
北京是中国的首都.
\subsubsection{hello dongcheng district}
\paragraph{tiananmen square}
is in the center of beijing
\subparagraph{chairman mao}
is in the center of 天安门广场.
\subsection{hello 山东}
\paragraph{山东大学}is one of the best university in 山东.
\end{document}
```
+ 试着交换`maketitle`和`\tableofcontents`的顺序看会发生什么:
```
\documentclass[UTF8]{ctexart}
\title{我是标题}
\author{我是作者}
\date{\today}
\begin{document}
\tableofcontents  %目录插到作者,标题和日期前面去了
\maketitle
\section{你好中国}
中国在东亚地区.
中国在东亚地区.
\subsection{hello beijing}
北京是中国的首都.
\subsubsection{hello dongcheng district}
\paragraph{tiananmen square}
is in the center of beijing
\subparagraph{chairman mao}
is in the center of 天安门广场.
\subsection{hello 山东}
\paragraph{山东大学}is one of the best university in 山东.
\end{document}
```
+ 此时目录放到作者,标题和日期前面去了;
+ LaTeX中输入一个空行,输出的只有一个换行,没有空行,因为它将换行当作一个简单的空格处理,如果需要换行另起一段,则需要两个换行(一个空行)来实现.

## 插入数学公式
+ 为了编写数学公式,只需要在导言区加载amsmath宏包:`\usepackage{amsmath}`;
+ LaTeX的数学公式有两种,行内模式`inline`和行间模式`display`;
+ 插入行内公式:后两种略嫌麻烦
  + `$...$`
  + `\(...\)`
  + `\begin{math}...\end{math}`
+ 插入行间公式:不需要编号
  + `\[...\]`
  + `\begin{displaymath}...\end{displaymath}`
  + `\begin{equation*}...\end{equation*}`
+ 如果需要对行间公式编号,则可以使用`equation`环境
```
\begin{equation}
...
\end{equation}
```
+ `$$...$$`也可以插入不带编号的行间公式,但是LaTeX中这样做会改变行文的默认间距,不推荐;

## 上下标
+ 示例代码,依然保存使用XeLaTeX编译X
```
\documentclass{article}
\usepackage{amsmath}
\begin{document}
Einstein 's $E=mc^2$.

  \[E=mc^2.\]

  \begin{equation}
  E=mc^2.
\end{equation}
\end{document}
```
+ 关于公式标点符号,行间公式标点应放在限定符之外,而行间公式则应放在限定符之内.
+ `^`和`_`分别表示上下标,只对其后面的一个字符起作用,要想对一个表达式起作用,应使用`{}`将表达式括起来,例如:
  `\[z = r\cdot e^{2\pi i}. \`

## 根式与分式
+ 根式`\sqrt{.}`
+ 分式`\frac{.}{.}`,例如:
```
\documentclass{article}
\usepackage{amsmath}
\usepackage{xfrac}
\begin{document}
$\sqrt{x}$,$\frac{1}{2}$.

\[ \sqrt{x}, \]

\[ \frac{1}{2}. \]
\[ \dfrac{1}{2}. \]
\[ \tfrac{1}{2}. \]
\[ \sfrac{1}{2}. \]
\[ \cfrac{\cfrac{1}{1+x}}{\cfrac{2}{1+x^2}}. \]
\end{document}
```
+ 如果强制使用行内模式分式显示为行间模式大小,可以使用`\dfrac`,反之可以使用`\tfrac`;
+ 在行内写分式,推荐`xfrac`宏包提供的`\sfrac`的效果;
+ 排版繁分式,推荐使用`\cfrac`

## 运算符

+ 一些小的运算符,可以直接输入;
+ 另一些需要控制序列生成:
`\[ \pm\; \times \; \div\; \cdot\; \cap\; \cup\;`
`\geq\; \leq\; \neq\; \approx \; \equiv \]`
+ 连加,连乘,极限和积分等大型运算符分别用`\sum`,`\prod`,`\lim`和`\int`生成,上下标在公式内被压缩,以适应高亮,可以用`\limits`和`\nolimits`来强制显示地指定是否压缩这些上下标,例如:
```
$ \sum_{i=1}^n i\quad \prod_{i=1}^n $
$ \sum\limits _{i=1}^n i\quad \prod\limits _{i=1}^n $
\[ \lim_{x\to0}x^2 \quad \int_a^b x^2 dx \]
\[ \lim\nolimits _{x\to0}x^2 \quad \int\nolimits_a^b x^2 dx \]
```
+ 多重积分可以使用`\iint`,`\iiint`,`\iiiint`,`\idotsint`等命令输入;
`\[ \iint\quad \iiint\quad \iiiint\quad \idotsint \]`
+ `\quad`表示空格;

## 定界符
+ 各种括号用`()`,`[]`,`{}`和`\langle\rangle`(左右尖括号)等命令表示,大括号常用来输入命令和环境参数,在数学公式中使用它们前面要加`\`
+ `|a|`中左右竖线用`\lvert\rvert`表示;
+ `||a||`中双竖线用`\lVert\rVert`表示;
+ 另外使用`\big`,`\Big`,`\bigg`和`\Bigg`放在括号前面,逐级放大括号;
+ 各种括号配合放大符号使用:
```
\[ (a+b) \]
\[ [(a+b)*c] \]
\[ \{(a+b)*c\} \]
\[ \langle x \rangle \]
\[ \lvert x \rvert \]
\[ \lVert x \rVert \]
\[ \Biggl(\biggl(\Bigl(\bigl((x)\bigr)\Bigr)\biggr)\Biggr) \]
\[ \Biggl[\biggl[\Bigl[\bigl[[x]\bigr]\Bigr]\biggr]\Biggr] \]
\[ \Biggl \{\biggl \{\Bigl\{\bigl\{\{x\}\bigr\}\Bigr\}\biggr\}\Biggr\} \]
\[ \Biggl\langle \biggl\langle \Bigl\langle\bigl\langle\langle x \rangle \bigr\rangle \Bigr\rangle \biggr\rangle \Biggr\rangle \]
\[ \Biggl\lvert \biggl\lvert \Bigl\lvert\bigl\lvert\lvert x \rvert \bigr\rvert \Bigr\rvert \biggr\rvert \Biggr\rvert \]
\[ \Biggl\lVert \biggl\lVert \Bigl\lVert\bigl\lVert\lVert x \rVert \bigr\rVert \Bigr\rVert \biggr\rVert \Biggr\rVert \]
```

## 省略号
+ 常用省略号有以下命令:
```
\dots
\cdots %和 \dots 的纵向位置不同,看是否有上下标;
\vdots %垂直省略号;
\ddots %斜省略号;
\[ x_1,x_2,\dots,x_n\]
\[1,2,\cdots,n\ \]
\[1,2,\vdots,n\ \]
\[1,2,\ddots,n\ \]
```

## 矩阵
+ 矩阵两边各种括号:
```
\[ \begin{pmatrix} a&b\\c&d \end{pmatrix} \]
\[ \begin{bmatrix} a&b\\c&d \end{bmatrix} \]
\[ \begin{Bmatrix} a&b\\c&d \end{Bmatrix} \]
\[ \begin{vmatrix} a&b\\c&d \end{vmatrix} \]
\[ \begin{Vmatrix} a&b\\c&d \end{Vmatrix} \]
\[ \begin{smallmatrix} a&b\\c&d \end{smallmatrix} \]
%pmatrix 小括号
%bmatrix 中括号
%Bmatrix 大括号
%vmatrix 单竖线
%Vmatrix 双竖线
%smallmatrix 行内小矩阵
```

## 多行公式
+ 长公式换行;
+ 几个公式一组;
+ 分段函数;
  + 无需对齐的长公式
  ```
  \begin{multiline}
  x = a+b+c+{} \\
  d+e+f+g
  \end{multiline}
  ```
  + 如果不需要编号,则使用`muitline*`代替;
  + 对齐的公式需要`aligned`次环境来实现,但是必须包含在数学环境之内:
  ```
  \[\begin{aligned}
  x = a+b+c+{} \\
  d+e+f+g
  \end{aligned}\]
  ```

## 公式组
+ 无需对齐的公式组可以使用`gather`环境;
+ 对齐的公式组可以使用`align`环境;
+ 它们都带有编号,如果不需要编号,后面加上星号.
```
\begin{gather}
2x+3y = 10 \\
3x+4y = 14
\end{gather}
\begin{align}
a &= b+c+d \\
d+c &= e+f    % &=按等号对齐;
\end{align}
```
+ 请注意不要使用`eqnarray`环境.

## 分段函数
+ 分段函数使用`cases`次环境来实现,必须包含在数学环境内:
```
\[ y = \begin{cases}
-x+1&,\quad x\leq 0 \\
x^2+3&,\quad x>0
\end{cases} \]
```

## 插入图片和表格
### 图片
+ LaTeX只支持`.eps`格式的图片的说法是错误的;
+ 有多种插入图片的方法,最好用的插入图片方式是`graphicx`宏包提供的`\includegraphics`命令;
+ 同源目录下有`a.jpg`格式的图片,可以使用以下方式插入到文档中:
```
\documentclass{atticle}
\usepackage{graphicx}
\begin{document}
\includegraphics{a.jpg}
\end{document}
```
+ 如果图片太大超出纸张,使用下面的方式控制图片参数:
`\includegraphics[width = .8\textwidth]{a.jpg}`
+ 宽度被缩放到页面的80%;

## 表格
+ `tabular`环境提供了最简单的表格功能;
+ `\hline`表示横线,`|`表示竖线,`&`来分列,`\\`表示换行,`l`,`c`,`r`分别表示居左,居中和居右;
```
\begin{tabular}{|l|c|r|}
\hline
操作系统 & 发行版 & 编辑器 \\
\hline
windows & MikTeX & TeXMakerx \\
\hline
unix/linux & TeTeX & Kile \\
\hline
Mac OS & MacTeX & TeXShop \\
\hline
通用 & TeX Live & TeXworks \\
\hline
\end{tabular}
```

## 浮动体
+ 插图和表格通常需要占据大块空间,所以文字处理软件中通常需要调整它们的位置;
+ `figure`和`table`环境可以自动完成这样的任务,这种自动调整位置的环境称为浮动体`float`;
+ 以`figure`插图为例:
```
\begin{figure}[htbp]
\centering
\includegraphics[width = .8/textwidth]{a.jpg}
\caption{有图有真相}
\label{fig:myphoto}
\end{figure}
```
+ `htbp`选项用来指定插图的理想位置,分别代表`here`,`top`,`bottom`,`float page`;
+ 分别表示这里,页顶,页尾和浮动页(专门放浮动页的单独页面或分栏);
+ `\centering`命令设置插图居中;
+ `\caption`命令设置图标题;
+ LaTeX会自动给浮动体的标题加上编号,`\label`应该放在标题命令之后;

## 版面设置
### 页边距
+ 设置页边距,推荐使用`geometry`宏包,可以搜索查看它的说明文档;
+ 例如设置纸张的长20cm,宽15cm,左右上下边距分别为1,2,3,4cm:
```
\usepackage{geometry}
\geometry{papersize = {20cm,15cm}}
\geometry{left = 1cm,right = 2cm,top = 3cm,bottom = 4cm}
```
+ 以上设置要放在导言区,正文中需使用`\newgeometry`命令.

### 页眉页脚
+ 设置页眉页脚推荐使用`fancyhdr`宏包,搜索查看说明文档;
+ 页眉左边写上姓名,中间写上日期,右边写上电话,页脚中间写上页码,页眉和正文之间有一条0.4pt的分割线,在导言区加上下面几行:
```
\usepackage{fancyhdr}
\pagestyle{fancy}
\lhead{\author}
\chead{\date}
\rhead{17839456755}
\lfoot{}
\cfoot{\thepage}
\rfoot{}
\renewcommand{\headrulewidth}{0.4pt}
\renewcommand{\headwidth}{\textwidth}
\renewcommand{\footrulewidth}{0pt}
```

### 首行缩进
+ CTeX宏集已经处理好了中文首行缩进问题,因此使用CTeX宏集进行中西文混合排版时,不需要关注首行缩进问题;
+ 如果不选择CTeX宏集,则需要额外的设置:
  + 调用`indentfirst`宏包;
  + 设置首行缩进长度`\setlength{\parindent}{2\ccwd}`,其中`\ccwd`是`xeCJK`定义的宏,它表示当前字号中一个中文汉字的宽度;

### 行间距
+ 通过`setspace`宏包提供的命令来设置行间距;
+ 在导言区添加以下代码,可将行间距设为字号的1.5倍:
```
\usepackage{setspace}
\onehalfspacing
```
+ 这种设置方法不太好,`zhlineskip`宏包提供了更好的中西文混排的行距控制能力;

### 段间距
+ 通过修改长度`\parskip`的值来调整段间距,在导言区填入以下内容:
`\addtolength{\parskip}{ .4em}`
+ 增加0.4em,减小的话设置为负数;

## TeX家族
### TeX-LaTeX
+ TeX:高德纳设计的排版引擎使用的文本标记语言:控制命令和文本相结合;
+ LaTeX是利用TeX命令定义了许多新的控制命令,封装成一个可执行文件,这个可执行文件会去解释LaTeX的新定义命令为TeX控制命令,并交由TeX引擎进行排版;
+ 最终进行分页,断行操作的是TeX引擎;
+ LaTeX实际上是一个工具,他将用户按照他的格式编写的文档解释成TeX引擎能够理解的形式并交付给TeX引擎处理,并将结果返回给用户.

### pdfTeX-pdfLaTeX
+ TeX系统生成的是dvi格式,可以使用其它程序将其转换为pdf格式,但不方便;
+ pdfTeX进步的地方就是直接转换为pdf格式输出;
+ pdfLaTeX是将LaTeX格式文档进行解释,将结果交付给pdfTeX引擎处理.

### XeTeX-XeLaTeX
+ XeTeX-XeLaTeX对应于TeX-LaTeX,TeX-LaTeX只支持ASCII字符,无法解决中文编码问题;
+ XeTeX-XeLaTeX支持Unicode编码,不使用CJK也能排版中文;
+ XeTeX-XeLaTeX和pdfTeX-pdfLaTeX关系类似;
+ XeTeX引擎需要使用UTF8编码.

### LuaTeX
+ LuaTeX是一个正在开发完善的TeX引擎;
+ TeX,LaTeX,pdfTeX,pdfLaTeX,XeTeX,XeLaTeX,LuaTeX等引擎都是TeX家族的一部分;
+ CTeX,MiTeX,TeX Live都是发行软件的合集,包括了上述各种引擎的可执行程序;
+ CTeX是建立在MiTeX基础之上的;

#总结
+ TeX,pdfTeX,XeTeX,LuaTeX都是排版引擎,先进程度递增;
+ LaTeX是一种格式,基于TeX格式定义了很多方面使用的控制命令,上述四个引擎都有对应的程序将LaTeX格式解释成引擎能处理的内容;
+ CTeX,MiTeX,TeX Live都是TeX的发行,是许许多多东西的集合.

## 文中代码块语法高亮宏包minted
+ 需要使用`--shell-escape`参数;
+ TeXworks中修改编译参数,加入以上命令,CMD命令:`xelatex --shell-escape xxx.tex`
```
\begin{minted}{c++}
int main() {
    printf("hello, world");
    return 0;
}
\end{minted}
```
