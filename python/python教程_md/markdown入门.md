
# md的语法入门

## 一、基本符号

```* - + >```
> 基本上所有的md标记都是基于这几个符号

## 二、标题

```几个#代表几级标题```

## 三、列表

### 无序列表

+ a
  + g
  + h
  + i
+ b
+ c

```或者 -  * 也行，同一个文档无序列表使用一种符号```

### 有序列表

1. abc
2. bcd
3. cde
5. hbn

### 嵌套列表

+ a 无序列表下一级缩进两个空格
  + g
  + h
  + i

1. abc 有序列表下一级缩进四个空格或tab
    1. abc
    2. bcd
    3. cde
2. bcd
3. cde

## 四、引用说明区域

### 1. 正常形式

> 引用的内容：是一个区块，放什么内容都可以，英文的尖括号；

### 2. 嵌套区块

> 一级引用
>> 二级引用
>>> 三级引用
>>>> 四级引用
>>>>> 五级引用
>>>>>> 六级引用

## 五、代码块

### 1.少量代码

`单行使用，直接包裹起来就行了`

    代码块（左侧有八个不可见的空格）
    或者使用四个空格和tab键也可以表示代码块

### 2.大量代码

```python
import os
import pandas as pd
```

## 六、链接

### 1.行内式

链接的文字放在[]中，链接地址放在随后的()中，链接也可以带title属性，链接地址后面空一格，然后用引号引起来

[百度](https://www.baidu.com "百度一下，你就知道")

`链接地址后面空一格，跟提示性文字`

### 2.参数式

链接的文字放在[]中，链接地址放在随后的:后，链接地址后面空一格，然后用引号引起来

[简书]是一个创作社区,任何人均可以在其上进行创作。用户在简书上面可以方便的创作自己的作品,互相交流。

[简书]: <https://www.jianshu.com> "创作你的创作"

或者:

我经常去的几个网站[GitHub][1]、[知乎][2]以及[简书][3]
[简书][3]是一个不错的[写作社区][]。

[1]:https://github.com "GitHub"
[2]:https://www.zhihu.com "知乎"
[3]:http://www.jianshu.com "简书"
[写作社区]:http://www.jianshu.com

或者:
Markdown 支持以比较简短的自动链接形式来处理网址和电子邮件信箱，只要是用<>;包起来， Markdown 就会自动把它转成链接。一般网址的链接文字就和链接地址一样，例如：

<http://example.com/>
<address@example.com>

## 七、图片

### a.行内式

和链接的形式差不多，图片的名字放在[]中，图片地址放在随后的()中，title属性（图片地址后面空一格，然后用引号引起来）,注意的是[]前要加上!

![my-logo.png](https://upload-images.jianshu.io/upload_images/13623636-6d878e3d3ef63825.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240 "my-logo")

### b.参数式

图片的文字放在[]中，图片地址放在随后的:后，title属性（图片地址后面空一格，然后用引号引起来）,注意引用图片的时候在[]前要加上!

[my-logo.png]: https://upload-images.jianshu.io/upload_images/13623636-6d878e3d3ef63825.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240 "my-logo"
![my-logo.png]
```
//参数定义的其他写法
[my-logo.png]: https://upload-images.jianshu.io/upload_images/13623636-6d878e3d3ef63825.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240 'my-logo'
[my-logo.png]: https://upload-images.jianshu.io/upload_images/13623636-6d878e3d3ef63825.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240 (my-logo)
[my-logo.png]: <https://upload-images.jianshu.io/upload_images/13623636-6d878e3d3ef63825.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240> "my-logo"
```

## 八、分割线

分割线可以由* - _（星号，减号，底线）这3个符号的至少3个符号表示，注意至少要3个，且不需要连续，有空格也可以

---
或者一下都可以，但是一篇文档统一使用一种分割线：

``` 其他格式
- - -
------
***
* * *
******
___
_ _ _
______
```

## 九、其它

### 1、强调字体

一个星号或者是一个下划线包起来，会转换为倾斜，如果是2个，会转换为加粗

*md*
**md**
_md_
__md__

### 2、转义

基本上和js转义一样,\加需要转义的字符

\\
\*
\+
\-
\`
\_

### 3、删除线

用~~把需要显示删除线的字符包裹起来

~~删除~~

## 十、表格

//例子一
|123|234|345|
|:-|:-:|-:|
|abc|bcd|cde|
|abc|bcd|cde|
|abc|bcd|cde|
//例子二
|123|234|345|
|:---|:---:|---:|
|abc|bcd|cde|
|abc|bcd|cde|
|abc|bcd|cde|
//例子三
123|234|345
:-|:-:|-:
abc|bcd|cde
abc|bcd|cde
abc|bcd|cde

上面三个例子的效果一样，由此可得：

1. 表格的格式不一定要对的非常齐，但是为了良好的编程风格，尽量对齐是最好的

2. 分割线后面的冒号表示对齐方式，写在左边表示左对齐，右边为右对齐，两边都写表示居中

## 十一、todo list

近期任务安排:

+ [x] 整理Markdown手册
  + [ ] 改善项目
  + [x] 优化首页显示方式
  + [x] 修复闪退问题
+ [ ] 修复视频卡顿
  + [ ] A3项目修复
  + [x] 修复数值错误

## 十二、时序图

```sequence
participant 客户端 as A
participant 服务端 as B
participant 通行证中心 as C
Note over A:用户输入通行证账号、密码
A->C: 发送账号、密码
Note over C:验证账号、密码
C-->>A:返回token
A->B:发送token
B->C:验证token
C-->>B:验证成功
B-->>A:登陆成功
Note left of A:左边注释
B->B:自交互
Note right of C:右边注释
```

## 十三、流程图

```flow
st=>start: 开始
io=>inputoutput: 验证
op=>operation: 选项
cond=>condition: 是 或 否？
sub=>subroutine: 子程序
e=>end: 结束

st->io->op->cond
cond(yes)->e
cond(no)->sub->io
```

## 十四、甘特图

```
gantt
dateFormat YYYY-MM-DD
title 产品计划表
section 初期阶段
明确需求: 2017-03-01, 10d
section 中期阶段
跟进开发: 2017-03-11, 9d
section 后期阶段
抽查测试: 2017-03-20, 9d
```
