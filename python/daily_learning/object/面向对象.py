
"""
面向对象编程：类、对象
Objece Oriented Programming-->OOP
这个编程思想，主要强调：
1. 封装性
2. 继承性
3. 多态
"""
# 定义一个类（人类）：
class Person:
    """
    定义一个类
    """
    # 类的属性
    legs = 2
    hands = 2
    # 类的方法：类内部定义的函数，其第一个参数是self；
    def __init__(self,name,sex,age): # 此函数会在类的实例化时自动执行一次；
        print("__init__")
        self.name = name
        self.sex = sex
        self.age = age
    def say(self): # self就相当于调用对象时的实例本身，就相当于下面的luxp和wxd；
        print(self)
        print("hello world")



# 实例化（具体的个人）：
luxp = Person()
wxd = Person("wxd","女","28")

# 类的属性：
# “实例.属性名” 的形式就可以调用对象的属性：
# luxp.legs = 2
# luxp.hands = 2 # 2条腿和2只手是人类共有的属性，可以放到Person类的属性下面；
luxp.name = "luxp"
luxp.sex = "男"
luxp.age = 18

# wxd.legs = 2
# wxd.hands = 2 # 这里就不需要再为每一个人设置两条腿和两只手的属性了；
wxd.name = "wxd"
wxd.sex = "女"
wxd.age = 28

# 可以看到每创建一个人都像上面来自定义属性的话也很麻烦，此时可以定义一个__init__()函数；
# 定义了__init__()函数以后，实例化时就要传入实例的参数：
luxp = Person("luxp","男",18)
wxd = Person("wd","女",28)
luxp.name
luxp.age
luxp.sex
luxp.say()

# 此时思考一个问题：下面两个类属性调用有什么区别？
# 类属性与实例属性的区别：
luxp.name
luxp.legs
# 先看一下实例的内部结构：
dir(luxp)
dir(wxd)
# 查看每个实例的属性：
luxp.__dict__ # {'name': 'luxp', 'sex': '男', 'age': 18}
wxd.__dict__
# 然后通过“类.属性名”修改类的属性后再查看实例的属性：
luxp.legs
Person.legs = 3
luxp.legs # 可以看到通过上面的方式修改了类的legs属性以后，所有实例的legs也随之发生了变化；
wxd.legs
# 通过实例自身的属性也可以修改（实例.属性名），但是不影响其它实例的属性;
luxp.legs = 6
luxp.legs # 此时luxp的legs属性修改为6，但是wxd的legs属性还是为3；
wxd.legs
luxp.__dict__ # 通过“实例.属性名”修改了属性以后，相当于在实例内部创建了一个局域属性:{'name': 'luxp', 'sex': '男', 'age': 18, 'legs': 6}



###############################################################################
# 类的方法：类内部定义的函数;
# “实例.方法名” 的形式就可以调用类的方法:
luxp.say() # 结果如下：
<__main__.Person object at 0x000001B4C2908610> 
hello world

wxd.say()

0x000001B4C29309D0 # 输入查看类方法的内存地址
0x000001B4C2908610
id(luxp) # 可以看到luxp的内存地址和类方法定义中的self是一样的，这就表示他们是同一个对象，
id(wxd)

###############################################################################
# 类的继承：
'''
继承:子类可以继承父类的方法和属性。
子类继承父类后，可以直接实例化子类，那么父类中的属性和方法也都可以被子类调用。
'''
# 继承的语法格式
class 父类名称:
    pass
class 子类(父类名称):
    pass

# 例如：
class Parent:
    def hello(self):
        print("正在调用父类中的方法")

class Child(Parent):
    pass

p = Parent()
p.hello()

c = Child()
c.hello()

# 如果子类中的属性和方法与父类中同名，则自动覆盖父类中的属性和方法：
class Parent:
    def hello(self):
        print("正在调用父类中的方法")

class Child(Parent):
    def hello(self):
        print("正在调用子类中的方法")

p = Parent()
p.hello()

c = Child()
c.hello()

# 例子：鱼
import random as r

class Fish:
    """
    父类:鱼
    """
    def __init__(self):
        self.x = r.randint(0,10)
        self.y = r.randint(0,10)

    def move(self):
        self.x += 1
        print("我的位置是：",self.x,self.y)

class Goldfish(Fish):
    pass

class Carp(Fish):
    pass

class Salmon(Fish):
    pass

class Shark(Fish):
    """
    定义鲨鱼子类
    """
    def __init__(self): # 这里重写了和父类一样__init__()的方法，父类中的方法就被覆盖了：
        self.hungry = True

    def eat(self):
        if self.hungry:
            print("吃货的梦想就是天天有的吃^_^")
            self.hungry = False
        else:
            print("太撑了，吃不下了！")

# 鱼的父类和各类子类定义和继承好之后，开始实例化运行：
fish = Fish()
fish.move()

goldfish = Goldfish()
goldfish.move()

shark = Shark()
shark.move() # 出错了：鲨鱼子类写了和父类一样的方法，父类中的方法就被覆盖了
# 有两种方法解决：
# 1.调用未绑定的父类方法；
class Shark(Fish):
    def __init__(self): 
        Fish.__init__(self) # 加入这一句调用未绑定的父类方法，就不出错了；
        self.hungry = True

    def eat(self):
        if self.hungry:
            print("吃货的梦想就是天天有的吃^_^")
            self.hungry = False
        else:
            print("太撑了，吃不下了！")
# 2.使用super函数
class Shark(Fish):
    def __init__(self): 
        super().__init__() # super函数不需要传入self参数了,super()相当于super(Shark,self);
        self.hungry = True

    def eat(self):
        if self.hungry:
            print("吃货的梦想就是天天有的吃^_^")
            self.hungry = False
        else:
            print("太撑了，吃不下了！")
Shark.mro()
shark = Shark()
shark.move()

# 多重继承
class Person:
    legs = 2
    hands = 2

    def __init__(self,name,age):
        print("Person的__init__")
        self.name = name
        self.age = age

    def say(self):
        print("hello world")
    pass

class Man(Person):
    sex = "男"
    def __init__(self,name,age):
        print("man的__init__")
        super().__init__(name,age)
    
    def like(self):
        print("旅游")

    def say(self):
        print("i love you")

    def drink(self):
        print("爱喝白酒")

class Women(Person):
    sex = "女"
    def __init__(self,name,age):
        print("women的__init__")
        super().__init__(name,age)
    
    def like(self):
        print("逛街")

    def say(self):
        print("。。。呵呵")

    def show(self):
        print("爱自拍")

class Ladyboy(Man,Women):
    pass

mdm = Ladyboy("mdm",18)
mdm.sex     # 显示为“男”
mdm.say()   # 显示为“i love you” 
# 可以看到同名的属性和方法继承顺序为先左后右，优先继承左边的类的属性；
# 而不同名称的属性和方法则全部继承；
mdm.drink()
mdm.show()

# super函数和mro函数
Ladyboy.mro() # 查看Ladyboy类的继承顺序，也可以;
Ladyboy.__mro__  # 和上面的作用是一样的。

# super函数返回当前继承类的下一个类的方法：
class Ladyboy(Man,Women):
    def say(self):
        super().say() # 相当于super(Ladyboy,self).say(),和下面的代码结果是一样的：

class Ladyboy(Man,Women):
    def say(self):
        super(Ladyboy,self).say()

# 使用mro()函数看到继承顺序：(<class '__main__.Ladyboy'>, <class '__main__.Man'>, <class '__main__.Women'>, <class '__main__.Person'>, <class 'object'>)
# super(Ladyboy,self)相当于上面继承顺序中，指定Ladyboy类下一个节点Man中的方法say().

# 类的继承复杂案例：
# 先定义两个类：
class A:
    def show(self):
        print("AAA")

class B:
    def show(self):
        print("BBB")
# 单个继承：
# 下面两个类继承于A、B：
class C(A):
    """
    C继承A
    """
    def show(self):
        print("CCC")
        super().show() # 相当于当前类C的下一节点A，即super(C,self)
        # super(C,self).show()

class D(B):
    """
    D继承B
    """
    def show(self):
        print("DDD")
        super().show() # 这里是指除了要show自己定义的方法DDD，还要show B类下的方法BBB；

# C D实例化;
c = C()
d = D()
c.show()
C.mro() # [<class '__main__.C'>, <class '__main__.A'>, <class 'object'>]
d.show()
D.mro() # [<class '__main__.D'>, <class '__main__.B'>, <class 'object'>]

# 多重继承：
class E(A,B):
    """
    E类继承于A和B
    """
    def show(self):
        super(E,self).show()
        super(A,self).show()
        # super(B,self).show() 会出错，B类后面已经没有类了，

e = E()
e.show()
E.mro() # [<class '__main__.E'>, <class '__main__.A'>, <class '__main__.B'>, <class 'object'>]

class F(C,A):
    def show(self):
        print("*"*10)
        super().show()       # 执行C类的show方法，打印AAA和CCC；
        print("*"*10)
        super(C,self).show() # 执行A类的show方法，打印AAA；
        # super(A,self).show() 同样出错；

f = F()
F.mro() # [<class '__main__.F'>, <class '__main__.C'>, <class '__main__.A'>, <class 'object'>] 
f.show()

class G(C,D):
    def show(self):
        super().show()       # 从下面的mro()函数得到的继承顺序，可以看到此处执行的是本身G类之后的C类的show方法，打印CCC和AAA；
        print("*"*10)
        super(C,self).show() # 执行的是C类后面的A类的show方法，打印AAA；
        print("*"*20)
        super(D,self).show() # 执行的是D类后面的B类的show方法，打印AAA；
        print("*"*30)
        super(A,self).show() # 执行的是A类后面的D类的show方法，打印DDD和BBB；
        # super(B,self).show() B类后面已经没有对象了，出错；

g = G()
G.mro() # [<class '__main__.G'>, <class '__main__.C'>, <class '__main__.A'>, <class '__main__.D'>, <class '__main__.B'>, <class 'object'>]
g.show()


### 类继续学习
class Person:
    def __init__(mysillyobject, name, age):
        mysillyobject.name = name
        mysillyobject.age = age
    def myfunc(abc):
        print("Hello my name is " + abc.name)

p1 = Person("Bill", 63)
p1.myfunc()
p1.age
p1.name
p1.myfunc()