# 5，调用端口 使用flask库创建接口
1 from flask import Flask
 2 import Db
 3
 4 app = Flask(__name__)
 5
 6 @app.route('/', methods=['GET'])
 7 def home():
 8     return 'What is?'
 9
10 @app.route('/get', methods=['GET'])
11 def homsse():
12     return Db.app_ip()
13 #线程池数量
14 @app.route('/count', methods=['GET'])
15 def homsssse():
16     return str(Db.len_ip())
17 app.run(debug=True)