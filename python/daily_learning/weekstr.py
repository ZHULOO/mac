weekstr="星期一星期二星期三星期四星期五星期六星期日"
weekid=eval(input("请输入数字星期1-7："))
pos=(weekid-1)*3
print(weekstr[pos:pos+3])

weekstr1="一二三四五六日"
weekid1=eval(input("请输入数字星期1-7:"))
print("星期"+weekstr1[weekid1-1])

for i in range(300):  
    print(chr(i),end="")

A={1,2,3,4,'g','h','j','k'}
try:
    while True:
        print(A.pop(),end="")
except:
    pass