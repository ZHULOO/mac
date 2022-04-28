# jupyter lab配置
## 一、R内核安装
+ 方法一：R控制台安装：
	* 如果有conda虚拟环境，首先conda activate geo,切换进需要的环境；
	* 然后找到机子上R语言的安装目录并切入`C:\Program Files\R\R-4.1.3\bin`
	* 输入`R`进入R终端，运行以下命令即可：
```
install.packages('IRkernel')
IRkernel::installspec()
```

+ 方法二:Anaconda安装:
```
conda install -c r r-essentials
```

## 二、Stata内核安装
+ 步骤一：CMD命令安装stata_kernel内核：
```
pip install stata_kernel
python -m stata_kernel.install
```
+  步骤二：stata语法高亮:
```
conda install -c conda-forge nodejs -y
jupyter labextension install jupyterlab-stata-highlight #在此之前需要安装node.js.
```
+ 步骤三：stata_kernel更新:
```
pip install stata_kernel --upgrade
python -m stata_kernel.install
```

## 三、一个notebook同时运行R和python
+ 在python下运行R
+ 安装rpy2库

```
pip install rpy2
```

## 四、局域网配置
+ user文件夹下，打开

## 五、切换环境
+ 需要安装`nb_conda_kernels`包：`conda install nb_conda_kernels`;
+ 然后就可以在notebook中选择需要的环境；

## 六、配置快捷键
+ `ctrl+shift+p`-->`Open Keyboard Shortcuts(JSON)`打开`keybindings.json`,插入下面的代码：
```json
    {
        "key": "alt+=",
        "command": "type",
        "args": {
            "text": " -> "
        },
        "when": "editorTextFocus && editorLangId == 'r'"
    },
    {
        "key": "alt+=",
        "command": "type",
        "args": {
            "text": " -> "
        },
        "when": "editorTextFocus && editorLangId == 'rmd'"
    },
```