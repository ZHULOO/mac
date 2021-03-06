'''值传递,地址传递,拷贝和浅拷贝'''
'''
函数参数传递机制，传值和引用的是什么意思??
python的参数传递是值传递还是引用传递??

函数参数传递机制问题在本质上是调用函数（过程）和被调用函数（过程）在调用发生时进行通信的方法问题。基本的参数传递机制有两种：值传递和引用传递。

1.值传递（pass-by-value）过程中，被调函数的形式参数作为被调函数的局部变量处理，即在堆栈中开辟了内存空间来存放由主调函数放进来的实参的值，从而想成为了实参的一个副本。值传递的特点是被调函数对形势参数的任何操作都是作为局部变量进行，不会影响主调函数的实参变量的值。

2.引用传递（pass-by-reference）过程中，被调函数的形式参数虽然也作为局部变量在堆栈中开辟了内存空间，但这时存放的是由主调函数放进来的实参变量的地址。被调函数对形参的任何操作都被处理成间接寻址，即通过堆栈中存放的地址访问主调函数中的实参变量。正因为如此，被调函数对形参做任何的操作都影响了主调函数中的实参变量。

在python中，可以有多个引用同时指向一个内存。

python不允许程序员选择采用传值还是传引用。
python参数传递采用的肯定是“传对象引用”的方式。这种方式相当于传值和传引用的一种综合。
(1).如果函数收到的是一个可变对象（字典、列表和集合）的引用，就能修改对象的原始值--相当于‘传引用’来传递对象。
(2).如果函数收到的是一个不可变对象（数字、字符和元组）的引用，就不能直接修改原始对象--相当于通过‘值传递’来传递对象。
'''

'''值和地址(引用)'''
# 不可变对象:整数\字符串\元组等
a = '123'           # 等号相当于给'123'对象贴上a标签;
b = a               # b=a相当于给对象'123'又贴上了b标签,此时'123'有a和b两个标签;
print(a,b)
print(id(a),id(b))  #id(a)即内存中的地址;
# 比较:
c = '123'           # 此处'123'是不可变对象,此处相当于又贴上了c标签,仍和上面的'123'共用内存地址;
print(a,c)
print(id(a),id(c))

# 可变对象:列表\字典\集合等
a = [123] 
b = a               # 赋值操作只相当于又贴了一个b标签,所以a和b共用一个[123]对象,
print(a,b)
print(id(a),id(b))  #id(a)即内存中的地址;
# 比较:
c = [123]           # 此处[123]是可变对象,虽然和上面的[123]相同,系统仍为它创建了一个新的内存地址;
print(a,c)
print(id(a),id(c))

'''值传递和引用(地址)传递'''
# 可变对象:因为可变对象的值可以修改,因此可以通过修改可变对象参数的值而修改原对象,类似于C语言中的引用传递;
# 不可变对象:因为不可变对象的值无法修改,所以参数的重新赋值不会影响原对象,类似于C语言中的值传递;
# 系统根据可变对象和不可变对象的不同,给出不同的内存存储模式:
l1=[1]
l2=[1]
a=1
b=1
print(id(l1))
print(id(l2)) # list是可变对象,即使内容一摸一样,python也会给它们分配不同的地址;
print(id(a))
print(id(b))  # int是不可变对象,内容一样时,内存只创建一个地址,不同对象可以共享使用;
# 总结:只要创建一个新的可变对象，python就会分配一个新的地址。就算我们创建的新可变对象和已存在的旧可变对象完全一样，python依旧会分配一个新的地址;
# 在python中，不可变对象是共享的，创建可变对象永远是分配新地址;


'''共享地址:'''
# a b c和d都指向统一可变对象内存地址,当通过变量d对对象进行修改时,其他变量的值也相应被修改了;
a = [1,2,3]
b = a 
print(a,b)
print(id(a),id(b)) # 它们两个的id即内存地址是一样的;
# 修改b,a跟着变化:
b[2] = 5
print(a,b) # 它们两个共用一个对象内存,修改b的同时,a的值都被修改了;
print(id(a),id(b)) # 此时,它们的id依然不变;

'''函数传递不可变对象(值传递)时的情况:'''
# ;例1:
a = 1
print(id(a))
def x(a):
    print(id(a))
    b = a
    print(id(b))
x(a)
a
# 例2:
a = 1
print(id(a))
def x():
    b = 1
    print(id(b))
x()
# 很神奇不是吗？函数外定义的a和函数内定义的b没有任何关系，但它们指向同一个地址！
# 所以你说如何判断它是值传递还是引用传递？讨论这个问题根本没有意义，因为内存里只有一个1。当我把值1传递给函数里的某一个变量的时候，我实际上也传递了地址，因为内存里只有一个1。
# 甚至于说我直接给函数里的b赋值1都可以让函数外的a和函数内的b指向同一个地址。
# 例3:
def swap(a , b) :
    # 下面代码实现a、b变量的值交换
    a, b = b, a
    print("swap函数里，a的值是", \
        a, "；b的值是", b)
    print(id(a),id(b))
a = 6
b = 9
print(id(a),id(b))

swap(a , b)

print(a ,b)
print(id(a),id(b))
# 例4:
t = (1,2,3)
print(id(t))
def a(x):
    #print(id(x))
    #x.pop() # tuple本身不可修改无pop方法;
    print(x)
    print(id(x))
    x = x + (3,) # x赋值以后,x的地址也变了;
    print(x)
    print(id(x))
a(t)
print(t)
print(id(t))

'''函数传递可变对象(引用或地址传递)时:'''
# 例1:
l = [1,2,3]
print(id(l))
def a(x):
    print(id(x))
    x.pop() # pop方法修改了x本身,地址没变;
    print(x)
    print(id(x))
    x = x + [4] # x使用了=号赋值以后,x的地址也变了,不会改变原有参数;
    print(x)
    print(id(x))
a(l)
print(l)
print(id(l))

# 例2:
def swap(dw):
    # 下面代码实现dw的a、b两个元素的值交换
    dw['a'], dw['b'] = dw['b'], dw['a']
    print("swap函数里，a元素的值是",\
        dw['a'], "；b元素的值是", dw['b'])
    dw = None
dw = {'a': 6, 'b': 9} # dw为可变对象dict;
swap(dw) # 此时为引用(地址)传递,函数
print(dw)

# 总结:
# 不管什么类型的参数，在 Python 函数中对参数直接使用“=”符号赋值是没用的，直接使用“=”符号赋值并不能改变参数。
# 如果需要让函数修改某些数据，则可以通过把这些数据包装成列表、字典等可变对象，然后把列表、字典等可变对象作为参数传入函数，在函数中通过列表、字典的方法修改它们，这样才能改变这些数据。
# 例如:
def swap(dw):
    dw['a'],dw['b'] = 1,2   # 字典的方法改变了函数引用的可变对象dw
    dw = {'a':7,'b':8}      # 等号赋值并不能改变原来可变对象dw;

dw = {'a':6,'b':9}
print(id(dw))
swap(dw)
print(dw)
print(id(dw))

'''浅拷贝与深拷贝:'''
a = [1,[1,2,3]]
b = [1,[1,2,3]] # a b为可变对象,虽然它们完全相同,python也总为它们创建不同的内存地址,Python提供了一个copy模块，有深拷贝和浅拷贝方法:
c = a.copy() 
a,b,c
id(a),id(b),id(c)
id(a[1]),id(b[1]),id(c[1])# copy方法创建的c和a完全相同,但是第一层有不同的内存地址,但是第二层[1,2,3]依然具有完全相同的内存地址,改变第二层的内容,a和c虽然具有不同的内层地址,要求能发生同步变化;
# 改变a[1]即[1,2,3]的二层的内容,c也会发生同步变化:
a[1].append(4) 
a,b,c
id(a),id(b),id(c)
id(a[1]),id(b[1]),id(c[1])
# 但是改变a[0]第一层的内容,a和c不再同步发生变化
a.append(2) 
a,b,c
id(a),id(b),id(c) 

# 深度拷贝需要copy模块
import copy
a = [1,[1,2,3]]
c = a.copy()         # 一般拷贝只拷贝到第一层,虽然它们具有不同的内存地址,但是它们的子对象[1,2,3]还具有相同的地址内存;
d = copy.deepcopy(a) # 深拷贝第一层和第二层的内层地址均不同;
a,c,d
id(a),id(c),id(d)
id(a[1]),id(c[1]),id(d[1])

a[1].append(4)
a,c,d
id(a),id(c),id(d)
id(a[1]),id(c[1]),id(d[1]) 
# b += 5和b = b + 5的区别：
# 当b是一个可变对象时，例如list，b += 5相当于在原内存中修改，id地址不变，
import random
import numpy as np
a = np.array(np.arange(0, 10))
print(a,id(a))
b = a[2:4] 
print(b,id(b))
b += 5
print(b,id(b)) # 此时b的值变化，但b的id不变，a的值也跟随b发生了变化，但是a的id也未变化，不用开辟新的内存空间来存放变化后的b和a，节省内存；
print(a,id(a))

# 和上面对比，b = b + 5，开辟了新的内存空间来存储b，b的值变化以后，id也发生了变化，
import random
import numpy as np
a = np.array(np.arange(0, 10))
print(a,id(a))
b = a[2:4] 
print(b,id(b))
b = b + 5 
print(b,id(b)) # b的值变化以后，id也发生了变化，开辟了新的内存空间来存储修改后的b，更加浪费内存；
print(a,id(a)) # 但此时a的值和id均未变化；