import numpy as np
from numpy.lib.function_base import gradient

m = 20

x0 = np.ones((m,1))
x1 = np.arange(1,m+1).reshape(m,1)
x = np.hstack((x0,x1))

y = np.array([
    3,4,5,5,2,4,7,8,11,8,12,\
    11,13,13,16,17,18,17,19,21]).reshape(m,1)

alpha = 0.01

# 定义损失函数
def error_function(theta,x,y):
    diff = np.dot(x,theta) - y
    return (1/2*m)*np.dot(np.transpose(diff),diff)

# 定义梯度
def gradient_function(theta,x,y):
    diff = np.dot(x,theta) - y
    return (1/m)*np.dot(np.transpose(x),diff)

# 梯度下降迭代计算
def gradient_descent(x,y,alpha):
    theta = np.array([1,1]).reshape(2,1)
    gradient = gradient_function(theta,x,y)
    while not np.all(np.absolute(gradient)<=1e-5):
        theta = theta - alpha*gradient
        gradient = gradient_function(theta,x,y)
        return theta

optimal = gradient_descent(x,y,alpha)
print('optimal:',optimal)
print('error function:',error_function(optimal,x,y)[0,0])


