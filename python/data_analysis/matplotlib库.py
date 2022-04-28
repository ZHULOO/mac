import numpy as np
from matplotlib import pyplot as plt
import matplotlib
"editor.fontFamily": "Consolas, 'Courier New', monospace"
'''默认状态下matplotlib不支持中文字体,中文显示为方框,需要单独设置'''

'''先查看matplotlib的默认配置'''
import matplotlib.pyplot as plt
plt.rcParams
plt.rcParams['font.family']
plt.rcParams['font.sans-serif']
plt.rcParams['font.serif']
# 在font.family字段制定了使用的字体集，默认地，是sans-serif（无衬线字体），所以mathplotlab会使用font.sans-serif中包含的字体,由于没包含中文字体,所以要另外设置;

# 字体的基本知识:
# font-family有以下5种情况
# serif(衬线)
# sans-serif(无衬线)
# monospace(等宽)
# fantasy(梦幻)
# cuisive(草体)
# 其实大体上分为衬线字体和无衬线字体;
# 等宽字体中也有衬线等宽和无衬线等宽字体;
# 衬线字体:serif,易于识别,为了可读性和识别,有粗细变换的装饰效果,例如中文宋体;
# 无衬线字体: sans-serif,笔画粗细机械,统一,无额外装饰,例如汉字黑体;

'''获取matplotlib的字体库和配置文件,及识别到的系统字体:'''
# 添加一种无衬线的中文字体SimHei到matplotlib字体库:
matplotlib.matplotlib_fname() 
# matplotlib的配置文件位置 "D:\\Anaconda\\lib\\site-packages\\matplotlib\\mpl-data\\matplotlibrc";
# 则matplotlib的字体库位置就应该是 "D:\\Anaconda\\lib\\site-packages\\matplotlib\\mpl-data\\fonts\\ttf"
# 可以将需要使用的ttf格式字体文件拷贝到以上字体文件夹,建议使用黑体字(因为黑体字是无衬线字sans-serif);
# 确认字体放进来是否生效:
# 删除user\lx\.matplotlib\fontlist.json后,重启python并运行;
from matplotlib.font_manager import FontManager 
# 命令会再次生成fontList.json文件,打开此文件看是否加载了拷贝的新字体;
# 可以使用以下命令查看matplotlib识别到的字体,包括系统字体:
sys_fonts = matplotlib.font_manager.fontManager.ttflist # 将系统字体列表赋值给sys_fonts
# 打印出所有系统字体:
a = []
for i in sys_fonts:
    a.append(i)
b = []
for i in sys_fonts:
    b.append(i.name)    
c = sorted(b)
for i in c:
    print(i)
# 或者:
a=sorted([f.name for f in matplotlib.font_manager.fontManager.ttflist])
for i in a:
    print(i)

'''有以下几种字体设置方法:'''

# 方法一:直接指定固定路径下的字体.
zh_font = matplotlib.font_manager.FontProperties(fname=r"F:\Download\Simhei.ttf") 
# 可以单独下载中文字体,单独设置为指定路径下的中文字体:
x = np.arange(-6.28,6.28,0.1)
y = 2*np.sin(x)
plt.title("测试案例",fontproperties = zh_font)
plt.xlabel("x轴",fontproperties = zh_font)   
plt.ylabel("y轴",fontproperties = zh_font)   
plt.plot(x,y)
plt.show()

# 方法二:直接修改rcParams参数来设置.
plt.rcParams['font.sans-serif'] = ['SimHei'] # 将无衬线字体设置为SimHei字体,前提SimHei字体已放入matplotlib字体文件夹;
plt.rcParams['axes.unicode_minus'] = False   # 正常显示负号;
x = np.arange(-6.28,6.28,0.1)
y = 2*np.sin(x)
plt.title("测试案例")
plt.xlabel("x轴")   
plt.ylabel("y轴")   
plt.plot(x,y)
plt.show()

plt.rcParams['font.sans-serif'] = ['STXingkai'] # 将字体设置为STXingkai系统字体,因为默认的font.family是sans-serif;
plt.rcParams['font.family'] = ['STXingkai']     # 将字体设置为STXingkai系统字体;
plt.rcParams['axes.unicode_minus'] = False   # 正常显示负号;
x = np.arange(-6.28,6.28,0.1)
y = 2*np.sin(x)
plt.title("测试案例")
plt.xlabel("x轴")   
plt.ylabel("y轴")   
plt.plot(x,y)
plt.show()

# 方法三:直接修改matplotlibrc配置文件.
# 将SimHei黑体(无衬线字体)添加到matplotlib字体库中,解决默认中文字体乱码的问题:
import matplotlib
matplotlib.matplotlib_fname() #将会获得matplotlib包所在文件夹
# D:\Anaconda\Lib\site-packages\matplotlib\mpl-data文件夹下就能看到matplotlibrc配置文件。
# 打开matplotlibrc配置文件,修改以下三处:
# 取消font.family前面的#号,也可以不取消,因为默认的font.family就是sans-serif,不用再修改;
# 取消font.sans-serif前面的#号,将SimHei字体复制到matplotlib字体库文件夹下面后,并将SimHei添加到此语句中;
# plt.rcParams['axes.unicode_minus'] = False ,正常显示负号;
# 以后使用中文字体时就会默认使用SimHei字体,不会出现乱码了;

# 方法四:绘图时设置可选参数,推荐使用的一种方法:
import matplotlib.pyplot as plt
font = {'family' : 'STZhongsong',  # 字体名,可以直接使用系统字体;
        'weight' : 'light',        # 字体粗细;
        'size'   : 16}             # 字体大小（实测只接受数字）;
plt.rc('label', **font)
# 例如:
x = np.arange(-6.28,6.28,0.1)
y = 2*np.sin(x)
font = {'family' : 'STXingkai',
        'weight' : 122,
        'size'   : 16}
plt.title("测试案例",font) # 通过font参数设置标题为新楷体字体;
plt.xlabel("x轴")   
plt.ylabel("y轴")   
plt.plot(x,y)
plt.show()

'''matplotlib使用教程''' 
# 参考:https://www.runoob.com/w3cnote/matplotlib-tutorial.html

'''初级绘制'''
# 从简到繁：先尝试用默认配置在同一张图上绘制正弦和余弦函数图像，然后逐步美化它。

# 方法1.pyplot方法:
import numpy as np
import matplotlib.pyplot as plt
x = np.arange(-np.pi,np.pi,0.1)
s = np.sin(x)
c = np.cos(x)
plt.plot(x,c)
plt.plot(x,s)
plt.show()

# 方法2.pylab方法:
# 和matlab绘图类似,pylab提供了一种交互式绘图方法:逐步修改绘图样式实现不同的绘图效果:
from pylab import *  # pylab包含了matplotlib及numpy的许多常用函数,但如后可以直接交互使用,numpy直接可以以np的名字来使用:
# 创建一个10*6的点图,并设置分辨率为80,即800*480大小的图:
x = np.arange(-np.pi,np.pi,0.1)
s = np.sin(x)
c = np.cos(x)
figure(figsize = (10,6),dpi = 80)
# 创建一个1*1的子图,接下来的图样绘制在其中的第一块,也是唯一的一块:
subplot(1,1,1)
# 绘制余弦曲线,使用蓝色\连续\宽度为1像素的线条:
plot(x,c,color = "blue",linewidth = 1.0,linestyle = "-")
# 绘制正弦曲线,使用绿色\连续\宽度为1像素的线条:
plot(x,s,color = "green",linewidth = 1.0,linestyle = "-")
# 设置横轴的上下限为(-4,4):
xlim(-4.0,4.0)
# 设置横轴记号:
xticks(np.linspace(-4,4,9,endpoint = True))
# 设置y轴的上下限为(-1,1):
ylim(-1.0,1.0)
# 设置y轴记号:
yticks(np.linspace(-1,1,5,endpoint = True))
# 以分辨率72来保存图片:
savefig("ecercise1.png",dpi = 72)
# 在屏幕上显示:
show()

# 逐步修改各属性:
# 改变线条的颜色和粗细:
plot(x,c,color = 'blue',linewidth = 2.5,linestyle = '-')
plot(x,s,color = 'red',linewidth = 2.5,linestyle = '-')
# 设置图片边界:
xmin,xmax = x.min(),x.max()
ymin,ymax = s.min(),s.max()
dx = (xmax - xmin) * 0.2
dy = (ymax - ymin) * 0.2
xlim(xmin - dx,xmax + dx)
ylim(ymin - dy,ymax + dy)
# 设置特殊刻度:
xticks([-np.pi,-np.pi/2,0,np.pi/2,np.pi])
yticks([-1,0,1])
# Latex格式的特殊刻度:
xticks([-np.pi,-np.pi/2,0,np.pi/2,np.pi],
   [ r'$-\pi$',r'$-\pi/2$',r'$0$',r'$+\pi/2$',r'$+\pi$'])
yticks([-1,0,1],
    [r'$-1$',r'$0$',r'$+1$'])
# 移动坐标轴:
ax = gca()
ax.spines['right'].set_color('none')        # 右侧坐标轴不显示;
ax.spines['top'].set_color('none')           # 上边坐标轴不显示;
ax.xaxis.set_ticks_position('bottom')        # 刻度线显示在x坐标轴的下方;
ax.spines['bottom'].set_position(('data',0)) # 下方的x轴上移到y轴的0点;
ax.xaxis.set_ticks_position('bottom')        # 刻度线显示在y坐标轴的左侧;
ax.spines['left'].set_position(('data',0))   # 左侧的y轴右移到x轴的0点;
# 添加图例:
plot(x,c,color = 'blue',linewidth = 2.5,linestyle = '-',label = 'cos')
plot(x,s,color = 'red',linewidth = 2.5,linestyle = '-',label = 'sin')
legend(loc = 'upper left')
# 给一些特殊点做注释:
t = 2*np.pi/3
plot([t,t],[0,np.cos(t)],color = 'blue',linewidth = 2.5,linestyle = '--')                               # 画(t,0)到(t,cos(2/3*pi))的线段;
scatter([t,],[np.cos(t),],50,color = 'blue')    # 画一个点(t,cos(2/3*pi));

annotate(r'$\sin(\frac{2\pi}{3})=\frac{\sqrt{3}}{2}$',
    xy = (t,np.sin(t)),xycoords = 'data',
    xytext = (+10,+30),textcoords = 'offset points',fontsize = 16,
    arrowprops = dict(arrowstyle = '->',connectionstyle = 'arc3,rad=.2'))

plot([t,t],[0,np.sin(t)], color ='red', linewidth=2.5, linestyle="--")
scatter([t,],[np.sin(t),], 50, color ='red')

annotate(r'$\cos(\frac{2\pi}{3})=-\frac{1}{2}$',
         xy=(t, np.cos(t)), xycoords='data',
         xytext=(-90, -50), textcoords='offset points', fontsize=16,
         arrowprops=dict(arrowstyle="->", connectionstyle="arc3,rad=.2"))

show()

import pylab # 和上面导入模块方法的区别,相对导入,使用时前面加上pylab.信息;
import numpy as np
