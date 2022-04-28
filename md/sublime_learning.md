[TOC]
# Sublime使用
+ Sublime最轻便，配置stata和md使用；
+ 常用快捷键  

|sublime|对应操作|vscode|
|:----|:----|:----|
|`F3`| 选中相同项 | `ctrl+d `（已修改为F3） | 
|`ctrl+shift+d`（修改为alt+shift+down）| 向下复制行 | `alt+shift+up/down ` |
|`ctrl+alt+up/down`| 向上向下添加光标 | `相同 ` |
|`ctrl+shift+up/down`（修改为alt+up/down）| 向上向下移动行 | `alt+up/down` |
|`ctrl+alt+o`| markdown在html中预览 | `ctrl+shift+m ` |
|`ctrl+shift+enter`| 在上方插入行 | `   ` |
|`ctrl+shift+alt+p`| show scope | `   ` |
|`ctrl+L`| 选中行 | `   ` |
|`ctrl+/`| 注释 | `   ` |
|`ctrl+/`| 取消注释 | `   ` |
|`ctrl+shift+d`| 复制行 | `   ` |
|`ctrl+shift+k`| 删除行 | `   ` |
|`ctrl+f2`| 添加书签 | `   ` |
|`ctrl+shift+f2`| 取消书签 | `   ` |
|`ctrl+shift+e`| 选择行 | `   ` |
|`ctrl+e`| 删除行 | `   ` |

## 一、关于Sublime

### 1.1 安装和破解
+ Sublime安装
+ 破解

### 1.2 插件安装
+ 常用插件
    * Color Highlighter：十六进制颜色代码提示



### 1.3 主题设置
+ 主题安装和设置
    * 安装：
        - `ctrl+shift+p`->`install package`->`material theme`
    * 设置： （Material插件设置）
        - `ctrl+shift+p`->`open resource`->`theme`打开插件设置js文件；
        - 侧边栏设置
            + 搜索"sidebar_label"
            + font_size:大小
            + font_face:字体
        - 标签设置
            + 搜索"tab_height"
        - 状态栏设置
            + 搜索"statusbar"
        - 注释颜色：
            + `ctrl+shift+p`->`open resource`->`Material Theme/schemes/Material-Theme.tmTheme`打开`Material-Theme.tmTheme`；
            + 搜索`comment`修改颜色为`#0dbc79`;
### 1.4 常用操作
+ 打开多个文件夹：`project`->`Add Folder to Project`
+ 禁止删除和安装插件，插件控制设置：`Prefenence`->`Settings`->`0_package_control_loader`语句；
+ 

## 二、配置Stata

### 2.1 安装`StataEditor`插件

### 2.2 插件设置
+ StataEditor的settings中配置本机stata目录；
+ 注册stata `cmd`窗口输入`StataMP-64.exe /Register`注册，`StataMP-64.exe /Regserver`解除注册；


## 三、配置md

### 3.2 markdown editing
+ markdown编辑插件
    * 设置markdown编辑器的格式；
### 3.2 markdown预览插件
+ omnimarkuppreview预览插件
    * 可在html中实时预览，可以导出为html文件
+ html预览：
    * 删除strikeout项
    * 修改127.0.0.1为本机固定IP192.168.0.22，可在局域网其它电脑上打开实现同步预览；
+ 公式渲染：
    * mathjax设置为true；
    * 公式输入：
    
    $$
    y = x^2 
    $$

+ 添加目录：
    * 在设置中添加"toc"项；
    * 编辑时添加`[TOC]`回在预览时自动添加目录。

## 四、Snippet
### 4.1 查看scope
+ 菜单：`Tools`->`Developer`->`Show Scope Name`;
+ 快捷键：`Ctrl+Alt+Shift+P`  

### 4.2 创建snippet
+ 菜单：`Tools`->`Developer`->`New Snippet`;
+ 然后保存到插件文件夹
    * 在`D:\Program Files\Sublime Text 3\Data\Packages\User`新建插件文件夹`snippets`；
    * 将所有新建的snippet文件保存到上面新建的文件夹`snippets`下；
    * 保存格式为`.sublime-snippet`;
    * 或者保存到各自插件文件夹的`snippets`文件夹下；

### 4.3 snippet语法
```
<snippet>
    <content><![CDATA[
import excel using "$1.xls",case(lower) first clear //content标签下是代码段内容；
]]></content>
    <tabTrigger>importexcel</tabTrigger>            //诱发字符；
    <scope>source.stata</scope>                     //起作用的代码scope；
    <description>import data from excel</description>description //代码段的描述；
</snippet>
```

