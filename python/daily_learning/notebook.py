#%%
import requests
r=requests.get("http://www.baidu.com")
print(r.status_code)
print(r.encoding)
print(r.apparent_encoding)


#%%
import matplotlib.pyplot as plt
import numpy as np

x = np.linspace(0, 20, 100)  # Create a list of evenly-spaced numbers over the range
plt.plot(x, np.sin(x))       # Plot the sine of each x point
plt.show()  


#%%
def func4(a,b):                 # 需传两个参数
    return (a+b)                # return a+b 的值
print(func4(1,2))


#%%
def name(a,b,c):
    return (a*b*c)
name(2,3,4)

#%%
