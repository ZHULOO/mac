# if __name__ == "__main__":的意思就是,只有此包被直接运行的时候才会运行dis函数,否则不运行dis函数.
PI = 3.14

def dis():
    print("PI:", PI)

if __name__ == "__main__": # 如果不加这句话,运行area.py在导入这个const.py包的时候,还会运行这里的dis()函数,显示PI:3.14.
    dis()                  # 加上这句话,运行area.py在导入这个const.py包的时候,只导入PI变量用于圆的面积计算.
    print("直接运行const.py才会显示我,被当作包导入使用的时候不会显示!")

# 如果一个模块被直接运行，则其没有包结构，其 __name__ 值为 __main__。
# 如果模块是被直接运行的，则代码块被运行，如果模块是被导入的，则代码块不被运行。
# 