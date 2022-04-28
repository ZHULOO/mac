tempstr = input("请输入带有符号的温度值：")
if tempstr[-1] in ['F','f']:
    C = (eval(tempstr[0:-1])-32)/1.8
    print("转换后的温度是{:.2f}C".format(C))
elif tempstr[-1] in ['C','c']:
    F = 1.8*eval(tempstr[0:-1])+32
    print("转换后的温度是{:.2f}F".format(F))
else:
    print("输入格式错误")



temp = input("请输入带有格式的温度值")
if temp[-1] in ['F','f']:
    c = (eval(temp[0:-1])-32)/1.8
    print("转换后的温度是{:.2f}C".format(c))
elif temp[-1] in ['C','c']:
    f = 1.8*eval(temp[0:-1])+32
    print("转换后的温度是{:.2f}F".format(f))
else:
    print("输入温度格式有误")