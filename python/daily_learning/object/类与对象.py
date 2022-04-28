### 对象:类与实例
'''
类与实例都是对象:
类对象
实例对象
类属性
实例属性
类方法
实例方法
'''
# 定义一个动物类

class animal():
    def eat(self,food):         # self相当于类实例化以后的对象;
        print(f"正在吃{food}")

    def play(self):
        print(f"正在玩耍")

    def sleep(self):
        self.eat("睡前点心")    # sleep方法中调用eat方法
        print(f"正在睡觉")

# 实例对象调用类方法
dog = animal()              # animal实例化以后变成了dog对象
dog.eat("狗粮")             # 调用类方法时,self就是dog(实例化后的对象)
dog.play()                  # 
dog.sleep()
# 或者类直接调用方法,但是要传递一个实例对象作为self参数:
print("=========================")
pig = animal()
animal.play(pig)
animal.eat(pig,"猪食")

### __new__()方法:创建对象,开辟一个内存空间;
### __init__()方法:对内存空间初始化;
class Province():
    country = "中国"                # 类属性:类里的变量,实例对象都可以共享该属性;
    def __init__(self,x1,x2):
        self.name = x1              # 实例属性:实例里的变量,实例对象独有的属性;
        self.address = x2

    def info(self,popu):
        print(self.address + self.name + "人口" + f"{popu}")

pro1 = Province("河南省","中部")
# 实例属性:
pro1.name
pro1.add
pro1.country        # 实例的country属性__class__指向类对象属性;
# 类属性:
Province.country

pro1.info("一亿")

# 实例方法,静态方法和类方法
# 通过实例对象很难修改类属性
# 类对象可以调用类方法和静态方法,不能调用实例对象方法;
pro1.country = "中华人民共和国"           # 修改不了类属性,只能给实例pro1增加一个country属性,必须通过下面方式修改类的country属性;
pro1.__class__.country = "中华人民共和国"
# 可以通过@classmethod定义类方法来修改类属性:
class Foo():
    def __init__(self,x1):
        self.name = x1

    def ord_func(self):
        """实例方法,至少需要一个self参数"""
        print("实例方法")

    @classmethod                        # 语法糖或装饰器,表示此方法为类方法, 可以用来修改类属性
    def class_func(cls):
        """类方法,至少需要一个cls参数"""
        print("类方法")

    @staticmethod                       # 静态方法,一般函数,该类内部可以随意调用该函数;
    def static_func():
        """静态方法,不需要默认参数"""
        print("静态方法")

# property属性:不加括号调用方法,返回一个数值,相当于调用了一个属性;
class Pager:
    def __init__(self,current_page):
        self.current_page = current_page
        self.per_items = 10

    @property
    def start(self):
        val = (self.current_page-1) * self.per_items
        return val

    @property
    def end(self):
        val = (self.current_page) * self.per_items
        return val
# =========调用=============
p = Pager(1)
p.start    # 相当于p.start()实例方法不加括号,结果直接返回一个值,不加括号就不用考虑是否需要传入参数;
p.end  

# @xxx.setter和xxx.deleter python3中的新特性:
class Goods:
    def __init__(self) -> None:
        self.original_price = 100
        self.discount = 0.8
    @property
    def price(self):
        new_price = self.original_price * self.discount
        return new_price

    @price.setter
    def price(self,value):
        self.original_price = value

    @price.deleter
    def price(self):
        del self.original_price
# =========调用=============
obj = Goods()
obj.price
a = obj.price     # 自动执行@property属性修饰的price方法,获取其返回值赋值给a;
obj.price = 200   # 自动执行@price.setter修饰的price方法,将123赋值给方法的参数;
del obj.price     # 自动执行@price.deleter修饰的price方法;
