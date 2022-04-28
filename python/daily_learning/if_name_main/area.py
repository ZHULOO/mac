from const import PI # 这里从const.py里导入PI来使用,不需要运行const.py里的程序;
def calcuarea(r):
    return PI*(r**2)

def area():
    print("圆的面积",calcuarea(2))

area()