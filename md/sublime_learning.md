[TOC]
# Sublime使用
+ Sublime最轻便，配置stata使用；
+ 常用快捷键（和Vscode一致）：  
+ windows快捷键：

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

+ MAC快捷键和Vscode对应：

|sublime|对应操作|vscode|
|:----|:----|:----|
|`command+d`| 选中相同项 | `ctrl+d `（已修改为F3） | 
|` `|   | ` `| 
|` `|   | ` `| 
|` `|   | ` `| 
|` `|   | ` `| 
|` `|   | ` `| 

## 一、关于Sublime

### 1.1 安装和破解
+ Sublime安装
+ 破解：安装后，先Host防验证工具，然后复制序列号激活；
+ 记得设置`"update_check":false,`不自动更新；

### 1.2 插件安装
+ 常用插件：
    + `Package Control`：包管理插件；
    + `PackageResourceViewer`：查看包文件插件；
    + `A File Icon`：文件类型图标；
    + `Material Theme`：Material主题；
    + `Color Highlighter`：十六进制颜色预览；
    + `RainbowBrackets`：配对括号颜色高亮；
    + `Stata Improved Editor`：Stata插件；
    + `Sync Settings`：Sublime设置同步插件；
+ 几个简易插件的设置：
    + `Color Highlighter`：十六进制颜色预览；
        ```
        "file_extensions": [".css", ".less", ".scss", ".sass", ".styl", ".tmTheme", ".sublime-settings"], //增加.tmTheme相应的扩展名可以高亮显示其中的颜色；
        ``` 
    + `RainbowBrackets`：配对括号颜色高亮；
        ```
        "STATA": { //设置对stata的do文档中括号颜色的提示；
        "bracket_pairs": {
            "{": "}",
            "[": "]",
            "(": ")",
        },

        "extensions": [
            ".do",
        ],

            "ignored_scopes": [
                "comment", "string"
            ]
        },
        ```  
### 1.3 主题设置
+ `Material Theme`主题安装和设置:
    + 安装material主题：
        + `ctrl+shift+p`->`install package`->`Material Theme`
    + 设置Material主题： （Material插件设置）
        + `ctrl+shift+p`->`open resource`->`Material Theme`：可以打开material主题插件包里的各类文件文件；
    + 设置标题栏颜色：
        + 修改白色为系统统一颜色； 
        + `ctrl+shift+p`->`open resource`->`Material Theme`打开`Preference.sublime-settings`文件，这里设置`true`或`false`来简单设置一些外观显示；
        + `"material_theme_titlebar": true,`将标题栏设置为统一颜色；
    + 侧边栏设置：
        + `ctrl+shift+p`->`open resource`->`Material Theme`打开`Material-Theme.sublime-theme`文件， 
        + 搜索`sidebar_label`
        + 添加：`"font.size": 14`设置侧边栏字体大小；
        + `font.face`:字体
    + 标签设置
        + 搜索"tab_height"
    + 状态栏设置
        + 搜索"statusbar"
    + 注释颜色：
        + `ctrl+shift+p`->`open resource`->`Material Theme/schemes/Material-Theme.tmTheme`打开`Material-Theme.tmTheme`：可以修改各类关键字颜色；
        + 搜索`comment`修改颜色为`#0dbc79`;
### 1.4 常用操作
+ 打开多个文件夹：`project`->`Add Folder to Project`
+ 禁止删除和安装插件，插件控制设置：`Prefenence`->`Settings`->`0_package_control_loader`语句；

## 二、配置Stata

### 2.1 安装`StataEditor`插件

### 2.2 插件设置(win10)
+ StataEditor的settings中配置本机stata目录；
+ 注册stata `cmd`窗口输入`StataMP-64.exe /Register`注册，`StataMP-64.exe /Regserver`解除注册；

### 2.3 mac下直接安装`Stata Improved Editor`插件即可；

## 三、配置md
+ mac上不再配置sublime的md，预览不方便，全部改为vscode上；
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
## 五、同步配置
+ 安装`sync settings`插件；
+ 设置中输入一下内容，保存后同步：
```
{
	"access_token": "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",
	"gist_id": "ec59f1c7e82d37271ab74fb1b1216b83",
}
```