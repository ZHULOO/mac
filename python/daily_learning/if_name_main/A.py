a = 100

print('你好，我是模块A……')
print('模块A中__name__的值：{}'.format(__name__))
print('-------------------------')

if __name__=='__main__': # 只有当前模块正在被执行，而不是导入到其他模块的时候，才执行一下语句：
    print(a)
    print(__name__)