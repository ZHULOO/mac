# 三大利器
# 一,装饰器：不对原有函数改动的情况下，适当改动函数的功能：
def deco1(func):
    def wrapper(x):
        print("前面加上装饰器的效果")
        func(x)
    return wrapper

def deco2(func):
    def wrapper():
        func()
        print("后面加上装饰器的效果")
    return wrapper

def deco3(func):
    def wrapper(*args):
        print("前面加上装饰器的效果,参数个数未知")
        func(*args)             # 无法知道函数参数个数的时候,使用*args可变参数
    return wrapper

def deco4(func):
    def wrapper(*args,**kwargs):
        print("前面加上装饰器的效果,参数个数未知+关键字参数")
        func(*args,**kwargs)     # 既含有位置个数参数,又含有关键字参数;
    return wrapper


@deco2                  # 一般是按照装饰器顺序执行的,但是deco2是在函数之后运行;
def func1():
    print("我是函数1")

@deco1
def func2(x):
    print("我是函数2,参数为:",x)

@deco3
def func3(x,y):
    print("我是函数3,参数为:",x,y) # 多个参数

@deco4
def func4(x,y,**kwargs):          # 关键字参数**kwargs
    print("我是函数4,参数为:",x,y) 
    print(kwargs)

func1()
print("==============================")
func2("你好")
print("==============================")
func3("hello","world")
print("==============================")
func4("hello","world",a=1,b=2,c=3)

def deco(func5):
    def wrapper(a,b):
        c=func5(a,b)
        print(c*c)
    return wrapper


@deco
def func5(a,b):
    return(a+b)

func5(1,3)

# 迭代器
'''
1,有序,下一个
2,Iterable
3,python可被迭代的对象:list,tuple,string,set,dict,bytes

'''
print("===============迭代器===============")
mylist = [1,2,3,4,5,6]
for i in mylist:
    print(i)

from collections.abc import Iterable
print(isinstance(mylist,Iterable))               # 可迭代返回True
print(isinstance("mylist",Iterable))             # 可迭代返回True
print(isinstance(123456,Iterable))               # 不可迭代返回False

# 可被迭代的对象,可以被生成一个迭代器
mylist = [1,2,3,4,5,6]
it = iter(mylist)
print("第1次next:",next(it))
print("第2次next:",next(it))
print("第3次next:",next(it))
print("第4次next:",next(it))
print("第5次next:",next(it))
print("第6次next:",next(it))     # next方法可以一个个去除迭代器内容;
# print("第7次next:",next(it))     # 6次next方法后已经没有了,出错;

# 生成器
# generator生成器:range(100000000000000)可被遍历的对象太大,没必要一次全部生成输出;
# 可以边迭代,边输出

print("===============生成器===============")

gen = (x for x in range(1,400000000000))
print(isinstance(gen,Iterable)) # 是可迭代对象
print(next(gen))
print(next(gen))
print(next(gen))   # 不用全部生成4000000000000个元素, 使用了三次只生成三个元素就行;

# 斐波那契数列:0,1,1,2,3,5,8,13,21
# 不使用生成器:
def fibo(n):
    a,b = 0,1
    count = 0
    res = []
    while True:
        if count > n:
            break
        res.append(a+b)
        a,b=b,a+b
        count += 1
    return res

print(fibo(10))

# 使用生成器:yield
def fibo(n):
    a,b = 0,1
    count = 0
    #res = []
    while True:
        if count > n:
            break
        #res.append(a+b)
        yield a+b   # 执行一次next(),yield一个a+b;
        a,b=b,a+b
        count += 1

gen1 = fibo(10)
for i in gen1:
    print(i)


gen2 = fibo(10000000) # 实际上没有一次全部生成这么多的数列,而是使用多少生成多少;
for i in gen2:
    if i > 500:
        break
    print(i)


