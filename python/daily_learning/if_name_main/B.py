import A # A被导入B时,if下面的语句就不执行了,只执行if上面的语句;如果单独运行A时,A中所有语句都执行;

b = 200

print('你好，我是模块B……')
print('模块B中__name__的值：{}'.format(__name__))
print(__name__)
print(b)