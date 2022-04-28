### NumPy基本概念:https://www.numpy.org.cn/ ; https://www.runoob.com/numpy/numpy-tutorial.html

'''
1、NumPy 是一个运行速度非常快的数学库，主要用于数组计算，包含：
2、一个强大的N维数组对象 ndarray
3、广播功能函数
4、整合 C/C++/Fortran 代码的工具
5、线性代数、傅里叶变换、随机数生成等功能
6、NumPy 通常与 SciPy（Scientific Python）和 Matplotlib（绘图库）一起使用， 这种组合广泛用于替代 MatLab，是一个强大的科学计算环境，有助于我们通过 Python 学习数据科学或者机器学习。
7、SciPy 是一个开源的 Python 算法库和数学工具包。
8、SciPy 包含的模块有最优化、线性代数、积分、插值、特殊函数、快速傅里叶变换、信号处理和图像处理、常微分方程求解和其他科学与工程中常用的计算。
9、Matplotlib 是 Python 编程语言及其数值数学扩展包 NumPy 的可视化操作界面。它为利用通用的图形用户界面工具包，如 Tkinter, wxPython, Qt 或 GTK+ 向应用程序嵌入式绘图提供了应用程序接口（API）。
10、ndarray的内部结构：
* 一个指向数据（内存或内存映射文件中的一块数据）的指针。
* 数据类型或 dtype，描述在数组中的固定大小值的格子。
*  一个表示数组形状（shape）的元组，表示各维度大小的元组。
* 一个跨度元组（stride），其中的整数指的是为了前进到当前维度下一个元素需要"跨过"的字节数。
'''
# 安装：
import numpy as np
from numpy import *
eye(4)              # 安装成功;
'''
* 创建ndarray对象只需调用array函数即可:
numpy.array(object, dtype = None, copy = True, order = None, subok = False, ndmin = 0)
* 参数说明：
名称	        描述
object	        数组或嵌套的数列
dtype	        数组元素的数据类型，可选
copy	        对象是否需要复制，可选
order	        创建数组的样式，C为行方向，F为列方向，A为任意方向（默认）
subok	        默认返回一个与基类类型一致的数组
ndmin	        指定生成数组的最小维度
'''
# 多于一个维度:
import numpy as np 
a = np.array([[1,  2],  [3,  4]])  
print (a)
# 最小维度:
a = np.array([1, 2, 3, 4, 5]) # 默认ndmin = 1 
print (a)
b = np.array([1, 2, 3, 4, 5],ndmin=2)  
print (b)
print(b[0])
print(b[0][0])
c = np.array([1, 2, 3, 4, 5],ndmin=1)  
print (c)       #相当于b[0]
print (c[0])    #相当于b[0][0]
print (c[0][0]) #出错
# dtype 参数  
import numpy as np 
a = np.array([1,  2,  3], dtype = complex)  
print (a)

# 数据类型对象(dtype)
'''
* 数据类型：
名称	        描述
bool_	        布尔型数据类型（True 或者 False）
int_	        默认的整数类型（类似于 C 语言中的 long，int32 或 int64）
intc	        与 C 的 int 类型一样，一般是 int32 或 int 64
intp	        用于索引的整数类型（类似于 C 的 ssize_t，一般情况下仍然是 int32 或 int64）
int8	        字节（-128 to 127）
int16	        整数（-32768 to 32767）
int32	        整数（-2147483648 to 2147483647）
int64	        整数（-9223372036854775808 to 9223372036854775807）
uint8	        无符号整数（0 to 255）
uint16	        无符号整数（0 to 65535）
uint32	        无符号整数（0 to 4294967295）
uint64	        无符号整数（0 to 18446744073709551615）
float_	        float64 类型的简写
float16	        半精度浮点数，包括：1 个符号位，5 个指数位，10 个尾数位
float32	        单精度浮点数，包括：1 个符号位，8 个指数位，23 个尾数位
float64	        双精度浮点数，包括：1 个符号位，11 个指数位，52 个尾数位
complex_	    complex128 类型的简写，即 128 位复数
complex64	    复数，表示双 32 位浮点数（实数部分和虚数部分）
complex128	    复数，表示双 64 位浮点数（实数部分和虚数部分）

* 数据类型对象 (dtype)
数据类型对象是用来描述与数组对应的内存区域如何使用，这依赖如下几个方面：
数据的类型（整数，浮点数或者 Python 对象）
数据的大小（例如， 整数使用多少个字节存储）
数据的字节顺序（小端法或大端法）
在结构化类型的情况下，字段的名称、每个字段的数据类型和每个字段所取的内存块的部分
如果数据类型是子数组，它的形状和数据类型
字节顺序是通过对数据类型预先设定"<"或">"来决定的。"<"意味着小端法(最小值存储在最小的地址，即低位组放在最前面)。
">"意味着大端法(最重要的字节存储在最小的地址，即高位组放在最前面)。

* dtype 对象是使用以下语法构造的：
numpy.dtype(object, align, copy)
object  - 要转换为的数据类型对象
align   - 如果为 true，填充字段使其类似 C 的结构体。
copy    - 复制 dtype 对象 ，如果为 false，则是对内置数据类型对象的引用
'''
# 实例:
# 标量类型
dt = np.dtype(np.int32)
print(dt)

# int8, int16, int32, int64 四种数据类型可以使用字符串 'i1', 'i2','i4','i8' 代替
dt = np.dtype('i4')
print(dt)

# 字节顺序标注
dt = np.dtype('<i4')
print(dt)
a = np.array([[2,1,3],[4,6,5]],dtype=dt)
print(a)

# 结构化数据类型
dt = np.dtype([('age', np.int8)])  # object = [('age',np.int8)]
print(dt)

dt = np.dtype([('age', np.int8)])               # 首先创建结构化数据类型;
a = np.array([(10,), (20,), (30,)], dtype=dt)   # 将数据类型应用于 ndarray 对象;
print(a)                                        # (10,)元组类型只有一个元素时后面要加逗号;
print(a['age'])                                 # 类型字段名可以用于存取实际的 age 列;

# 下面的示例定义一个结构化数据类型 student，包含字符串字段 name，整数字段 age，及浮点字段 marks，
# 并将这个 dtype 应用到 ndarray 对象。
student = np.dtype([('name', 'S20'), ('age', 'i1'), ('marks', 'f4')])
print(student)
print(type(student))    # <class 'numpy.dtype'>
a = np.array([('abc', 21, 50), ('xyz', 18, 75)], dtype=student)
b = np.array([('abc', 21, 50), ('xyz', 18, 75),('def', 19, 29)], dtype=student)

c = np.array((('abc', 21, 50), ('xyz', 18, 75), ('def', 19, 29)))
d = np.array([('abc', 21, 50), ('xyz', 18, 75),('def', 19, 29)], dtype=student)
c = np.array((('abc', 21, 50), ('xyz', 18, 75),('def', 19, 29)), dtype=student)  # 错误
e = np.array((['abc', 21, 50], ['xyz', 18, 75],['def', 19, 29]), dtype=student)  # 错误:不能取出元组元素生成数组;

print(a)
a['name']
a['age']
a['marks']
'''
每个内建类型都有一个唯一定义它的字符代码，如下：
字符	 对应类型
b	    布尔型
i	    (有符号) 整型
u	    无符号整型 integer
f	    浮点型
c	    复数浮点型
m	    timedelta（时间间隔）
M	    datetime（日期时间）
O	    (Python) 对象
S, a	(byte-)字符串
U	    Unicode
V	    原始数据 (void)
'''
# NumPy 数组属性:
'''
NumPy 数组属性:
1、NumPy 数组的维数称为秩（rank），一维数组的秩为 1，二维数组的秩为 2，以此类推。
2、在 NumPy中，每一个线性的数组称为是一个轴（axis），也就是维度（dimensions）。比如说，二维数组相当于是两个一维数组，
其中第一个一维数组中每个元素又是一个一维数组。所以一维数组就是 NumPy 中的轴（axis），第一个轴相当于是底层数组，第二个轴是底层数组里的数组。而轴的数量——秩，就是数组的维数。
3、很多时候可以声明 axis。axis=0，表示沿着第 0 轴进行操作，即对每一列进行操作；axis=1，表示沿着第1轴进行操作，即对每一行进行操作。
4、NumPy 的数组中比较重要 ndarray 对象属性有：
属性	            说明
ndarray.ndim	    秩，即轴的数量或维度的数量
ndarray.shape	    数组的维度，对于矩阵，n 行 m 列
ndarray.size	    数组元素的总个数，相当于 .shape 中 n*m 的值
ndarray.dtype	    ndarray 对象的元素类型
ndarray.itemsize	ndarray 对象中每个元素的大小，以字节为单位
ndarray.flags	    ndarray 对象的内存信息
ndarray.real	    ndarray元素的实部
ndarray.imag	    ndarray 元素的虚部
ndarray.data	    包含实际数组元素的缓冲区，由于一般通过数组的索引获取元素，所以通常不需要使用这个属性。
'''
# ndarray.ndim 用于返回数组的维数，等于秩。
a = np.arange(24)
a
a.ndim
a.shape

b = a.reshape(2, 3, 4)
b
b.ndim                  # 3维，构成2个3x4矩阵；
b.shape

c = a.reshape(3, 4, 2)
c
c.ndim
c.shape

a = np.arange(32)
a
a.ndim

b = a.reshape(2, 2, 2, 4)
b
b.ndim                  # 4维，2个（2个2x4矩阵）；
b.shape

# ndarray.shape 表示数组的维度，返回一个元组，这个元组的长度(元素的个数)就是维度的数目，即 ndim 属性(秩)。比如，一个二维数组，其维度表示"行数"和"列数"。
# ndarray.shape 也可以用于调整数组大小。
a = np.array([[1, 2, 3], [4, 5, 6]])
a
a.shape
a.shape = (3, 2)
a
# numpy还提供了reshape函数来调整数组的大小：
b = a.reshape(2, 3)
b

# ndarray.itemsize 以字节的形式返回数组中每一个元素的大小。例如，一个元素类型为 float64 的数组 itemsiz 属性值为 8(float64 占用 64 个 bits，每个字节长度为 8，所以 64/8，占用 8 个字节），
# 又如，一个元素类型为 complex32 的数组 item 属性为 4（32/8）。
# 数组的 dtype 为 int8（一个字节）
x = np.array([1, 2, 3, 4, 5], dtype=np.int8)
print(x.itemsize)  # 1，每一个元素占用1个字节；
# 数组的 dtype 现在为 float64（八个字节）
y = np.array([1, 2, 3, 4, 5], dtype=np.float64)  # 每一个元素
print(y.itemsize)  # 8，每一个元素占用8个字节；

# ndarray.flags 返回 ndarray 对象的内存信息，包含以下属性：
'''
属性	            描述
C_CONTIGUOUS (C)	数据是在一个单一的C风格的连续段中
F_CONTIGUOUS (F)	数据是在一个单一的Fortran风格的连续段中
OWNDATA (O)	        数组拥有它所使用的内存或从另一个对象中借用它
WRITEABLE (W)	    数据区域可以被写入，将该值设置为 False，则数据为只读
ALIGNED (A)	        数据和所有元素都适当地对齐到硬件上
UPDATEIFCOPY (U)	这个数组是其它数组的一个副本，当这个数组被释放时，原数组的内容将被更新
'''
x = np.array([1, 2, 3, 4, 5])
print(x.flags)

# NumPy 创建数组
'''
1、ndarray 数组除了可以使用底层 ndarray 构造器来创建外，也可以通过以下几种方式来创建。
2、numpy.empty 方法用来创建一个指定形状（shape）、数据类型（dtype）且未初始化的数组：
3、numpy.empty(shape, dtype = float, order = 'C')
参数说明：
参数	描述
shape	数组形状
dtype	数据类型，可选
order	有"C"和"F"两个选项,分别代表，行优先和列优先，在计算机内存中的存储元素的顺序。
'''
# 下面是一个创建空数组的实例：
x = np.empty([3, 2], dtype=int)
print(x)
'''
numpy.zeros创建指定大小的数组，数组元素以 0 来填充：
numpy.zeros(shape, dtype = float, order = 'C')
参数说明：
参数	描述
shape	数组形状
dtype	数据类型，可选
order	'C' 用于 C 的行数组，或者 'F' 用于 FORTRAN 的列数组
'''
# 默认为浮点数
x = np.zeros(5)
print(x)

# 设置类型为整数
y = np.zeros((5,), dtype=np.int)
print(y)

# 自定义类型
z = np.zeros((3, 2), dtype=[('x', 'i4'), ('y', 'f4')])
print(z)

# numpy.ones
'''
numpy.ones创建指定形状的数组，数组元素以 1 来填充：
numpy.ones(shape, dtype = None, order = 'C')
'''

'''numpy.ones
创建指定形状的数组，数组元素以 1 来填充：
numpy.ones(shape, dtype = None, order = 'C')
参数说明：
参数	描述
shape	数组形状
dtype	数据类型，可选
order	'C' 用于 C 的行数组，或者 'F' 用于 FORTRAN 的列数组
'''

# 默认为浮点数
x = np.ones(5)
print(x)

# 自定义类型
x = np.ones((2, 2), dtype=int)
print(x)

# numpy.asarray
'''
numpy.asarray类似 numpy.array，但 numpy.asarray 只有三个参数，比 numpy.array 少两个。
numpy.asarray(a, dtype = None, order = None)
参数说明：
参数	描述
a	    任意形式的输入参数，可以是，列表, 列表的元组, 元组, 元组的元组, 元组的列表，多维数组
dtype	数据类型，可选
order	可选，有"C"和"F"两个选项,分别代表，行优先和列优先，在计算机内存中的存储元素的顺序
'''
x = [1, 2, 3]
a = np.asarray(x)
print(a)

x = [(1, 2, 3), (4, 5)]
a = np.asarray(x)
print(a)

x = [1, 2, 3]
a = np.asarray(x, dtype=float)
print(a)

# numpy.frombuffer
'''
numpy.frombuffer 用于实现动态数组。
numpy.frombuffer 接受 buffer 输入参数，以流的形式读入转化成 ndarray 对象。

numpy.frombuffer(buffer, dtype = float, count = -1, offset = 0)
注意：buffer 是字符串的时候，Python3 默认 str 是 Unicode 类型，所以要转成 bytestring 在原 str 前加上 b。
参数说明：

参数	描述
buffer	可以是任意对象，会以流的形式读入。
dtype	返回数组的数据类型，可选
count	读取的数据数量，默认为-1，读取所有数据。
offset	读取的起始位置，默认为0。
'''
s = b'Hello World'
a = np.frombuffer(s, dtype='S1')
print(a)

# numpy.fromiter
'''
numpy.fromiter 方法从可迭代对象中建立 ndarray 对象，返回一维数组。
numpy.fromiter(iterable, dtype, count=-1)
参数	        描述
iterable	    可迭代对象
dtype	        返回数组的数据类型
count	        读取的数据数量，默认为-1，读取所有数据
'''
# 使用 range 函数创建列表对象
list = range(5)
it = iter(list)  # 转化为迭代器对象;
# 使用迭代器创建 ndarray
x = np.fromiter(it, dtype=float)
print(x)

# numpy.arange
'''
numpy 包中的使用 arange 函数创建数值范围并返回 ndarray 对象，函数格式如下：
numpy.arange(start, stop, step, dtype)
根据 start 与 stop 指定的范围以及 step 设定的步长，生成一个 ndarray。
参数说明：
参数	描述
start	起始值，默认为0
stop	终止值（不包含）
step	步长，默认为1
dtype	返回ndarray的数据类型，如果没有提供，则会使用输入数据的类型。
'''
x = np.arange(5)
print(x)

x = np.arange(5, dtype=float)
print(x)

x = np.arange(10, 20, 2)
print(x)

# numpy.linspace
'''
numpy.linspace 函数用于创建一个一维数组，数组是一个等差数列构成的，格式如下：

np.linspace(start, stop, num=50, endpoint=True, retstep=False, dtype=None)
参数说明：

参数	    描述
start	    序列的起始值
stop	    序列的终止值，如果endpoint为true，该值包含于数列中
num	        要生成的等步长的样本数量，默认为50
endpoint	该值为 ture 时，数列中包含stop值，反之不包含，默认是True。
retstep	    如果为 True 时，生成的数组中会显示间距，反之不显示。
dtype	    ndarray 的数据类型
'''
a = np.linspace(1, 10, 10)
print(a)

a = np.linspace(1, 1, 10)
print(a)

a = np.linspace(10, 20,  5, endpoint=False)
print(a)
# 输出结果为：
[10. 12. 14. 16. 18.]
# 如果将 endpoint 设为 true，则会包含 20。
a = np.linspace(10, 20,  5, endpoint=True)
print(a)

# 以下实例设置间距。
a = np.linspace(1, 10, 5, retstep=True)
print(a)
# 拓展例子
b = np.linspace(1, 10, 10).reshape([10, 1])
print(b)

# numpy.logspace
'''
numpy.logspace 函数用于创建一个于等比数列。格式如下：
np.logspace(start, stop, num=50, endpoint=True, base=10.0, dtype=None)
base 参数意思是取对数的时候 log 的下标。
参数	    描述
start	    序列的起始值为：base ** start
stop	    序列的终止值为：base ** stop。如果endpoint为true，该值包含于数列中
num	        要生成的等步长的样本数量，默认为50
endpoint	该值为 ture 时，数列中中包含stop值，反之不包含，默认是True。
base	    对数 log 的底数。
dtype	    ndarray 的数据类型
'''
# 默认底数是 10
a = np.logspace(1.0, 2.0, num=10)
print(a)
# 输出结果为：
[10.           12.91549665     16.68100537      21.5443469  27.82559402
 35.93813664   46.41588834     59.94842503      77.42636827    100.]
# 将对数的底数设置为 2 :
a = np.logspace(0, 9, 10, base=2)
print(a)

# NumPy 切片和索引
'''
ndarray对象的内容可以通过索引或切片来访问和修改，与 Python 中 list 的切片操作一样。
ndarray 数组可以基于 0 - n 的下标进行索引，切片对象可以通过内置的 slice 函数，并设置 start, stop 及 step 参数进行，从原数组中切割出一个新数组。
'''
a = np.arange(10)
s = slice(2, 7, 2)   # 从索引2开始到索引7停止，间隔为2
print(a[s])
# 输出结果为：
[2  4  6]
# 以上实例中，我们首先通过 arange() 函数创建 ndarray 对象。 然后，分别设置起始，终止和步长的参数为 2，7 和 2。

# 我们也可以通过冒号分隔切片参数 start:stop:step 来进行切片操作：
a = np.arange(10)
b = a[2:7:2]   # 从索引 2 开始到索引 7 停止，间隔为 2
print(b)
# 输出结果为：
[2  4  6]
# 冒号 : 的解释：如果只放置一个参数，如 [2]，将返回与该索引相对应的单个元素。如果为 [2:]，表示从该索引开始以后的所有项都将被提取。如果使用了两个参数，如 [2:7]，那么则提取两个索引(不包括停止索引)之间的项。

a = np.arange(10)  # [0 1 2 3 4 5 6 7 8 9]
b = a[5]
print(b)
# 输出结果为：
5
a = np.arange(10)
print(a[2:])
# 输出结果为：
[2  3  4  5  6  7  8  9]
a = np.arange(10)  # [0 1 2 3 4 5 6 7 8 9]
print(a[2:5])
# 输出结果为：
[2  3  4]

# 多维数组同样适用上述索引提取方法：
a = np.array([[1, 2, 3], [3, 4, 5], [4, 5, 6]])
print(a)

# 从某个索引处开始切割
print('从数组索引 a[1:] 处开始切割')
print(a[1:])
# 从数组索引 a[1:] 处开始切割
[[3 4 5]
 [4 5 6]]

# 切片还可以包括省略号 …，来使选择元组的长度与数组的维度相同。 如果在行位置使用省略号，它将返回包含行中元素的 ndarray。
a = np.array([[1, 2, 3], [3, 4, 5], [4, 5, 6]])
b = np.array(([1, 2, 3], [3, 4, 5], [5, 6, 7]))
c = np.array(((1, 2, 3), (4, 5, 6), (7, 8, 9)))  # b,c和上面的a时一样的;
print(a[..., 1])   # 第2列元素
print(a[1, ...])   # 第2行元素
print(a[..., 1:])  # 第2列及剩下的所有元素

# NumPy 高级索引
'''
NumPy 比一般的 Python 序列提供更多的索引方式。除了之前看到的用整数和切片的索引外，数组可以由整数数组索引、布尔索引及花式索引。
整数数组索引
以下实例获取数组中(0,0)，(1,1)和(2,0)位置处的元素。
'''
x = np.array([[1, 2], [3, 4], [5, 6]])
y = x[[0, 1, 2], [0, 1, 0]]
print(y)

'''
以下实例获取了 4X3 数组中的四个角的元素。 行索引是 [0,0] 和 [3,3]，而列索引是 [0,2] 和 [0,2]。
'''
x = np.array([[0,  1,  2], [3,  4,  5], [6,  7,  8], [9,  10,  11]])
print('我们的数组是：')
print(x)
print('\n')
rows = np.array([[0, 0], [3, 3]])
cols = np.array([[0, 2], [0, 2]])
y = x[rows, cols]   # 相当于
y1 = x[[[0, 0], [3, 3]], [[0, 2], [0, 2]]]
print('这个数组的四个角元素是：')
print(y)

'''可以借助切片 : 或 … 与索引数组组合。'''
a = np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
b = a[1:3, 1:3]
c = a[1:3, [1, 2]]
d = a[..., 1:]
print(b)
print(c)
print(d)

'''布尔索引:通过布尔运算（如：比较运算符）来获取符合指定条件的元素的数组。'''
x = np.array([[0,  1,  2], [3,  4,  5], [6,  7,  8], [9,  10,  11]])
print('我们的数组是：')
print(x)
print('\n')
# 现在我们会打印出大于 5 的元素
print('大于 5 的元素是：')
print(x[x > 5])  # 输出大于5的元素;

a = np.array([np.nan,  1, 2, np.nan, 3, 4, 5])
print(a[~np.isnan(a)])  # ~是取补运算符,非NaN元素;

a = np.array([1,  2+6j,  5,  3.5+5j])
print(a[np.iscomplex(a)])  # 取出复数元素;

'''花式索引:利用整数数组进行索引。
对于使用一维整型数组作为索引，如果目标是一维数组，那么索引的结果就是对应位置的元素；如果目标是二维数组，那么就是对应下标的行。
花式索引跟切片不一样，它总是将数据复制到新数组中。
'''
# 1.传入顺序索引数组:
x = np.arange(32).reshape((8, 4))
print(x[[4, 2, 1, 7]])  # 输出x二维数组的第5,3,2,8行;
# 2.传入倒序索引数组:
x = np.arange(32).reshape((8, 4))
print(x[[-4, -2, -1, -7]])  # 输出x的倒数第4,2,1,7行;
# 3.传入多个索引数组:
x = np.arange(32).reshape((8, 4))
print(x[np.ix_([1, 5, 7, 2], [0, 3, 1, 2])])  # 输出第2,6,8,3行,按照第1,4,2,3列的顺序;

'''广播(Broadcast):对不同形状(shape)的数组进行数值计算的方式， 对数组的算术运算通常在相应的元素上进行。'''
# 如果两个数组 a 和 b 形状相同，即满足 a.shape == b.shape，那么 a*b 的结果就是 a 与 b 数组对应位相乘。这要求维数相同，且各维度的长度相同。
a = np.array([1, 2, 3, 4])
b = np.array([10, 20, 30, 40])
c = a * b
print(c)
# 当运算中的 2 个数组的形状不同时，numpy 将自动触发广播机制。
a = np.array([[0, 0, 0],
              [10, 10, 10],
              [20, 20, 20],
              [30, 30, 30]])
b = np.array([1, 2, 3])
print(a + b)

a = np.array([[0, 0, 0],
              [10, 10, 10],
              [20, 20, 20],
              [30, 30, 30]])
b = np.array([1, 2, 3])
bb = np.tile(b, (4, 1))  # b按行复制四次;
bbb = np.tile(b, (1, 4))   # b按列复制四次;
bbbb = np.tile(b, (2, 3))  # b按行复制两次,按列复制三次;
print(a + bb)

'''迭代数组:NumPy 迭代器对象 numpy.nditer 提供了一种灵活访问一个或者多个数组元素的方式。
迭代器最基本的任务的可以完成对数组元素的访问。'''
a = np.arange(6).reshape(2, 3)
print('原始数组是：')
print(a)
print('\n')
print('迭代输出元素：')
for x in np.nditer(a):
    print(x, end=", ")
print('\n')

b = np.nditer(a)
next(b)

c = np.nditer(a.T)
next(c)  # a和上面a.T的遍历顺序是一样的,它们在内存中的存储顺序是一样的;
# 可以通过以下方式来控制遍历顺序:
d = np.nditer(a, order='F')  # Fortran order,列序优先;
next(d)
e = np.nditer(a, order='C')  # C  order,行序优先;
next(e)

'''修改数组中元素的值:可选参数 op_flags。 默认情况下，nditer 将视待迭代遍历的数组为只读对象（read-only），为了在遍历数组的同时，实现对数组元素值得修改，必须指定 read-write 或者 write-only 的模式。'''
a = np.arange(0, 60, 5)
a = a.reshape(3, 4)
print('原始数组是：')
print(a)
print('\n')
for x in np.nditer(a, op_flags=['readwrite']):
    x[...] = 2*x
print('修改后的数组是：')
print(a)
# 使用外部循环
# nditer类的构造器拥有flags参数，它可以接受下列值：
参数	         描述
c_index	        可以跟踪 C 顺序的索引
f_index	        可以跟踪 Fortran 顺序的索引
multi-index	    每次迭代可以跟踪一种索引类型
external_loop	给出的值是具有多个值的一维数组，而不是零维数组

a = np.arange(0, 60, 5)
a = a.reshape(3, 4)
print('原始数组是：')
print(a)
print('\n')
print('修改后的数组是：')
for x in np.nditer(a, flags=['external_loop'], order='F'):
    print(x, end=", ")
for x in np.nditer(a, flags=['c_index'], order='F'):
    print(x, end=", ")
for x in np.nditer(a, flags=['f_index'], order='F'):
    print(x, end=", ")
for x in np.nditer(a, flags=['multi_index'], order='F'):
    print(x, end=", ")

'''广播迭代:如果两个数组是可广播的，nditer 组合对象能够同时迭代它们。 假设数组 a 的维度为 3X4，数组 b 的维度为 1X4 ，则使用以下迭代器（数组 b 被广播到 a 的大小）。'''
a = np.arange(0, 60, 5)
a = a.reshape(3, 4)
print('第一个数组为：')
print(a)
print('\n')
print('第二个数组为：')
b = np.array([1,  2,  3,  4], dtype=int)
print(b)
print('\n')
print('修改后的数组为：')
for x, y in np.nditer([a, b]):
    print("%d:%d" % (x, y), end=", ")

'''Numpy数组操作:'''
'''修改数组形状的函数:'''
函数	    描述
reshape	    不改变数据的条件下修改形状
flat	    数组元素迭代器
flatten	    返回一份数组拷贝，对拷贝所做的修改不会影响原始数组
ravel	    返回展开数组
# reshape函数:
# 可以在不改变数据的条件下修改形状，格式如下： numpy.reshape(arr, newshape, order='C')
arr：要修改形状的数组
newshape：整数或者整数数组，新的形状应当兼容原有形状
order：'C' - - 按行，'F' - - 按列，'A' - - 原顺序，'k' - - 元素在内存中的出现顺序。
a = np.arange(8)
print(a)
b = a.reshape(4, 2)
print(b)

# flat函数:
# 对数组的每个元素进行处理;
a = np.arange(9).reshape(3, 3)
for i in a:
    print(i)  # 此时是按行迭代;
for i in a.flat:
    print(i)  # 使用flat函数,按元素迭代;

# flatten函数:
ndarray.flatten(order='C')
# order：'C' -- 按行，'F' -- 按列，'A' -- 原顺序，'K' -- 元素在内存中的出现顺序。
a = np.arange(8).reshape(2, 4)
print(a)
print(a.flatten())
print(a.flatten())             # 默认按行;
print(a.flatten(order='F'))  # 按列展开;

# ravel函数:
numpy.ravel(a, order='C')
# order：'C' -- 按行，'F' -- 按列，'A' -- 原顺序，'K' -- 元素在内存中的出现顺序。
a = np.arange(8).reshape(2, 4)
print(a)
print(a.ravel())            # 默认按行展开;
print(a.ravel(order='F'))  # 按列展开;

# 反转数组:
函数	        描述
transpose	    对换数组的维度
ndarray.T	    和 self.transpose() 相同
rollaxis	    向后滚动指定的轴
swapaxes	    对换数组的两个轴
# transpose维度对换函数:
numpy.transpose(arr, axes)
参数说明:
arr：要操作的数组
axes：整数列表，对应维度，通常所有维度都会对换
# 实例:
a = np.arange(12).reshape(3, 4)
print(a)
b = np.transpose(a)
print(b)
c = a.T  # 和transpose功能类似
print(c)

# rollaxis函数:
numpy.rollaxis(arr, axis, start)
参数说明：滚轴操作详见:
https: // www.cnblogs.com/jerryspace/p/10023851.html
http: // www.bubuko.com/infodetail-2896886.html
https: // blog.csdn.net/qq_40720983/article/details/82767392
https: // blog.csdn.net/Cowry5/article/details/80188056
arr：数组
axis：要向后滚动的轴，其它轴的相对位置不会改变
start：默认为零，表示完整的滚动。会滚动到特定位置。
a = np.arange(8).reshape(2, 2, 2)
print(a)
print(np.rollaxis(a, 2))  # 相当于rollaxis(a,2,0) start默认为0
print(np.rollaxis(a, 2, 1))
a = np.ones((3, 4, 5, 6))
a.shape
np.rollaxis(a, 3, 1).shape
np.rollaxis(a, 2).shape
np.rollaxis(a, 1, 4).shape

# swapaxes 函数:交换数组的两个轴
numpy.swapaxes(arr, axis1, axis2)
arr：输入的数组
axis1：对应第一个轴的整数
axis2：对应第二个轴的整数
a = np.arange(8).reshape(2, 2, 2)
print(a)
print(np.swapaxes(a, 2, 0))

'''修改数组维度'''
维度	        描述
broadcast	    产生模仿广播的对象
broadcast_to	将数组广播到新形状
expand_dims	    扩展数组的形状
squeeze	        从数组的形状中删除一维条目
# numpy.broadcast 用于模仿广播的对象，它返回一个对象，该对象封装了将一个数组广播到另一个数组的结果。该函数使用两个数组作为输入参数，
x = np.array([[1], [2], [3]])
y = np.array([4, 5, 6])
b = np.broadcast(x, y)
for i in b:
    print(i)
r, c = b.iters
print(next(r), next(c))

print(b.shape)

b = np.broadcast(x, y)
c = np.empty(b.shape)
print(c.shape)
c.flat = [u + v for (u, v) in b]

print(x+y)

# numpy.broadcast_to 函数将数组广播到新形状。它在原始数组上返回只读视图。 它通常不连续。 如果新形状不符合 NumPy 的广播规则，该函数可能会抛出ValueError。
numpy.broadcast_to(array, shape, subok)
a = np.arange(6).reshape(2, 3)
print(a)
print(np.broadcast_to(a, (2, 2, 3)))

# numpy.expand_dims 函数通过在指定位置插入新的轴来扩展数组形状，函数格式如下:
numpy.expand_dims(arr, axis)
参数说明：
arr：输入数组
axis：新轴插入的位置
x = np.array(([1, 2], [3, 4]))
print(x)
y = np.expand_dims(x, axis=0)
print(y)
x.shape
y.shape
x[0]
y[0]

# numpy.squeeze 函数从给定数组的形状中删除一维的条目，函数格式如下：
numpy.squeeze(arr, axis)
参数说明：
arr：输入数组
axis：整数或整数元组，用于选择形状中一维条目的子集
x = np.arange(9).reshape(1, 3, 3)
print(x)
y = np.squeeze(x)
print(y)
x.shape
y.shape
x[0]
y[0]

'''连接数组'''
函数	    描述
concatenate	连接沿现有轴的数组序列
stack	    沿着新的轴加入一系列数组。
hstack	    水平堆叠序列中的数组（列方向）
vstack	    竖直堆叠序列中的数组（行方向）
# numpy.concatenate 函数用于沿指定轴连接相同形状的两个或多个数组，格式如下：
numpy.concatenate((a1, a2, ...), axis)
参数说明：
a1, a2, ...：相同类型的数组
axis：沿着它连接数组的轴，默认为 0
a = np.array([[1, 2], [3, 4]])
b = np.array([[5, 6], [7, 8]])
print(np.concatenate((a, b)))          # 默认延0轴连接;
print(np.concatenate((a, b), axis=1))  # 延1轴连接;

# numpy.stack 函数用于沿新轴连接数组序列，格式如下：
numpy.stack(arrays, axis)
参数说明：
arrays相同形状的数组序列
axis：返回数组中的轴，输入数组沿着它来堆叠
a = np.array([[1, 2], [3, 4]])
b = np.array([[5, 6], [7, 8]])
print(np.stack((a, b), 0))
print(np.stack((a, b), 1))

# numpy.hstack 是 numpy.stack 函数的变体，它通过水平堆叠来生成数组。
a = np.array([[1, 2], [3, 4]])
b = np.array([[5, 6], [7, 8]])
c = np.hstack((a, b))
print(c)

# numpy.vstack 是 numpy.stack 函数的变体，它通过垂直堆叠来生成数组。
a = np.array([[1, 2], [3, 4]])
b = np.array([[5, 6], [7, 8]])
c = np.vstack((a, b))
print(c)

'''分割数组'''
函数	数组及操作
split	将一个数组分割为多个子数组
hsplit	将一个数组水平分割为多个子数组（按列）
vsplit	将一个数组垂直分割为多个子数组（按行）
# numpy.split 函数沿特定的轴将数组分割为子数组，格式如下：
numpy.split(ary, indices_or_sections, axis)
参数说明：
ary：被分割的数组
indices_or_sections：如果是一个整数，就用该数平均切分，如果是一个数组，为沿轴切分的位置（左开右闭）
axis：沿着哪个维度进行切向，默认为0，横向切分。为1时，纵向切分
a = np.arange(9)
b = np.split(a, 3)
print(b)
b = np.split(a, [4, 7])  # 在第4和第7的位置切割;
print(b)

# numpy.hsplit 函数用于水平分割数组，通过指定要返回的相同形状的数组数量来拆分原数组。
np.random.random((2, 6))  # 生成2行6列的二维随机数组;
harr = np.floor(10 * np.random.random((2, 6)))
print(harr)
print(np.hsplit(harr, 3))  # 水平分割为3个数组;

# numpy.vsplit 沿着垂直轴分割，其分割方式与hsplit用法相同。
a = np.arange(16).reshape(4, 4)
print(a)
b = np.vsplit(a, 2)
print(b)

'''数组元素的添加和删除'''
函数	    元素及描述
resize	    返回指定形状的新数组
append	    将值添加到数组末尾
insert	    沿指定轴将值插入到指定下标之前
delete	    删掉某个轴的子数组，并返回删除后的新数组
unique	    查找数组内的唯一元素
# numpy.resize 函数返回指定大小的新数组。如果新数组大小大于原始大小，则包含原始数组中的元素的副本。
numpy.resize(arr, shape)
参数说明：
arr：要修改大小的数组
shape：返回数组的新形状
a = np.array([[1, 2, 3], [4, 5, 6]])
print(a)
print(a.shape)
b = np.resize(a, (3, 2))
print(b)
print(b.shape)
b = np.resize(a, (3, 3))
print(b)

# numpy.append 函数在数组的末尾添加值。 追加操作会分配整个数组，并把原来的数组复制到新数组中。 此外，输入数组的维度必须匹配否则将生成ValueError。
append 函数返回的始终是一个一维数组。
numpy.append(arr, values, axis=None)
参数说明：
arr：输入数组
values：要向arr添加的值，需要和arr形状相同（除了要添加的轴）
axis：默认为 None。当axis无定义时，是横向加成，返回总是为一维数组！当axis有定义的时候，分别为0和1的时候。当axis = 0，数组是加在下边（列数要相同）。当axis为1时，数组是加在右边（行数要相同）。
a = np.array([[1, 2, 3], [4, 5, 6]])
print(a)
print(np.append(a, [7, 8, 9]))  # 此时横向加成,返回一维数组;
print(np.append(a, [[7, 8, 9]], axis=0))  # 纵向加成;列数一定要相同,3列;
print(np.append(a, [[5, 5, 5], [7, 8, 9]], axis=1))  # 横向加成,行数一定要相同,2行;

# numpy.insert 函数在给定索引之前，沿给定轴在输入数组中插入值。
如果值的类型转换为要插入，则它与输入数组不同。 插入没有原地的，函数会返回一个新数组。 此外，如果未提供轴，则输入数组会被展开。
numpy.insert(arr, obj, values, axis)
参数说明：
arr：输入数组
obj：在其之前插入值的索引
values：要插入的值
axis：沿着它插入的轴，如果未提供，则输入数组会被展开
a = np.array([[1, 2], [3, 4], [5, 6]])
print(a)
print(np.insert(a, 3, [11, 12]))  # 未提供轴,数组被展开为一维数组
print(np.insert(a, 1, [11], axis=0))
print(np.insert(a, 1, 11, axis=1))

# numpy.delete 函数返回从输入数组中删除指定子数组的新数组。 与 insert() 函数的情况一样，如果未提供轴参数，则输入数组将展开。
Numpy.delete(arr, obj, axis)
参数说明：
arr：输入数组
obj：可以被切片，整数或者整数数组，表明要从输入数组删除的子数组
axis：沿着它删除给定子数组的轴，如果未提供，则输入数组会被展开
a = np.arange(12).reshape(3, 4)
print(a)
print(np.delete(a, 5))  # 没有指定轴参数,数组被展开为一维,然后删除第6个值;
print(np.delete(a, 1, axis=1))
a = np.array([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
print(np.delete(a, np.s_[::2]))

# numpy.unique 函数用于去除数组中的重复元素。
numpy.unique(arr, return_index, return_inverse, return_counts)
arr：输入数组，如果不是一维数组则会展开
return_index：如果为true，返回新列表元素在旧列表中的位置（下标），并以列表形式储
return_inverse：如果为true，返回旧列表元素在新列表中的位置（下标），并以列表形式储
return_counts：如果为true，返回去重数组中的元素在原数组中的出现次数
a = np.array([5, 2, 6, 2, 7, 5, 6, 8, 2, 9])
print(a)
u = np.unique(a)
print(u)
u, indices = np.unique(a, return_index=True)
print(indices)  # 去重后的数值在元数组中的索引;
print(a)
u, indices = np.unique(a, return_inverse=True)
print(u)  # 去重后的数组;
print(indices)  # 返回旧数组元素在新数组中的位置;
print(u[indices])
u, indices = np.unique(a, return_counts=True)
print(u)
print(indices)  # 返回数组中元素出现的次数;

'''位运算'''

'''字符串函数'''
函数	    描述
add()	        对两个数组的逐个字符串元素进行连接
multiply()	    返回按元素多重连接后的字符串
center()	    居中字符串
capitalize()	将字符串第一个字母转换为大写
title()	        将字符串的每个单词的第一个字母转换为大写
lower()	        数组元素转换为小写
upper()	        数组元素转换为大写
split()	        指定分隔符对字符串进行分割，并返回数组列表
splitlines()	返回元素中的行列表，以换行符分割
strip()	        移除元素开头或者结尾处的特定字符
join()	        通过指定分隔符来连接数组中的元素
replace()	    使用新字符串替换字符串中的所有子字符串
decode()	    数组元素依次调用str.decode
encode()	    数组元素依次调用str.encode
# numpy.char.add() 函数依次对两个数组的元素进行字符串连接。
print(np.char.add(['hello'], ['xyz']))
print(np.char.add(['hello', 'hi'], ['abc', 'xyz']))

# numpy.char.multiply() 函数执行多重连接。
print(np.char.multiply('Runoob ', 4))  # 重复四次;

# numpy.char.center() 函数用于将字符串居中，并使用指定字符在左侧和右侧进行填充。
np.char.center(str, width, fillchar) ：
# str: 字符串，width: 长度，fillchar: 填充字符
print(np.char.center('Runoob', 20, fillchar='*'))

# numpy.char.capitalize() 函数将字符串的第一个字母转换为大写：
print(np.char.capitalize('runoob'))

# numpy.char.title() 函数将字符串的每个单词的第一个字母转换为大写：
print(np.char.title('i like runoob'))

# numpy.char.lower() 函数对数组的每个元素转换为小写。它对每个元素调用 str.lower。
print(np.char.lower(['RUNOOB', 'GOOGLE']))

# numpy.char.upper() 函数对数组的每个元素转换为大写。它对每个元素调用 str.upper。
print(np.char.upper(['runoob', 'google']))

# numpy.char.split() 通过指定分隔符对字符串进行分割，并返回数组。默认情况下，分隔符为空格。
print(np.char.split('www.runoob.com', sep='.'))

# numpy.char.splitlines() 函数以换行符作为分隔符来分割字符串，并返回数组。
print(np.char.splitlines('i\nlike runoob?'))
print(np.char.splitlines('i\rlike runoob?'))  # \n，\r，\r\n 都可用作换行符。

# numpy.char.strip() 函数用于移除开头或结尾处的特定字符。
print(np.char.strip(['arunooba', 'admin', 'java'], 'a'))

# numpy.char.join() 函数通过指定分隔符来连接数组中的元素或字符串;
# 操作字符串
print(np.char.join(':', 'runoob'))
# 指定多个分隔符操作数组元素
print(np.char.join([':', '-'], ['runoob', 'google']))

# numpy.char.replace() 函数使用新字符串替换字符串中的所有子字符串。
print(np.char.replace('i like runoob', 'oo', 'cc'))

# numpy.char.encode() 函数对数组中的每个元素调用 str.encode 函数。 默认编码是 utf-8，可以使用标准 Python 库中的编解码器。
a = np.char.encode('runoob', 'cp500')
print(a)

# numpy.char.decode() 函数对编码的元素进行 str.decode() 解码。
a = np.char.encode('runoob', 'cp500')
print(a)
print(np.char.decode(a, 'cp500'))

'''数学函数'''
# 三角函数sin,cos,tan.
a = np.array([0, 30, 45, 60, 90])
print(np.sin(a*np.pi/180))
print(np.cos(a*np.pi/180))
print(np.tan(a*np.pi/180))
# arcsin，arccos，和 arctan 函数返回给定角度的 sin，cos 和 tan 的反三角函数。这些函数的结果可以通过 numpy.degrees() 函数将弧度转换为角度。
a = np.array([0, 30, 45, 60, 90])
b = a*np.pi/180
sin = np.sin(a*np.pi/180)
print(sin)
inv = np.arcsin(sin)
print(inv)
deg = np.degrees(inv)
print(deg)

# 四舍五入函数:
numpy.around() 函数返回指定数字的四舍五入值。
numpy.around(a, decimals)
参数说明：
a: 数组
decimals: 舍入的小数位数。 默认值为0。 如果为负，整数将四舍五入到小数点左侧的位置
a = np.array([1.0, 5.55,  123,  0.567,  25.532])
print(a)
print(np.around(a))
print(np.around(a, decimals=1))
print(np.around(a, decimals=-1))

# numpy.floor() 返回小于或者等于指定表达式的最大整数，即向下取整。
a = np.array([-1.7,  1.5,  -0.2,  0.6,  10])
print(a)
print(np.floor(a))

# numpy.ceil() 返回大于或者等于指定表达式的最小整数，即向上取整。
a = np.array([-1.7,  1.5,  -0.2,  0.6,  10])
print(a)
print(np.ceil(a))

# 算术函数:
# NumPy 算术函数包含简单的加减乘除: add()，subtract()，multiply() 和 divide()。需要注意的是数组必须具有相同的形状或符合数组广播规则。
a = np.arange(9, dtype=np.float_).reshape(3, 3)
print(a)
b = np.array([10, 10, 10])
print(b)
print(np.add(a, b))
print(np.subtract(a, b))
print(np.multiply(a, b))
print(np.divide(a, b))

# numpy.reciprocal() 函数返回参数逐元素的倒数。如 1/4 倒数为 4/1。
a = np.array([0.25,  1.33,  1,  100])
print(a)
print(np.reciprocal(a))

# numpy.power() 函数将第一个输入数组中的元素作为底数，计算它与第二个输入数组中相应元素的幂。
a = np.array([10, 100, 1000])
print(a)
print(np.power(a, 2))
b = np.array([1, 2, 3])
print(np.power(a, b))

# numpy.mod() 计算输入数组中相应元素的相除后的余数。 函数 numpy.remainder() 也产生相同的结果。
a = np.array([10, 20, 30])
b = np.array([3, 5, 7])
print(np.mod(a, b))
print(np.remainder(a, b))

# 统计函数:
# numpy.amin() 用于计算数组中的元素沿指定轴的最小值。
# numpy.amax() 用于计算数组中的元素沿指定轴的最大值。
a = np.array([[3, 7, 5], [8, 4, 3], [2, 4, 9]])
print(a)
print(np.amin(a, 1))  # 按行;
print(np.amin(a, 0))  # 按列;
print(np.amax(a))   # 所有元素的最大值;
print(np.amax(a, axis=0))  # 按列最大值;

# numpy.ptp()函数计算数组中元素最大值与最小值的差（最大值 - 最小值）。
a = np.array([[3, 7, 5], [8, 4, 3], [2, 4, 9]])
print(a)
print(np.ptp(a))
print(np.ptp(a, axis=1))  # 按行的最大值减最小值;
print(np.ptp(a, axis=0))  # 按列的最大值减最小值;

# numpy.percentile()
# 百分位数是统计中使用的度量，表示小于这个值的观察值的百分比。 函数numpy.percentile()接受以下参数。
numpy.percentile(a, q, axis)
参数说明：
a: 输入数组
q: 要计算的百分位数，在 0 ~ 100 之间
axis: 沿着它计算百分位数的轴
a = np.array([[10, 7, 4], [3, 2, 1]])
print(a)
# 50% 的分位数，就是 a 里排序之后的中位数
print(np.percentile(a, 50))
# axis 为 0，在纵列上求
print(np.percentile(a, 50, axis=0))
# axis 为 1，在横行上求
print(np.percentile(a, 50, axis=1))
# 保持维度不变,依然按行显示各行50%分位数
print(np.percentile(a, 50, axis=1, keepdims=True))

# numpy.median() 函数用于计算数组 a 中元素的中位数（中值）
import numpy as np  
a = np.array([[30,65,70],[80,95,10],[50,90,60]])  
print (a)
print (np.median(a))
print (np.median(a, axis =  0)) # 按列方向求中位数
print (np.median(a, axis =  1)) # 按行方向求中位数

# numpy.mean() 函数返回数组中元素的算术平均值。 如果提供了轴，则沿其计算。算术平均值是沿轴的元素的总和除以元素的数量。
# numpy.average() 函数根据在另一个数组中给出的各自的权重计算数组中元素的加权平均值。
# 该函数可以接受一个轴参数。 如果没有指定轴，则数组会被展开。
a = np.array([1,2,3,4])
wts = np.array([4,3,2,1])
print (np.average(a,weights = wts))
a = np.arange(6).reshape(3,2)
print (a)
wt = np.array([3,5])
print (np.average(a, axis =  1, weights = wt))
print (np.average(a, axis =  1, weights = wt, returned =  True))

# 方差和标准差:
print (np.std([1,2,3,4]))
print (np.var([1,2,3,4]))

# 排序
numpy.sort(a, axis, kind, order)
参数说明：
a: 要排序的数组
axis: 沿着它排序数组的轴，如果没有数组会被展开，沿着最后的轴排序， axis=0 按列排序，axis=1 按行排序
kind: 默认为'quicksort'（快速排序）
order: 如果数组包含字段，则是要排序的字段
import numpy as np   
a = np.array([[3,7],[9,1]])  
print (a)
print (np.sort(a))
print (np.sort(a, axis =  0))
dt = np.dtype([('name',  'S10'),('age',  int)]) 
a = np.array([("raju",21),("anil",25),("ravi",  17),  ("amar",27)], dtype = dt)  
print (a)
print (np.sort(a, order =  'name'))

# numpy.argsort() 函数返回的是数组值从小到大的索引值。
x = np.array([3,  1,  2])
y = np.argsort(x)
print (y)    # [1,2,0] x元素从小打到为1 2 3,对应的索引为1 2 0;
print (x[y]) # 相当于对x的元素从小到大排序;

# numpy.lexsort() 用于对多个序列进行排序。把它想象成对电子表格进行排序，每一列代表一个序列，排序时优先照顾靠后的列。
nm =  ('raju','anil','ravi','amar') 
dv =  ('f.y.',  's.y.',  's.y.',  'f.y.') 
ind = np.lexsort((dv,nm)) # 先按照后边的nm排序, 排序的结果为3 1 0 2;

# 集中函数:
msort(a)	
# 数组按第一个轴排序，返回排序后的数组副本。np.msort(a) 相等于 np.sort(a, axis=0)。
sort_complex(a)	
# 对复数按照先实部后虚部的顺序进行排序。
np.sort_complex([5, 3, 6, 2, 1])
np.sort_complex([1 + 2j, 2 - 1j, 3 - 2j, 3 - 3j, 3 + 5j])

partition(a, kth[, axis, kind, order])	
# 指定一个数，对数组进行分区
a = np.array([3, 4, 2, 1])
np.partition(a, 3)  # 将数组 a 中所有元素（包括重复元素）从小到大排列，3 表示的是排序数组索引为 3 的数字，比该数字小的排在该数字前面，比该数字大的排在该数字的后面:array([2, 1, 3, 4])
np.partition(a, (1, 3)) # 小于 1 的在前面，大于 3 的在后面，1和3之间的在中间:array([1, 2, 3, 4])

argpartition(a, kth[, axis, kind, order])
# 可以通过关键字 kind 指定算法沿着指定轴对数组进行分区
arr = np.array([46, 57, 23, 39, 1, 10, 0, 120])
arr[np.argpartition(arr, 2)[2]] # 数组的第 3 小（index=2）的值
arr[np.argpartition(arr, -2)[-2]] # 第 2 大（index=-2）的值
arr[np.argpartition(arr, [2,3])[2]]
arr[np.argpartition(arr, [2,3])[3]] # 用 [2,3] 同时将第 3 和第 4 小的排序好，然后可以分别通过下标 [2] 和 [3] 取得。

# numpy.argmax() 和 numpy.argmin()函数分别沿给定轴返回最大和最小元素的索引。
import numpy as np  
a = np.array([[30,40,70],[80,20,10],[50,90,60]]) 
print (a)
print (np.argmax(a))
print (a.flatten())
maxindex = np.argmax(a, axis =  0)  
print (maxindex)
maxindex = np.argmax(a, axis =  1)  
print (maxindex)

# numpy.nonzero() 函数返回输入数组中非零元素的索引。
a = np.array([[30,40,0],[0,20,10],[50,0,60]])
print(a)
print (np.nonzero (a))

# numpy.where() 函数返回输入数组中满足给定条件的元素的索引。
x = np.arange(9.).reshape(3,  3)
y = np.where(x >  3)  # 获取大于3的数的索引;
print (y)
print (x[y]) # 可以返回这些大于3的数;

# numpy.extract() 函数根据某个条件从数组中抽取元素，返回满条件的元素。
x = np.arange(9.).reshape(3,  3)
print (x)
condition = np.mod(x,2)  ==  0  
print (condition)
print (np.extract(condition, x))

# NumPy 副本和视图
# 副本是一个数据的完整的拷贝，如果我们对副本进行修改，它不会影响到原始数据，物理内存不在同一位置。
# 视图是数据的一个别称或引用，通过该别称或引用亦便可访问、操作原有数据，但原有数据不会产生拷贝。如果我们对视图进行修改，它会影响到原始数据，物理内存在同一位置。
# 视图一般发生在：
# 1、numpy 的切片操作返回原数据的视图。
# 2、调用 ndarray 的 view() 函数产生一个视图。
# 副本一般发生在：
# Python 序列的切片操作，调用deepCopy()函数。
# 调用 ndarray 的 copy() 函数产生一个副本。
# 无复制
# 简单的赋值不会创建数组对象的副本。 相反，它使用原始数组的相同id()来访问它。 id()返回 Python 对象的通用标识符，类似于 C 中的指针。
# 此外，一个数组的任何变化都反映在另一个数组上。 例如，一个数组的形状改变也会改变另一个数组的形状。
import numpy as np
a = np.arange(6)
print (a)
print (id(a))
b = a 
print (b)
print (id(b)) # b的id()和a的id()相同,共用一个id();
b.shape = 3,2 # b和a共用一个id(),b的改变也会改变a;
print (b)
print (a)

# 视图或浅拷贝:
# ndarray.view() 方会创建一个新的数组对象，该方法创建的新数组的维数更改不会更改原始数据的维数。
a = np.arange(6).reshape(3,2)
print (a)
print (id(a))
b = a.view()  
print (b)
print (id(b)) # 此时b的id和a不一样,改变b不会改变a
b.shape =  2,3
print (b)
print (a)

# 使用切片创建视图修改数据会影响到原始数组：
import numpy as np
arr = np.arange(12)
a=arr[3:]
b=arr[3:]
print (arr)
print(id(arr))
print(a)
print(id(a))
print(b)
print(id(b))
a[1]=123 # 对a的第二个元素进行了修改,a的id依然不变,但arr也跟着a发生了改变,arr的id依然不变;
print (arr)
print(id(arr))
print(a)
print(id(a))
print(b)
print(id(b))
b[2]=234 # 对b的第三个元素进行了修改,b a 和arr的id依然不变,但是a和arr的对应位置的元素都发生了改变;
print (arr)
print(id(arr))
print(a)
print(id(a))
print(b)
print(id(b))
# 变量 a,b 都是 arr 的一部分视图，对视图的修改会直接反映到原数据中。但是我们观察 a,b 的 id，他们是不同的，也就是说，视图虽然指向原数据，但是他们和赋值引用还是有区别的。

# ndarray.copy() 函数创建一个副本。 对副本数据进行修改，不会影响到原始数据，它们物理内存不在同一位置。
a = np.array([[10,10],  [2,3],  [4,5]])
print (a)
print(id(a))
b = a.copy()
print (b)
print(id(b))
print (b is a)
b[0,0]  =  100
print(a)
print(id(a))
print(b)
print(id(b))

'''Matrix矩阵库'''
# matlib.empty() 函数返回一个新的矩阵，语法格式为：
numpy.matlib.empty(shape, dtype, order)
参数说明：
shape: 定义新矩阵形状的整数或整数元组
Dtype: 可选，数据类型
order: C（行序优先） 或者 F（列序优先）
import numpy.matlib
import numpy as np
print (np.matlib.empty((2,2))) 
a = np.matlib.empty((2,3),dtype = 'int16',order = 'C')
print(a)

# numpy.matlib.zeros() 函数创建一个以 0 填充的矩阵。
print (np.matlib.zeros((2,2)))

# numpy.matlib.ones()函数创建一个以 1 填充的矩阵。
print (np.matlib.ones((2,2)))

# numpy.matlib.eye() 函数返回一个矩阵，对角线元素为 1，其他位置为零。
numpy.matlib.eye(n, M,k, dtype)
参数说明：
n: 返回矩阵的行数
M: 返回矩阵的列数，默认为 n
k: 对角线的索引
dtype: 数据类型
print (np.matlib.eye(n =  3, M =  4, k =  0, dtype =  float))

# numpy.matlib.identity() 函数返回给定大小的单位矩阵。
单位矩阵是个方阵，从左上角到右下角的对角线（称为主对角线）上的元素均为 1，除此以外全都为 0。
print (np.matlib.identity(5, dtype =  float))

# numpy.matlib.rand() 函数创建一个给定大小的矩阵，数据是随机填充的。
print (np.matlib.rand(3,3))

# 矩阵总是二维的，而 ndarray 是一个 n 维数组。 两个对象都是可互换的。
import numpy.matlib 
import numpy as np   
i = np.matrix('1,2;3,4')  
print (i)
j = np.asarray(i)  
print (j)
k = np.asmatrix (j)  
print (k)

'''线性代数'''
# NumPy 提供了线性代数函数库 linalg，该库包含了线性代数所需的所有功能，可以看看下面的说明：
函数	        描述
dot	        两个数组的点积，即元素对应相乘。
vdot	    两个向量的点积
inner	    两个数组的内积
matmul	    两个数组的矩阵积
determinant	数组的行列式
solve	    求解线性矩阵方程
inv	        计算矩阵的乘法逆矩阵

# numpy.dot() 对于两个一维的数组，计算的是这两个数组对应下标元素的乘积和(数学上称之为内积)；对于二维数组，计算的是两个数组的矩阵乘积；对于多维数组，它的通用计算公式如下，即结果数组中的每个元素都是：数组a的最后一维上的所有元素与数组b的倒数第二位上的所有元素的乘积和： dot(a, b)[i,j,k,m] = sum(a[i,j,:] * b[k,:,m])。
numpy.dot(a, b, out=None) 
参数说明：
a : ndarray 数组
b : ndarray 数组
out : ndarray, 可选，用来保存dot()的计算结果;
import numpy.matlib
import numpy as np 
a = np.array([[1,2],[3,4]])
b = np.array([[11,12],[13,14]])
print(np.dot(a,b))

# numpy.vdot() 函数是两个向量的点积。 如果第一个参数是复数，那么它的共轭复数会用于计算。 如果参数是多维数组，它会被展开。
a = np.array([[1,2],[3,4]]) 
b = np.array([[11,12],[13,14]])  
# vdot 将数组展开计算内积
print (np.vdot(a,b))

# numpy.inner() 函数返回一维数组的向量内积。对于更高的维度，它返回最后一个轴上的和的乘积。
print (np.inner(np.array([1,2,3]),np.array([0,1,0])))

# numpy.matmul 函数返回两个数组的矩阵乘积。 虽然它返回二维数组的正常乘积，但如果任一参数的维数大于2，则将其视为存在于最后两个索引的矩阵的栈，并进行相应广播。另一方面，如果任一参数是一维数组，则通过在其维度上附加 1 来将其提升为矩阵，并在乘法之后被去除。对于二维数组，它就是矩阵乘法：
import numpy.matlib 
import numpy as np  
a = [[1,0],[0,1]] 
b = [[4,1],[2,2]] 
print (np.matmul(a,b))
a = np.arange(8).reshape(2,2,2) 
b = np.arange(4).reshape(2,2) 
print (np.matmul(a,b))

# numpy.linalg.det() 函数计算输入矩阵的行列式。
a = np.array([[1,2], [3,4]])  
print (np.linalg.det(a))
b = np.array([[6,1,1], [4, -2, 5], [2,8,7]]) 
print (b)
print (np.linalg.det(b))

# numpy.linalg.solve() 函数给出了矩阵形式的线性方程的解。
# numpy.linalg.inv() 函数计算矩阵的乘法逆矩阵。
import numpy as np  
x = np.array([[1,2],[3,4]]) 
y = np.linalg.inv(x) 
print (x)
print (y)
print (np.dot(x,y))
a = np.array([[1,1,1],[0,2,5],[2,5,-1]]) 
print (a)
ainv = np.linalg.inv(a)
print (ainv)
b = np.array([[6],[-4],[27]]) 
print (b)
x = np.linalg.solve(a,b) 
print (x)

'''numpy IO: Numpy 可以读写磁盘上的文本数据或二进制数据。'''
NumPy 为 ndarray 对象引入了一个简单的文件格式：npy。
npy 文件用于存储重建 ndarray 所需的数据、图形、dtype 和其他信息。
常用的 IO 函数有：
load() 和 save() 函数是读写文件数组数据的两个主要函数，默认情况下，数组是以未压缩的原始二进制格式保存在扩展名为 .npy 的文件中。
savze() 函数用于将多个数组写入文件，默认情况下，数组是以未压缩的原始二进制格式保存在扩展名为 .npz 的文件中。
loadtxt() 和 savetxt() 函数处理正常的文本文件(.txt 等)
# numpy.save() 函数将数组保存到以 .npy 为扩展名的文件中。
numpy.save(file, arr, allow_pickle=True, fix_imports=True)
参数说明：
file：要保存的文件，扩展名为 .npy，如果文件路径末尾没有扩展名 .npy，该扩展名会被自动加上。
arr: 要保存的数组
allow_pickle: 可选，布尔值，允许使用 Python pickles 保存对象数组，Python 中的 pickle 用于在保存到磁盘文件或从磁盘文件读取之前，对对象进行序列化和反序列化。
fix_imports: 可选，为了方便 Pyhton2 中读取 Python3 保存的数据。
import numpy as np  
a = np.array([1,2,3,4,5])  
# 保存到 outfile.npy 文件上
np.save('outfile.npy',a)  
# 保存到 outfile2.npy 文件上，如果文件路径末尾没有扩展名 .npy，该扩展名会被自动加上
np.save('outfile2',a)
b = np.load('outfile.npy')  
print (b)

# numpy.savez() 函数将多个数组保存到以 npz 为扩展名的文件中。
numpy.savez(file, *args, **kwds)
参数说明：
file：要保存的文件，扩展名为 .npz，如果文件路径末尾没有扩展名 .npz，该扩展名会被自动加上。
args: 要保存的数组，可以使用关键字参数为数组起一个名字，非关键字参数传递的数组会自动起名为 arr_0, arr_1, …　。
kwds: 要保存的数组使用关键字名称。
import numpy as np  
a = np.array([[1,2,3],[4,5,6]])
b = np.arange(0, 1.0, 0.1)
c = np.sin(b)
# c 使用了关键字参数 sin_array
np.savez("runoob.npz", a, b, sin_array = c)
r = np.load("runoob.npz")  
print(r.files) # 查看各个数组名称
print(r["arr_0"]) # 数组 a
print(r["arr_1"]) # 数组 b
print(r["sin_array"]) # 数组 c

# savetxt() 函数是以简单的文本文件格式存储数据，对应的使用 loadtxt() 函数来获取数据。
np.loadtxt(FILENAME, dtype=int, delimiter=' ')
np.savetxt(FILENAME, a, fmt="%d", delimiter=",")
参数 delimiter 可以指定各种分隔符、针对特定列的转换器函数、需要跳过的行数等。
import numpy as np  
a = np.array([1,2,3,4,5]) 
np.savetxt('out.txt',a) 
b = np.loadtxt('out.txt')  
print(b)

a=np.arange(0,10,0.5).reshape(4,-1)
np.savetxt("out.txt",a,fmt="%d",delimiter=",") # 改为保存为整数，以逗号分隔
b = np.loadtxt("out.txt",delimiter=",") # load 时也要指定为逗号分隔
print(b)

'''Matplotlib'''
是 Python 的绘图库。 它可与 NumPy 一起使用，提供了一种有效的 MatLab 开源替代方案。 它也可以和图形工具包一起使用，如 PyQt 和 wxPython。
import numpy as np 
from matplotlib import pyplot as plt  
x = np.arange(0,6.28,0.01) 
y =  np.sin(x)
plt.title("Matplotlib demo") 
plt.xlabel("x axis caption") 
plt.ylabel("y axis caption") 
plt.plot(x,y) 
plt.show()

# matplotlib默认不支持中文的解决办法:
import numpy as np 
from matplotlib import pyplot as plt 
import matplotlib 
# fname 为 你下载的字体库路径，注意 SimHei.ttf 字体的路径
zhfont1 = matplotlib.font_manager.FontProperties(fname=r"F:\Download\SimHei.ttf") # 注意字体的保存路径;
x = np.arange(1,11) 
y =  2  * x +  5 
plt.title("菜鸟教程 - 测试", fontproperties=zhfont1)  
# fontproperties 设置中文显示，fontsize 设置字体大小
plt.xlabel("x 轴", fontproperties=zhfont1)
plt.ylabel("y 轴", fontproperties=zhfont1)
plt.plot(x,y) 
plt.show()

# 此外，我们还可以使用系统的字体：
from matplotlib import pyplot as plt
import matplotlib
a=sorted([f.name for f in matplotlib.font_manager.fontManager.ttflist])
for i in a:
    print(i)
# 打印出你的 font_manager 的 ttflist 中所有注册的名字，找一个看中文字体例如：STFangsong(仿宋）,然后添加以下代码即可：
plt.rcParams['font.family']=['STFangsong']
x = np.arange(1,11) 
y =  2  * x +  5 
plt.title("菜鸟教程 - 测试")  
# fontproperties 设置中文显示，fontsize 设置字体大小
plt.xlabel("x 轴")
plt.ylabel("y 轴")
plt.plot(x,y) 
plt.show()

# 可以通过向 plot() 函数添加格式字符串来显示离散值。 可以使用以下格式化字符。
字符	描述
'-'	    实线样式
'--'	短横线样式
'-.'	点划线样式
':'	    虚线样式
'.'	    点标记
','	    像素标记
'o'	    圆标记
'v'	    倒三角标记
'^'	    正三角标记
'&lt;'	左三角标记
'&gt;'	右三角标记
'1'	    下箭头标记
'2'	    上箭头标记
'3'	    左箭头标记
'4'	    右箭头标记
's'	    正方形标记
'p'	    五边形标记
'*'	    星形标记
'h'	    六边形标记 1
'H'	    六边形标记 2
'+'	    加号标记
'x'	    X 标记
'D'	    菱形标记
'd'	    窄菱形标记
'&#124;'	竖直线标记
'_'	    水平线标记
# 以下是颜色的缩写：
字符	颜色
'b'	    蓝色
'g'	    绿色
'r'	    红色
'c'	    青色
'm'	    品红色
'y'	    黄色
'k'	    黑色
'w'	    白色
# 要显示圆来代表点，而不是上面示例中的线，请使用 ob 作为 plot() 函数中的格式字符串。
import numpy as np 
from matplotlib import pyplot as plt  
x = np.arange(1,11) 
y =  2  * x +  5 
plt.title("Matplotlib demo") 
plt.xlabel("x axis caption") 
plt.ylabel("y axis caption") 
plt.plot(x,y,"ob") 
plt.show()

# subplot() 函数允许你在同一图中绘制不同的东西。
# 以下实例绘制正弦和余弦值:
import numpy as np 
import matplotlib.pyplot as plt 
# 计算正弦和余弦曲线上的点的 x 和 y 坐标 
x = np.arange(0,  2  * np.pi,  0.1) 
y_sin = np.sin(x) 
y_cos = np.cos(x)  
# 建立 subplot 网格，高为 2，宽为 1  
# 激活第一个 subplot
plt.subplot(2,  1,  1)  
# 绘制第一个图像 
plt.plot(x, y_sin) 
plt.title('Sine')  
# 将第二个 subplot 激活，并绘制第二个图像
plt.subplot(2,  1,  2) 
plt.plot(x, y_cos) 
plt.title('Cosine')  
# 展示图像
plt.show()

# pyplot 子模块提供 bar() 函数来生成条形图。
# 以下实例生成两组 x 和 y 数组的条形图。
from matplotlib import pyplot as plt 
x =  [5,8,10] 
y =  [12,16,6] 
x2 =  [6,9,11] 
y2 =  [6,15,7] 
plt.bar(x, y, align =  'center') 
plt.bar(x2, y2, color =  'g', align =  'center') 
plt.title('Bar graph') 
plt.ylabel('Y axis') 
plt.xlabel('X axis') 
plt.show()

# numpy.histogram() 函数是数据的频率分布的图形表示。 水平尺寸相等的矩形对应于类间隔，称为 bin，变量 height 对应于频率。
numpy.histogram()函数将输入数组和 bin 作为两个参数。 bin 数组中的连续元素用作每个 bin 的边界。
import numpy as np  
a = np.array([22,87,5,43,56,73,55,54,11,20,51,5,79,31,27])
np.histogram(a,bins =  [0,20,40,60,80,100]) 
hist,bins = np.histogram(a,bins =  [0,20,40,60,80,100])  
print (hist) 
print (bins)
# plt()
Matplotlib 可以将直方图的数字表示转换为图形。 pyplot 子模块的 plt() 函数将包含数据和 bin 数组的数组作为参数，并转换为直方图。
a = np.array([22,87,5,43,56,73,55,54,11,20,51,5,79,31,27]) 
plt.hist(a, bins =  [0,20,40,60,80,100]) 
plt.title("histogram") 
plt.show()