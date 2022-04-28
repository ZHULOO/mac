# 循环控制
# if语句
score = int(input("请输入你的成绩: "))
if score >= 0 and score <= 100:
    if score >= 90 and score <= 100:
        print("优秀")
    elif score >=80 and score < 90:
        print("良好")
    elif score >=70 and score < 80:
        print("一般")
    elif score >=60 and score < 70:
        print("及格")
    else:
        print("不及格")
else:
    print("你输入的成绩有误,请重新输入: ")
    score1= int(input("请输入: "))
    if score1 >= 90 and score1 <= 100:
        print("优秀")
    elif score1 >= 80 and score1 < 90:
        print("良好")
    elif score1 >= 70 and score1 < 80:
        print("一般")
    elif score1 >= 60 and score1 < 70:
        print("及格")
    else:
        print("不及格")

# for循环
result = 0
for i in range(101):
    result += i
print(result)

# +=的操作
a = [1,2,3]
b = [4,5,6]
c = a        # c = [1,2,3]
id(a)
id(b)
id(c)        #和a的id相同
d = a + b    # d = [1,2,3,4,5,6]
id(d)
a += b       # a = a + b 
a            # a = [1,2,3,4,5,6]
id(a)        # id没变化和上面的id一样
c            # c = [1,2,3,4,5,6],c的值随着a发生了变化;
id(c)        # id也没变化
# 与下面对比,a += b和a = a + b结果是相同的但是过程和原理不同;
a = [1,2,3]
b = [4,5,6]
c = a
id(a)
id(b)
id(c)
d = a + b
id(d)
a = a + b
a
id(a)
c
id(c)

# 跳转语句
# break:终止循环
for i in range(1,10):
    if i == 5:         # 循环到5即终止;
        break
    print(i)
# continue:跳过
for i in range(1,10):
    if i == 5:         # 循环到5直接跳过,继续循环后面的数据;
        continue
    print(i)
# 拍腿游戏:
total = 99
for i in range(1,100):
    if i % 7 == 0:          # 整除和以7结尾的都跳过循环,其它都参与循坏了,每循环一次total减1
        continue
    else:
        string = str(i)
        if string.endswith('7'):
            continue
    total -= 1             # 不符合以上条件的都正常循环了,这里减1;
    print(total)
print("共拍腿",total,"次")

# 常用循环
# 1. 冒泡排序
list1 = [10,9,8,7,6,5,4,3,2,1]


def sortport():
    for i in range(len(list1)-1):   # i = 0 1 2...8九个
        for j in range(len(list1)-i-1):
            if list1[j] > list1[j+1]:
                list1[j],list1[j+1] = list1[j+1],list1[j]
    return list1

sortport()
len(list1)
print(range(len(list1)-1))

# 2. 计算x的n次方
def power(x,n):
    s = 1
    while n > 0:
        n = n - 1 
        s = s * x
    return s

power(3,8)