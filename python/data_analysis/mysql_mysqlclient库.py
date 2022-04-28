'''
常见的Mysql驱动介绍：
mysql-python：也就是MySQLdb。是对C语言操作MySQL数据库的一个简单封装。遵循了Python DB API v2。但是只支持Python2，目前还不支持Python3。

SQLite:python内置的驱动,支持python3

mysqlclient：是mysql-python的另外一个分支。支持Python3并且修复了一些bug。

pymysql：纯Python实现的一个驱动。因为是纯Python编写的，因此执行效率不如MySQL-python。并且也因为是纯Python编写的，因此可以和Python代码无缝衔接,支持python3.

MySQL-Connector：MySQL官方推出的使用纯Python连接MySQL的驱动。因为是纯Python开发的。效率不高。

最终，我选择了mysqlclient。mysqlclient安装非常简单。只需要通过pip install mysqlclient即可安装。
————————————————
原文链接：https://blog.csdn.net/cn_1937/article/details/81533544
'''
# python内置的SQLite
import sqlite3

# python 3.x不再适用mysql-python而与之功能相对应的是pymysql,如下安装:
conda install pymysql
import pymysql

# 或者mysql官方提供的mysql-connector,未提供conda安装,可以用pip安装:
pip install mysql-connector
import mysql.connector

# mysqlclient安装:(比较起来mysqlclient最快)
conda install mysqlclient # 或者 
pip install mysqlclient
import MySQLdb

'''MySQL'''
### DOS登录:
mysql -h localhost -u root -p z#+=75872158
status         # 查看MySQL版本基本信息;
ctrl+z         # 退出;
### 数据库\表\字段等操作:
show databases; # 显示当前的数据库列表,显示如下;
+--------------------+
| Database           |
+--------------------+
| information_schema | # 主要存储了系统中的一些数据库对象信息，比如用户表信息、列信息、权限信息、字符集信息和分区信息等。
| mysql              | # MySQL 的核心数据库，类似于 SQL Server 中的 master 表，主要负责存储数据库用户、用户访问权限等 MySQL 自己需要使用的控制和管理信息。常用的比如在 mysql 数据库的 user 表中修改 root 用户密码。
| performance_schema | # 主要用于收集数据库服务器性能参数。
| sakila             | # MySQL 提供的样例数据库，该数据库共有 16 张表，这些数据表都是比较常见的，在设计数据库时，可以参照这些样例数据表来快速完成所需的数据表。
| sys                | # sys 数据库主要提供了一些视图，数据都来自于 performation_schema，主要是让开发者和使用者更方便地查看性能问题。
| world              | # world 数据库是 MySQL 自动创建的数据库，该数据库中只包括 3 张数据表，分别保存城市，国家和国家使用的语言等内容。
+--------------------+
\help          # 查看帮助信息
\c             # 清除前面的命令
CREATE DATABASE test_db; # 创建test_db数据库;
CREATE DATABASE IF NOT EXISTS test_db; # if语句避免已经存在创建错误的出现;

CREATE DATABASE IF NOT EXISTS test_db_char
DEFAULT CHARACTER SET utf8
DEFAULT COLLATE utf8_chinese_ci;       # 创建指定字符集的数据库;
# LIKE语句,匹配指定的数据库名称。LIKE 从句可以部分匹配，也可以完全匹配。
# 数据库名由单引号' '包围。
SHOW DATABASES LIKE 'test_db';         # 显示数据库test_db;
SHOW DATABASES LIKE '%test%';          # 显示数据库包含test;
SHOW DATABASES LIKE 'test%';           # 显示数据库以test开头;
SHOW DATABASES LIKE '%test';           # 显示数据库以test结尾;

# ALTER DATABASE 来修改已经被创建或者存在的数据库的相关参数。修改数据库的语法格式为：
ALTER DATABASE [数据库名] { 
[ DEFAULT ] CHARACTER SET <字符集名> |
[ DEFAULT ] COLLATE <校对规则名>}
# 语法说明如下：
# ALTER DATABASE 用于更改数据库的全局特性。
# 使用 ALTER DATABASE 需要获得数据库 ALTER 权限。
# 数据库名称可以忽略，此时语句对应于默认数据库。
# CHARACTER SET 子句用于更改默认的数据库字符集。
CREATE DATABASE test_db
DEFAULT CHARACTER SET gb2312
DEFAULT COLLATE gb2312_chinese_ci; 
SHOW CREATE DATABASE test_db; 

# 删除已创建的数据库:
DROP DATABASE IF EXISTS test_db; 
# IF EXISTS语句可以防止删除无此数据库的错误;

# 指定某个数据库未当前数据库:
USE test_db; 

# 查看系统所支持的存储引擎:
SHOW ENGINES; 
# 不同存储引擎及使用原则:
功能	  MylSAM	MEMORY	InnoDB	Archive
存储限制	256TB	  RAM	 64TB	  None
支持事务	 No	      No	 Yes	  No
支持全文索引 Yes	  No	  No	  No
支持树索引	 Yes	  Yes	  Yes	  No
支持哈希索引  No	  Yes	  No	  No
支持数据缓存  No	  N/A	  Yes	  No
支持外键	  No	  No	  Yes	  No
可以根据以下的原则来选择 MySQL 存储引擎：
如果要提供提交、回滚和恢复的事务安全（ACID 兼容）能力，并要求实现并发控制，InnoDB 是一个很好的选择。
如果数据表主要用来插入和查询记录，则 MyISAM 引擎提供较高的处理效率。
如果只是临时存放数据，数据量不大，并且不需要较高的数据安全性，可以选择将数据保存在内存的 MEMORY 引擎中，MySQL 中使用该引擎作为临时表，存放查询的中间结果。
如果只有 INSERT 和 SELECT 操作，可以选择Archive 引擎，Archive 存储引擎支持高并发的插入操作，但是本身并不是事务安全的。Archive 存储引擎非常适合存储归档数据，如记录日志信息可以使用 Archive 引擎。
提示：使用哪一种引擎要根据需要灵活选择，一个数据库中多个表可以使用不同的引擎以满足各种性能和实际需求。使用合适的存储引擎将会提高整个数据库的性能。

# 使用下面的语句可以修改数据库临时的默认存储引擎
SET default_storage_engine=< 存储引擎名 >


# MySQL 常见数据类型
在 MySQL 中常见的数据类型如下：
1) 整数类型
包括 TINYINT、SMALLINT、MEDIUMINT、INT、BIGINT，浮点数类型 FLOAT 和 DOUBLE，定点数类型 DECIMAL。
2) 日期/时间类型
包括 YEAR、TIME、DATE、DATETIME 和 TIMESTAMP。
3) 字符串类型
包括 CHAR、VARCHAR、BINARY、VARBINARY、BLOB、TEXT、ENUM 和 SET 等。
4) 二进制类型
包括 BIT、BINARY、VARBINARY、TINYBLOB、BLOB、MEDIUMBLOB 和 LONGBLOB。

# 创建数据表:在已创建的数据库中建立新表:
USE test_db; # 先选择要创建表的数据库test_db;
CREATE TABLE tb_emp1(
    id INT(11),
    name VARCHAR(25),
    deptTd INT(11),
    salary FLOAT); 

SHOW TABLES;      # 查看上面建立的的数据表;
DESCRIBE tb_emp1; # 查看表结构;
+--------+-------------+------+-----+---------+-------+
| Field  | Type        | Null | Key | Default | Extra |
+--------+-------------+------+-----+---------+-------+
| id     | int(11)     | YES  |     | NULL    |       |
| name   | varchar(25) | YES  |     | NULL    |       |
| deptTd | int(11)     | YES  |     | NULL    |       |
| salary | float       | YES  |     | NULL    |       |
+--------+-------------+------+-----+---------+-------+
Null：表示该列是否可以存储 NULL 值。
Key：表示该列是否已编制索引。PRI 表示该列是表主键的一部分，UNI 表示该列是 UNIQUE 索引的一部分，MUL 表示在列中某个给定值允许出现多次。
Default：表示该列是否有默认值，如果有，值是多少。
Extra：表示可以获取的与给定列有关的附加信息，如 AUTO_INCREMENT 等。

# 使用 SHOW CREATE TABLE 语句不仅可以查看创建表时的详细语句，而且可以查看存储引擎和字符编码。如果不加“\G”参数，显示的结果可能非常混乱，加上“\G”参数之后，可使显示的结果更加直观，易于查看。
SHOW CREATE TABLE tb_emp1\G

# ALTER TABLE 语句来改变原有表的结构，例如增加或删减列、创建或取消索引、更改原有列类型、重新命名列或表等。
ALTER TABLE <表名> [修改选项]
# 修改选项的语法格式如下：
{ ADD COLUMN <列名> <类型>
| CHANGE COLUMN <旧列名> <新列名> <新列类型>
| ALTER COLUMN <列名> { SET DEFAULT <默认值> | DROP DEFAULT }
| MODIFY COLUMN <列名> <类型>
| DROP COLUMN <列名>
| RENAME TO <新表名> }
# 随着业务的变化，可能需要在已经存在的表中添加新的字段，一个完整的字段包括字段名、数据类型、完整性约束。添加字段的语法格式如下：
ALTER TABLE <表名> ADD <新字段名> <数据类型> [约束条件] [FIRST|AFTER 已存在的字段名]；
# 新字段名为需要添加的字段的名称；FIRST 为可选参数，其作用是将新添加的字段设置为表的第一个字段；AFTER 为可选参数，其作用是将新添加的字段添加到指定的已存在的字段名的后面。
ALTER TABLE tb_emp1
ADD COLUMN col1 INT FIRST; # 在表的第一列添加一个 int 类型的字段 col1;
# 提示：“FIRST 或 AFTER 已存在的字段名”用于指定新增字段在表中的位置，如果 SQL 语句中没有这两个参数，则默认将新添加的字段设置为数据表的最后列。
ALTER TABLE tb_emp1
ADD COLUMN col2 INT AFTER name; # 在一列 name 后添加一个 int 类型的字段 col;

# 修改字段数据类型:
ALTER TABLE <表名> MODIFY <字段名> <数据类型>
ALTER TABLE tb_emp1
MODIFY name VARCHAR(30); # 将name字段的数据类型由VARCHAR(22)修改为VARCHAR(30);
# 删除字段:
ALTER TABLE <表名> DROP <字段名>；
ALTER TABLE tb_emp1
DROP col2; # 删除字段col2;
# 修改字段名称:
ALTER TABLE <表名> CHANGE <旧字段名> <新字段名> <新数据类型>；
ALTER TABLE tb_emp1
CHANGE col1 col3 CHAR(30); # 修改字段名称col1为col3,同时将数据类型修改为CHAR(30);
# 修改表名:
ALTER TABLE <旧表名> RENAME [TO] <新表名>；
ALTER TABLE tb_emp1
RENAME TO tb_emp2; # 修改表名为tb_emp2,TO为可选参数,使用与否不影响结果;
# 删除数据表:
DROP TABLE [IF EXISTS] <表名> [ , <表名1> , <表名2>] …
DROP TABLE tb_emp1; 

# 主键设置:
## 主键约束是一个列或列的组合,其值能唯一地标识表中的每一行.这样的一列或多列称为表的主键,通过它可以强制表的实体完整性.
## 主键可以是表的一列或者多列的组合,其中多列组合的主键称为复合主键,主键应该遵循以下规则:
### 每个表只能定义一个主键;
### 主键值必须唯一地标识表中每一行,且不能为NULL,即表中不可能存在两行数据有相同的主键值,这是唯一性的原则;
### 一个列名只能在复合主键列表中出现一次;
### 符合主键不能包含不必要的多于列.即当符合主键的某一列删除后,如果剩下的列构成的主键仍然满足唯一性原则,那么这个符合主键是不正确的,这是最小化原则;

# 创建表时设置主键约束:
<字段名> <数据类型> PRIMARY KEY [默认值]
CREATE TABLE tb_emp1
(
    id INT(11) PRIMARY KEY); # 主键通过 PRIMARY KEY关键字来指定的。

## 定义完所有列之后,指定主键的语法格式:
[CONSTRAINT <约束名>] PRIMARY KEY [字段名]
CREATE TABLE tb_emp1
(
    id INT(11), 
    PRIMARY KEY(id)); # 主键通过PRIMARY KEY(id)来指定的。

## 创建表时设置复合主键:
PRIMARY KEY [字段1，字段2，…,字段n]
PRIMARY KEY(id,deptId) #设置id,deptId为复合主键;
## 在修改表时添加主键:
ALTER TABLE <数据表名> ADD PRIMARY KEY(<列名>); 
ALTER TABLE tb_emp2
ADD PRIMARY KEY(id); 

# 设置外键约束:
## 1外键约束是用来在两个表的数据之间建立链接,它可以是一列或多列,一个表可以有一个或多个外键;
## 2外键对应的是参照完整性，一个表的外键可以为空值，若不为空值，则每一个外键的值必须等于另一个表中主键的某个值。
## 3外键是表的一个字段，不是本表的主键，但对应另一个表的主键。定义外键后，不允许删除另一个表中具有关联关系的行。
## 4外键的主要作用是保持数据的一致性、完整性。例如，部门表 tb_dept 的主键是 id，在员工表 tb_emp5 中有一个键 deptId 与这个 id 关联。
## 5主表（父表）：对于两个具有关联关系的表而言，相关联字段中主键所在的表就是主表。
## 6从表（子表）：对于两个具有关联关系的表而言，相关联字段中外键所在的表就是从表。

# 选取设置MySQL外键约束的字段:
## 定义一个外键时，需要遵守下列规则：
### 3父表必须已经存在于数据库中，或者是当前正在创建的表。如果是后一种情况，则父表与子表是同一个表，这样的表称为自参照表，这种结构称为自参照完整性。
### 4必须为父表定义主键。
### 5主键不能包含空值，但允许在外键中出现空值。也就是说，只要外键的每个非空值出现在指定的主键中，这个外键的内容就是正确的。
### 6在父表的表名后面指定列名或列名的组合。这个列或列的组合必须是父表的主键或候选键。
### 7外键中列的数目必须和父表的主键中列的数目相同。
### 8外键中列的数据类型必须和父表主键中对应列的数据类型相同。

# 创建表时设置外键约束的命令:
[CONSTRAINT <外键名>] FOREIGN KEY 字段名 [，字段名2，…]
REFERENCES <主表名> 主键列1 [，主键列2，…]
## 实例:
CREATE TABLE tb_dept1
(
    id INT(11) PRIMARY KEY, # 主键 
    name VARCHAR(22) NOT NULL,
    location VARCHAR(50)); 
## 设置外键:
CREATE TABLE tb_emp6
(
    id INT(11) PRIMARY KEY, # 主键
    name VARCHAR(25),
    deptId INT(11),
    salary FLOAT,
    CONSTRAINT fk_emp_dept1 # 设置外键fk_emp_dept1,本表的deptId和tb_dept1表中的id关联;
    FOREIGN KEY(deptId) REFERENCES tb_dept1(id)); 
DESC tb_emp6; # 查看表格情况;

# 修改表时添加外键约束的命令:
ALTER TABLE <数据表名> ADD CONSTRAINT <索引名>
FOREIGN KEY(<列名>) REFERENCES <主表名> (<列名>); 
## 实例:
ALTER TABLE tb_emp2
ADD CONSTRAINT fk_emp_dept1
FOREIGN KEY(deptId)
REFERENCES tb_emp1(id); 

# 删除外键约束:
ALTER TABLE <表名> DROP FOREIGN KEY <外键约束名>; 
## 实例:
ALTER TABLE tb_emp2
DROP FOREIGN KEY fk_emp_dept1; 

# 创建表时设置唯一约束:字段取值必须唯一;
CREATE TABLE tb_emp2
(
    name VARCHAR(22) UNIQUE); 
# 提示：UNIQUE 和 PRIMARY KEY 的区别：一个表可以有多个字段声明为 UNIQUE，但只能有一个 PRIMARY KEY 声明；声明为 PRIMAY KEY 的列不允许有空值，但是声明为 UNIQUE 的字段允许空值的存在。

# 在修改表时添加唯一约束:
ALTER TABLE <数据表名> ADD CONSTRAINT <唯一约束名> UNIQUE(<列名>); 
## 实例:
ALTER TABLE tb_dept1
ADD CONSTRAINT unique_name UNIQUE(name); 
DESC tb_emp2

# 删除唯一约束:
ALTER TABLE <表名> DROP INDEX <唯一约束名>; 
## 实例:
ALTER TABLE tb_emp2
DROP INDEX unique_name; 

# 设置检查约束字段:
CHECK <表达式> 
## 注意：若将 CHECK 约束子句置于所有列的定义以及主键约束和外键定义之后，则这种约束也称为基于表的 CHECK 约束。该约束可以同时对表中多个列设置限定条件。

# 在创建表时设置检查约束:
CREATE TABLE tb_emp7
(
    id INT(11) PRIMARY KEY,
    name VARCHAR(25),
    deptId INT(11),
    salary FLOAT,
    CHECK(salary>0 AND salary<100), # 设置检查约束,要求salary字段值大于0小于100;
    FOREIGN KEY(deptId) REFERENCES tb_dept1(id)); 
# 在修改表时添加检查约束:
ALTER TABLE tb_emp7 ADD CONSTRAINT <检查约束名> CHECK(<检查约束>); 
## 实例:
ALTER TABLE tb_emp7
ADD CONSTRAINT check_id
CHECK(id>0); # 修改时添加约束要求id字段值大于0;
# 删除检查约束:
ALTER TABLE <数据表名> DROP CONSTRAINT <检查约束名>; 

# 默认值约束:字段默认取值,如果没有赋值,该字段就取默认值;
## 在创建表时设置默认值约束:
<字段名> <数据类型> DEFAULT <默认值>; 
location VARCHAR(50) DEFAULT 'Beijing'  # location字段默认值为Beijing;
## 在修改表时添加默认值约束:
ALTER TABLE <数据表名>
CHANGE COLUMN <字段名> <数据类型> DEFAULT <默认值>; 
### 实例:
ALTER TABLE tb_dept3
CHANGE COLUMN location
location VARCHAR(50) DEFAULT 'Shanghai'; # 修改location默认值为Shanghai;
## 删除默认值:
ALTER TABLE <数据表名>
CHANGE COLUMN <字段名> <字段名> <数据类型> DEFAULT NULL;
### 实例:
ALTER TABLE tb_dept3
CHANGE COLUMN location
location VARCHAR(50) DEFAULT NULL; # 修改为NULL就相当于删除默认值;

# 设置非空约束(NOT NULL):指定字段不能为空;
## 创建表时设置非空约束:
<字段名> <数据类型> NOT NULL; 
### 实例:
CREATE TABLE tb_dept4
(
    id INT(11) PRIMARY KEY,
    name VARCHAR(22) NOT NULL, # 非空约束;
    location VARCHAR(50)); 
## 修改表时添加非空约束:
ALTER TABLE <数据表名>
CHANGE COLUMN <字段名>
<字段名> <数据类型> NOT NULL; 
### 实例:
ALTER TABLE tb_dept4
CHANGE COLUMN location
location VARCHAR(50) NOT NULL; 
## 删除非空约束:
ALTER TABLE <数据表名>
CHANGE COLUMN <字段名> <字段名> <数据类型> NULL; 
### 实例:
ALTER TABLE tb_dept4
CHANGE COLUMN location
location VARCHAR(50) NULL; # 删除location的非空约束;

# 查看表中的约束:
SHOW CREATE TABLE <数据表名>; 
SHOW CREATE TABLE tb_emp8 \G; 

# 数据表单查询语句:从一张表的数据中查询所需的数据，主要有查询所有字段、查询指定字段、查询指定记录、查询空值、多条件的查询、对查询结果进行排序等。
SELECT
{* | <字段列名>}
[
FROM <表 1>, <表 2>…
[WHERE <表达式>
[GROUP BY <group by definition>
[HAVING <expression> [{<operator> <expression>}…]]
[ORDER BY <order by definition>]
[LIMIT[<offset>,] <row count>]
]
## 其中，各条子句的含义如下：
### 1{*|<字段列名>}包含星号通配符的字段列表，表示查询的字段，其中字段列至少包含一个字段名称，如果要查询多个字段，多个字段之间要用逗号隔开，最后一个字段后不要加逗号。
### 2FROM <表 1>，<表 2>…，表 1 和表 2 表示查询数据的来源，可以是单个或多个。
### 3WHERE 子句是可选项，如果选择该项，将限定查询行必须满足的查询条件。
### 4GROUP BY< 字段 >，该子句告诉 MySQL 如何显示查询出来的数据，并按照指定的字段分组。
### 5[ORDER BY< 字段 >]，该子句告诉 MySQL 按什么样的顺序显示查询出来的数据，可以进行的排序有升序（ASC）和降序（DESC）。
### 6[LIMIT[<offset>，]<row count>]，该子句告诉 MySQL 每次显示查询出来的数据条数。

# 使用“*”查询表中的全部内容:
SELECT * FROM 表名;
SELECT * FROM tb_emp1;
## 注意：一般情况下，除非需要使用表中所有的字段数据，否则最好不要使用通配符“*”。使用通配符虽然可以节省输入查询语句的时间，但是获取不需要的列数据通常会降低查询和所使用的应用程序的效率。通配符的优势是，当不知道所需列的名称时，可以通过通配符获取它们。
# 查询表中指定的字段:
SELECT < 列名 > FROM < 表名 >;
SELECT <字段名1>,<字段名2>,…,<字段名n> FROM <表名>;
SELECT id,name,deptId FROM tb_emp1;
# DISTINCT：去重（过滤重复数据:
SELECT DISTINCT <字段名> FROM <表名>;
SELECT DISTINCT name,age FROM tb_emp1;

# 设置别名:当表名很长或者执行一些特殊查询的时候，为了方便操作或者需要多次使用相同的表时，可以为表指定别名，用这个别名代替表原来的名称。
## 为表设置别名:
<表名> [AS] <别名> 
### 实例:
SELECT stu.name,stu.height
FROM tb_students_info AS stu;
## 为字段设置别名:
<列名> [AS] <列别名>
### 实例:
SELECT name AS student_name,
age AS student_age
FROM tb_students_info;

# 限制查询结果的记录条数:SELECT 语句时往往返回的是所有匹配的行，有些时候我们仅需要返回第一行或者前几行，这时候就需要用到 MySQL LIMT 子句。
<LIMIT> [<位置偏移量>,] <行数> 
## LIMIT 接受一个或两个数字参数。参数必须是一个整数常量。如果给定两个参数，第一个参数指定第一个返回记录行的偏移量，第二个参数指定返回记录行的最大数目。
## 第一个参数“位置偏移量”指示 MySQL 从哪一行开始显示，是一个可选参数，如果不指定“位置偏移量”，将会从表中的第一条记录开始（第一条记录的位置偏移量是 0，第二条记录的位置偏移量是 1，以此类推）；第二个参数“行数”指示返回的记录条数。
### 实例:
SELECT * FROM tb_students_info LIMIT 4;
SELECT * FROM tb_students_info LIMIT 3,5; # 位置偏移量为3,从第四条记录开始,返回5行记录;

# 对查询结果进行排序:SELECT 语句中，ORDER BY 子句主要用来将结果集中的数据按照一定的顺序进行排序。
ORDER BY {<列名> | <表达式> | <位置>} [ASC|DESC]
## 语法说明如下。
### 1) 列名
### 指定用于排序的列。可以指定多个列，列名之间用逗号分隔。
### 2) 表达式
### 指定用于排序的表达式。
### 3) 位置
### 指定用于排序的列在 SELECT 语句结果集中的位置，通常是一个正整数。
### 4) ASC|DESC
### 关键字 ASC 表示按升序分组，关键字 DESC 表示按降序分组，其中 ASC 为默认值。这两个关键字必须位于对应的列名、表达式、列的位置之后。
## 使用 ORDER BY 子句应该注意以下几个方面：
### ORDER BY 子句中可以包含子查询。
### 当排序的值中存在空值时，ORDER BY 子句会将该空值作为最小值来对待。
### 当在 ORDER BY 子句中指定多个列进行排序时，MySQL 会按照列的顺序从左到右依次进行排序。
### 查询的数据并没有以一种特定的顺序显示，如果没有对它们进行排序，则将根据插入到数据表中的顺序显示。使用 ORDER BY 子句对指定的列数据进行排序。
### 实例:
SELECT * FROM tb_students_info ORDER BY height;
SELECT name,height FROM tb_students_info ORDER BY height,name;
#### 注意：在对多列进行排序时，首行排序的第一列必须有相同的列值，才会对第二列进行排序。如果第一列数据中所有的值都是唯一的，将不再对第二列进行排序。
SELECT name,height FROM tb_student_info ORDER BY height DESC,name ASC; 
#### 先按height降序排序,再按name升序排序;DESC 关键字只对前面的列进行降序排列，在这里只对 height 排序，而并没有对 name 进行排序，因此，height 按降序排序，而 name 仍按升序排序，如果要对多列进行降序排序，必须要在每一列的后面加 DESC 关键字。

# 条件查询:使用 WHERE 子句来指定查询条件，从 FROM 子句的中间结果中选取适当的数据行，达到数据过滤的效果。
# 语法格式如下：
WHERE <查询条件> {<判定运算1>，<判定运算2>，…}
## 其中，判定运算其结果取值为 TRUE、FALSE 和 UNKNOWN。
## 判定运算的语法分类如下：
### <表达式1>{=|<|<=|>|>=|<=>|<>|！=}<表达式2>
### <表达式1>[NOT]LIKE<表达式2>
### <表达式1>[NOT][REGEXP|RLIKE]<表达式2>
### <表达式1>[NOT]BETWEEN<表达式2>AND<表达式3>
### <表达式1>IS[NOT]NULL
# 单一条件的查询语句:
SELECT name,height FROM tb_students_info WHERE height=170; 
SELECT name,age FROM tb_students_info WHERE age<22;
# 多条件查询语句:在 WHERE 子句中使用 AND 操作符限定只有满足所有查询条件的记录才会被返回。
SELECT * FROM tb_students_info WHERE age>21 AND height>=175;
# 使用LIKE的模糊查询:
<表达式1> [NOT] LIKE <表达式2>
# MySQL支持的通配符有以下两种：
## 1) 百分号（%）
## 百分号是 MySQL 中常用的一种通配符，在过滤条件中，百分号可以表示任何字符串，并且该字符串可以出现任意次。
## 使用百分号通配符要注意以下几点：
## MySQL 默认是不区分大小写的，若要区分大小写，则需要更换字符集的校对规则。
## 百分号不匹配空值。
## 百分号可以代表搜索模式中给定位置的 0 个、1 个或多个字符。
## 尾空格可能会干扰通配符的匹配，一般可以在搜索模式的最后附加一个百分号。
## 2) 下划线（_）
## 下划线通配符和百分号通配符的用途一样，下画线只匹配单个字符，而不是多个字符，也不是 0 个字符。
## 注意：不要过度使用通配符，对通配符检索的处理一般会比其他检索方式花费更长的时间。
### 实例:
SELECT name FROM tb_students_info WHERE name LIKE 'T%';    # 查找所有以“T”字母开头的学生姓名;
SELECT name FROM tb_students_info WHERE name LIKE '%e%';   # 查找所有包含“e”字母的学生姓名，
SELECT name FROM tb_students_info WHERE name LIKE '____y'; # 查找所有以字母“y”结尾，且“y”前面只有 4 个字母的学生的姓名，

# 日期字段作为条件的查询语句:
SELECT * FROM tb_students_info WHERE login_date<'2016-01-01';
SELECT * FROM tb_students_info WHERE login_date BETWEEN '2015-10-01' AND '2016-05-01';

# 常用运算符详解:
## MySQL 支持 4 种运算符，分别是：
## 1) 算术运算符
## 执行算术运算，例如：加、减、乘、除等。
算术运算符	 说明
+	        加法运算
-	        减法运算
*	        乘法运算
/	        除法运算，返回商
%	        求余运算，返回余数
## 2) 比较运算符
## 包括大于、小于、等于或者不等于，等等。主要用于数值的比较、字符串的匹配等方面。例如：LIKE、IN、BETWEEN AND 和 IS NULL 等都是比较运算符，还包括正则表达式的 REGEXP 也是比较运算符。
比较运算符	         说明
=	                等于
<	                小于
<=	                小于等于
>	                大于
>=	                大于等于
<=>	                安全的等于，不会返回 UNKNOWN
<> 或!=	            不等于
IS NULL 或 ISNULL	判断一个值是否为 NULL
IS NOT NULL	        判断一个值是否不为 NULL
LEAST	            当有两个或多个参数时，返回最小值
GREATEST	        当有两个或多个参数时，返回最大值
BETWEEN AND	        判断一个值是否落在两个值之间
IN	                判断一个值是IN列表中的任意一个值
NOT IN	            判断一个值不是IN列表中的任意一个值
LIKE	            通配符匹配
REGEXP	            正则表达式匹配
## 3) 逻辑运算符
## 包括与、或、非和异或等逻辑运算符。其返回值为布尔型，真值（1 或 true）和假值（0 或 false）。
## 4) 位运算符
## 包括按位与、按位或、按位取反、按位异或、按位左移和按位右移等位运算符。位运算必须先将数据转换为二进制，然后在二进制格式下进行操作,运算完成后，将二进制的值转换为原来的类型，返回给用户。

# INNER JOIN：内连接查询,通过在查询中设置连接条件的方式，来移除查询结果集中某些数据行后的交叉连接。简单来说，就是利用条件表达式来消除交叉连接的某些数据行。
# FROM 子句中使用关键字 INNER JOIN 连接两张表，并使用 ON 子句来设置连接条件。如果没有任何条件，INNER JOIN 和 CROSS JOIN 在语法上是等同的，两者可以互换。
SELECT <列名1，列名2 …>
FROM <表名1> INNER JOIN <表名2> [ ON子句]
## 语法说明如下。
## <列名1，列名2…>：需要检索的列名。
## <表名1><表名2>：进行内连接的两张表的表名。
## 内连接是系统默认的表连接，所以在 FROM 子句后可以省略 INNER 关键字，只用关键字 JOIN。使用内连接后，FROM 子句中的 ON 子句可用来设置连接表的条件。
## 在 FROM 子句中可以在多个表之间连续使用 INNER JOIN 或 JOIN，如此可以同时实现多个表的内连接。
### 实例:
SELECT id,name,age,dept_name FROM tb_students_info,tb_departments WHERE tb_students_info.dept_id=tb_departments.dept_id;
### 提示：因为 tb_students_info 表和 tb_departments 表中有相同的字段 dept_id，所以在比较的时候，需要完全限定表名（格式为“表名.列名”），如果只给出 dept_id，MySQL 将不知道指的是哪一个，并返回错误信息。
SELECT id,name,age,dept_name FROM tb_students_info INNER JOIN tb_departments ON tb_students_info.dept_id=tb_departments.dept_id;
### 提示：使用 WHERE 子句定义连接条件比较简单明了，而 INNER JOIN 语法是 ANSI SQL 的标准规范，使用 INNER JOIN 连接语法能够确保不会忘记连接条件，而且 WHERE 子句在某些时候会影响查询的性能。

# LEFT/RIGHT JOIN：外连接查询:内连接是在交叉连接的结果集上返回满足条件的记录；而外连接先将连接的表分为基表和参考表，再以基表为依据返回满足和不满足条件的记录。
## 内连接是在交叉连接的结果集上返回满足条件的记录；而外连接先将连接的表分为基表和参考表，再以基表为依据返回满足和不满足条件的记录。
## 左外连接又称为左连接，在 FROM 子句中使用关键字 LEFT OUTER JOIN 或者 LEFT JOIN，用于接收该关键字左表（基表）的所有行，并用这些行与该关键字右表（参考表）中的行进行匹配，即匹配左表中的每一行及右表中符合条件的行。
## 在左外连接的结果集中，除了匹配的行之外，还包括左表中有但在右表中不匹配的行，对于这样的行，从右表中选择的列的值被设置为 NULL，即左外连接的结果集中的 NULL 值表示右表中没有找到与左表相符的记录。
SELECT name,dept_name FROM tb_students_info s LEFT OUTER JOIN tb_departments d ON s.dept_id = d.dept_id;
## 右外连接又称为右连接，在 FROM 子句中使用 RIGHT OUTER JOIN 或者 RIGHT JOIN。与左外连接相反，右外连接以右表为基表，连接方法和左外连接相同。在右外连接的结果集中，除了匹配的行外，还包括右表中有但在左表中不匹配的行，对于这样的行，从左表中选择的值被设置为 NULL。
SELECT name,dept_name FROM tb_students_info s RIGHT OUTER JOIN tb_departments d ON s.dept_id = d.dept_id;

# 子查询:在 SELECT 子句中先计算子查询，子查询结果作为外层另一个查询的过滤条件，查询可以基于一个表或者多个表。
## 子查询中常用的操作符有 ANY（SOME）、ALL、IN 和 EXISTS。
### 实例1:IN语句;
mysql> SELECT name FROM tb_students_info
    -> WHERE dept_id IN        # 根据下面子查询的结果:学院 ID 查询该学院学生的名字，
    -> (SELECT dept_id
    -> FROM tb_departments
    -> WHERE dept_type= 'A' ); # 在tb_departments表中查询dept_type为A的学院ID,
### 以上子查询可以看作以下两步:
mysql> SELECT dept_id
    -> FROM tb_departments
    -> WHERE dept_type='A';   # 符合条件的 dept_id 列的值有两个：1 和 2。
mysql> SELECT name FROM tb_students_info
    -> WHERE dept_id IN(1,2); # 在 tb_students_info 表中查询 dept_id 等于 1 或 2 的学生的名字。
### 实例2:NOT IN语句;
mysql> SELECT name FROM tb_students_info
    -> WHERE dept_id NOT IN  
    -> (SELECT dept_id
    -> FROM tb_departments
    -> WHERE dept_type='A'); # 提示：子查询的功能也可以通过连接查询完成，但是子查询使得 MySQL 代码更容易阅读和编写。
### 实例3:在 tb_departments 表中查询 dept_name 等于“Computer”的学院 id，然后在 tb_students_info 表中查询所有该学院的学生的姓名，
mysql> SELECT name FROM tb_students_info
    -> WHERE dept_id =
    -> (SELECT dept_id
    -> FROM tb_departments
    -> WHERE dept_name='Computer'); 
### 实例4:在 tb_departments 表中查询 dept_name 不等于“Computer”的学院 id，然后在 tb_students_info 表中查询所有该学院的学生的姓名，
mysql> SELECT name FROM tb_students_info
    -> WHERE dept_id <>
    -> (SELECT dept_id
    -> FROM tb_departments
    -> WHERE dept_name='Computer');
### 实例5:查询 tb_departments 表中是否存在 dept_id=1 的供应商，如果存在，就查询 tb_students_info 表中的记录，
mysql> SELECT * FROM tb_students_info
    -> WHERE EXISTS
    -> (SELECT dept_name
    -> FROM tb_departments
    -> WHERE dept_id=1);
### 实例6:查询 tb_departments 表中是否存在 dept_id=7 的供应商，如果存在，就查询 tb_students_info 表中的记录，
mysql> SELECT * FROM tb_students_info
    -> WHERE EXISTS
    -> (SELECT dept_name
    -> FROM tb_departments
    -> WHERE dept_id=7);

# GROUP BY：分组查询:将结果集中的数据行根据选择列的值进行逻辑分组，以便能汇总表内容的子集，实现对每个组而不是对整个结果集进行整合。
GROUP BY { <列名> | <表达式> | <位置> } [ASC | DESC]
## 实例:
mysql> SELECT dept_id,GROUP_CONCAT(name) AS names
    -> FROM tb_students_info
    -> GROUP BY dept_id;

# HAVING：指定过滤条件,HAVING 子句过滤分组，在结果集中规定了包含哪些分组和排除哪些分组。
## 实例:
mysql> SELECT dept_id,GROUP_CONCAT(name) AS names
    -> FROM tb_students_info
    -> GROUP BY dept_id
    -> HAVING COUNT(name)>1;

# 正则表达式查询:
## 实例:
mysql> SELECT * FROM tb_departments
    -> WHERE dept_name REGEXP '^C'; # REGEXP表示正则表达式,匹配以字母C开头的记录;

# INSERT：插入数据（添加数据）:使用 INSERT 语句向数据库已有的表中插入一行或者多行元组数据。
## 1) INSERT…VALUES语句:
INSERT VALUES 的语法格式为：
INSERT INTO <表名> [ <列名1> [ , … <列名n>] ]
VALUES (值1) [… , (值n) ];
### 实例:
mysql> INSERT INTO tb_courses
    -> (course_id,course_name,course_grade,course_info)
    -> VALUES(1,'Network',3,'Computer Network'); # INSERT 语句后面的列名称顺序可以不是 tb_courses 表定义时的顺序，即插入数据时，不需要按照表定义的顺序插入，只要保证值的顺序与列字段的顺序相同就可以。
mysql> INSERT INTO tb_courses
    -> VLAUES(3,'Java',4,'Java EE');
## 2) INSERT…SET语句:
语法格式为：
INSERT INTO <表名>
SET <列名1> = <值1>,
    <列名2> = <值2>,
## 3) 使用 INSERT INTO…FROM 语句复制表数据:
mysql> INSERT INTO tb_courses_new
    -> (course_id,course_name,course_grade,course_info)
    -> SELECT course_id,course_name,course_grade,course_info
    -> FROM tb_courses;

# UPDATE：修改数据（更新数据）:
UPDATE <表名> SET 字段 1=值 1 [,字段 2=值 2… ] [WHERE 子句 ]
[ORDER BY 子句] [LIMIT 子句]
## 实例:修改表中的数据
mysql> UPDATE tb_courses_new
    -> SET course_grade=4; # 更新所有行的 course_grade 字段值为 4
## 实例:根据条件修改表中的数据
mysql> UPDATE tb_courses_new
    -> SET course_name='DB',course_grade=3.5
    -> WHERE course_id=2;  # 更新 course_id 值为 2 的记录，将 course_grade 字段值改为 3.5，将 course_name 字段值改为“DB”

# DELETE：删除数据
## 删除单个表中的数据:
DELETE FROM <表名> [WHERE 子句] [ORDER BY 子句] [LIMIT 子句]
## 注意：在不使用 WHERE 条件的时候，将删除所有数据。
### 实例:删除表中全部数据:
mysql> DELETE FROM tb_courses_new;
### 实例:根据条件删除表中的数据:
mysql> DELETE FROM tb_courses
    -> WHERE course_id=4;

# 视图:
## 视图是一个虚拟表，其内容由查询定义。同真实表一样，视图包含一系列带有名称的列和行数据，但视图并不是数据库真实存储的数据表。

## 视图是从一个、多个表或者视图中导出的表，包含一系列带有名称的数据列和若干条数据行。

## 视图并不同于数据表，它们的区别在于以下几点：
### 视图不是数据库中真实的表，而是一张虚拟表，其结构和数据是建立在对数据中真实表的查询基础上的。
### 存储在数据库中的查询操作 SQL 语句定义了视图的内容，列数据和行数据来自于视图查询所引用的实际表，引用视图时动态生成这些数据。
### 视图没有实际的物理记录，不是以数据集的形式存储在数据库中的，它所对应的数据实际上是存储在视图所引用的真实表中的。
### 视图是数据的窗口，而表是内容。表是实际数据的存放单位，而视图只是以不同的显示方式展示数据，其数据来源还是实际表。
### 视图是查看数据表的一种方法，可以查询数据表中某些字段构成的数据，只是一些 SQL 语句的集合。从安全的角度来看，视图的数据安全性更高，使用视图的用户不接触数据表，不知道表结构。
### 视图的建立和删除只影响视图本身，不影响对应的基本表。

## 视图与表在本质上虽然不相同，但视图经过定义以后，结构形式和表一样，可以进行查询、修改、更新和删除等操作。同时，视图具有如下优点：
### 1) 定制用户数据，聚焦特定的数据
### 在实际的应用过程中，不同的用户可能对不同的数据有不同的要求。例如，当数据库同时存在时，如学生基本信息表、课程表和教师信息表等多种表同时存在时，可以根据需求让不同的用户使用各自的数据。学生查看修改自己基本信息的视图，安排课程人员查看修改课程表和教师信息的视图，教师查看学生信息和课程信息表的视图。
### 2) 简化数据操作
### 在使用查询时，很多时候要使用聚合函数，同时还要显示其他字段的信息，可能还需要关联到其他表，语句可能会很长，如果这个动作频繁发生的话，可以创建视图来简化操作。
### 3) 提高基表数据的安全性
### 视图是虚拟的，物理上是不存在的。可以只授予用户视图的权限，而不具体指定使用表的权限，来保护基础数据的安全。
### 4) 共享所需数据
### 通过使用视图，每个用户不必都定义和存储自己所需的数据，可以共享数据库中的数据，同样的数据只需要存储一次。
### 5) 更改数据格式
### 通过使用视图，可以重新格式化检索出的数据，并组织输出到其他应用程序中。
### 6) 重用 SQL 语句
### 视图提供的是对查询操作的封装，本身不包含数据，所呈现的数据是根据视图定义从基础表中检索出来的，如果基础表的数据新增或删除，视图呈现的也是更新后的数据。视图定义后，编写完所需的查询，可以方便地重用该视图。
### 注意：要区别视图和数据表的本质，即视图是基于真实表的一张虚拟的表，其数据来源均建立在真实表的基础上。

## 使用视图的时候，还应该注意以下几点：
### 创建视图需要足够的访问权限。
### 创建视图的数目没有限制。
### 视图可以嵌套，即从其他视图中检索数据的查询来创建视图。
### 视图不能索引，也不能有关联的触发器、默认值或规则。
### 视图可以和表一起使用。
### 视图不包含数据，所以每次使用视图时，都必须执行查询中所需的任何一个检索操作。如果用多个连接和过滤条件创建了复杂的视图或嵌套了视图，可能会发现系统运行性能下降得十分严重。因此，在部署大量视图应用时，应该进行系统测试。

## ORDER BY 子句可以用在视图中，但若该视图检索数据的 SELECT 语句中也含有 ORDER BY 子句，则该视图中的 ORDER BY 子句将被覆盖。

# 创建视图（CREATE VIEW）
CREATE VIEW <视图名> AS <SELECT语句>
## 创建基于单表的视图
### 实例1:在 tb_students_info 表上创建一个名为 view_students_info 的视图
mysql> CREATE VIEW view_students_info
    -> AS SELECT * FROM tb_students_info; 
### 实例2:在 tb_students_info 表上创建一个名为 v_students_info 的视图
mysql> CREATE VIEW v_students_info
    -> (s_id,s_name,d_id,s_age,s_sex,s_height,s_date)
    -> AS SELECT id,name,dept_id,age,sex,height,login_date
    -> FROM tb_students_info;
### 可以看到，view_students_info 和 v_students_info 两个视图中的字段名称不同，但是数据却相同。因此，在使用视图时，可能用户不需要了解基本表的结构，更接触不到实际表中的数据，从而保证了数据库的安全。
## 创建基于多表的视图
### 实例:在表 tb_student_info 和表 tb_departments 上创建视图 v_students_info
mysql> CREATE VIEW v_students_info
    -> (s_id,s_name,d_id,s_age,s_sex,s_height,s_date)
    -> AS SELECT id,name,dept_id,age,sex,height,login_date
    -> FROM tb_students_info;
## 查询视图:
DESCRIBE 视图名；
## 修改视图（ALTER VIEW）
ALTER VIEW <视图名> AS <SELECT语句>
### 实例1:使用 ALTER 语句修改视图 view_students_info
mysql> ALTER VIEW view_students_info
    -> AS SELECT id,name,age
    -> FROM tb_students_info;
## 用户可以通过视图来插入、更新、删除表中的数据，因为视图是一个虚拟的表，没有数据。通过视图更新时转到基本表上进行更新，如果对视图增加或删除记录，实际上是对基本表增加或删除记录。
## 查看视图 view_students_info 的数据内容:
SELECT * FROM view_students_info;
### 实例2:使用 UPDATE 语句更新视图 view_students_info
mysql> UPDATE view_students_info
    -> SET age=25 WHERE id=1;
## 修改视图名称:
## 修改视图的名称可以先将视图删除，然后按照相同的定义语句进行视图的创建，并命名为新的视图名称。

# 删除视图（DORP VIEW）
DROP VIEW <视图名1> [ , <视图名2> …]
### 实例:删除 v_students_info 视图
mysql> DROP VIEW IF EXISTS v_students_info;

# 自定义函数（CREATE FUNCTION）
CREATE FUNCTION <函数名> ( [ <参数1> <类型1> [ , <参数2> <类型2>] ] … )
  RETURNS <类型>
  <函数主体>
### 实例:创建存储函数，名称为 StuNameById，该函数返回 SELECT 语句的查询结果，数值类型为字符串类型
mysql> CREATE FUNCTION StuNameById()
    -> RETURNS VARCHAR(45)
    -> RETURN
    -> (SELECT name FROM tb_students_info
    -> WHERE id=1);
# 调用函数:成功创建自定义函数后，就可以如同调用系统内置函数一样，使用关键字 SELECT 调用用户自定义的函数，语法格式为：
SELECT <自定义函数名> ([<参数> [,...]])
mysql> SELECT StuNameById();
## 修改自定义函数: ALTER FUNCTION 语句来修改自定义函数的某些相关特征。若要修改自定义函数的内容，则需要先删除该自定义函数，然后重新创建。
## 删除自定义函数:
### 自定义函数被创建后，一直保存在数据库服务器上以供使用，直至被删除。删除自定义函数的方法与删除存储过程的方法基本一样，可以使用 DROP FUNCTION 语句来实现。
DROP FUNCTION [ IF EXISTS ] <自定义函数名>
DROP FUNCTION StuNameById;

# 存储过程:一组为了完成特定功能的 SQL 语句集合
## 我们前面所学习的 MySQL 语句都是针对一个表或几个表的单条 SQL 语句，但是在数据库的实际操作中，并非所有操作都那么简单，经常会有一个完整的操作需要多条 SQL 语句处理多个表才能完成。例如，为了确认学生能否毕业，需要同时查询学生档案表、成绩表和综合表，此时就需要使用多条 SQL 语句来针对几个数据表完成这个处理要求。存储过程可以有效地完成这个数据库操作。

## 存储过程是一组为了完成特定功能的 SQL 语句集合。使用存储过程的目的是将常用或复杂的工作预先用 SQL 语句写好并用一个指定名称存储起来，这个过程经编译和优化后存储在数据库服务器中，因此称为存储过程。当以后需要数据库提供与已定义好的存储过程的功能相同的服务时，只需调用“CALL存储过程名字”即可自动完成。

## 常用操作数据库的 SQL 语句在执行的时候需要先编译，然后执行。存储过程则采用另一种方式来执行 SQL 语句。

## 一个存储过程是一个可编程的函数，它在数据库中创建并保存，一般由 SQL 语句和一些特殊的控制结构组成。当希望在不同的应用程序或平台上执行相同的特定功能时，存储过程尤为合适。

## 存储过程通常有如下优点：
### 1) 封装性
### 存储过程被创建后，可以在程序中被多次调用，而不必重新编写该存储过程的 SQL 语句，并且数据库专业人员可以随时对存储过程进行修改，而不会影响到调用它的应用程序源代码。
### 2) 可增强 SQL 语句的功能和灵活性
### 存储过程可以用流程控制语句编写，有很强的灵活性，可以完成复杂的判断和较复杂的运算。
### 3) 可减少网络流量
### 由于存储过程是在服务器端运行的，且执行速度快，因此当客户计算机上调用该存储过程时，网络中传送的只是该调用语句，从而可降低网络负载。
### 4) 高性能
### 存储过程执行一次后，产生的二进制代码就驻留在缓冲区，在以后的调用中，只需要从缓冲区中执行二进制代码即可，从而提高了系统的效率和性能。
### 5) 提高数据库的安全性和数据的完整性
### 使用存储过程可以完成所有数据库操作，并且可以通过编程的方式控制数据库信息访问的权限。

# CREATE PROCEDURE 创建存储过程
CREATE PROCEDURE <过程名> ( [过程参数[,…] ] ) <过程体>
[过程参数[,…] ] 格式
[ IN | OUT | INOUT ] <参数名> <类型>
## 语法说明如下：
### 1) 过程名
### 存储过程的名称，默认在当前数据库中创建。若需要在特定数据库中创建存储过程，则要在名称前面加上数据库的名称，即 db_name.sp_name。需要注意的是，名称应当尽量避免选取与 MySQL 内置函数相同的名称，否则会发生错误。
### 2) 过程参数
### 存储过程的参数列表。其中，<参数名>为参数名，<类型>为参数的类型（可以是任何有效的 MySQL 数据类型）。当有多个参数时，参数列表中彼此间用逗号分隔。存储过程可以没有参数（此时存储过程的名称后仍需加上一对括号），也可以有 1 个或多个参数。

### MySQL 存储过程支持三种类型的参数，即输入参数、输出参数和输入/输出参数，分别用 IN、OUT 和 INOUT 三个关键字标识。其中，输入参数可以传递给一个存储过程，输出参数用于存储过程需要返回一个操作结果的情形，而输入/输出参数既可以充当输入参数也可以充当输出参数。需要注意的是，参数的取名不要与数据表的列名相同，否则尽管不会返回出错信息，但是存储过程的 SQL 语句会将参数名看作列名，从而引发不可预知的结果。
### 3) 过程体
### 存储过程的主体部分，也称为存储过程体，包含在过程调用的时候必须执行的 SQL 语句。这个部分以关键字 BEGIN 开始，以关键字 END 结束。若存储过程体中只有一条 SQL 语句，则可以省略 BEGIN-END 标志。

### 在存储过程的创建中，经常会用到一个十分重要的 MySQL 命令，即 DELIMITER 命令，特别是对于通过命令行的方式来操作 MySQL 数据库的使用者，更是要学会使用该命令。

### 在 MySQL 中，服务器处理 SQL 语句默认是以分号作为语句结束标志的。然而，在创建存储过程时，存储过程体可能包含有多条 SQL 语句，这些 SQL 语句如果仍以分号作为语句结束符，那么 MySQL 服务器在处理时会以遇到的第一条 SQL 语句结尾处的分号作为整个程序的结束符，而不再去处理存储过程体中后面的 SQL 语句，这样显然不行。为解决这个问题，通常可使用 DELIMITER 命令将结束命令修改为其他字符。

# 修改命令结束符:
DELIMITER $$ 
## 语法说明如下：
### $$ 是用户定义的结束符，通常这个符号可以是一些特殊的符号，如两个“?”或两个“￥”等。
### 当使用 DELIMITER 命令时，应该避免使用反斜杠“\”字符，因为它是 MySQL 的转义字符。

# 命令查看数据库中存在哪些存储过程:
SHOW PROCEDURE STATUS 

# 查看某个存储过程的具体信息:
SHOW CREATE PROCEDURE <存储过程名>

# 创建不带参数的存储过程:
# 创建名称为 ShowStuScore 的存储过程，存储过程的作用是从学生成绩信息表中查询学生的成绩信息
mysql> DELIMITER //
mysql> CREATE PROCEDURE ShowStuScore()
    -> BEGIN
    -> SELECT * FROM tb_students_score;
    -> END //
# 创建存储过程 ShowStuScore 后，通过 CALL 语句调用该存储过程的 SQL 语句和执行结果
mysql> DELIMITER ;
mysql> CALL ShowStuScore();

# 创建带参数的存储过程:
# 创建名称为 GetScoreByStu 的存储过程，输入参数是学生姓名。存储过程的作用是通过输入的学生姓名从学生成绩信息表中查询指定学生的成绩信息
mysql> DELIMITER //
mysql> CREATE PROCEDURE GetScoreByStu
    -> (IN name VARCHAR(30))
    -> BEGIN
    -> SELECT student_score FROM tb_students_score
    -> WHERE student_name=name;
    -> END //
# 创建存储过程 GetScoreByStu 后，通过 CALL 语句调用该存储过程的 SQL 语句和执行结果
mysql> DELIMITER ;
mysql> CALL GetScoreByStu('Green');

# 修改存储过程（ALTER PROCEDURE）
ALTER PROCEDURE <过程名> [ <特征> … ]
## 修改存储过程的内容和名称
## 修改存储过程的内容可以通过删除原存储过程，再以相同的命名创建新的存储过程。
## 修改存储过程的名称可以通过删除原存储过程，再以不同的命名创建新的存储过程。

# 删除存储过程（DROP PROCEDURE）
DROP { PROCEDURE | FUNCTION } [ IF EXISTS ] <过程名>
mysql> DROP PROCEDURE GetScoreByStu;

# 触发器简介:
# 特殊的存储过程，不同的是执行存储过程要使用 CALL 语句来调用，而触发器的执行不需要使用 CALL 语句来调用，也不需要手工启动，只要一个预定义的事件发生就会被 MySQL自动调用。
# 引发触发器执行的事件一般如下：
## 增加一条学生记录时，会自动检查年龄是否符合范围要求。
## 每当删除一条学生信息时，自动删除其成绩表上的对应记录。
## 每当删除一条数据时，在数据库存档表中保留一个备份副本。

# 触发程序的优点如下：
## 触发程序的执行是自动的，当对触发程序相关表的数据做出相应的修改后立即执行。
## 触发程序可以通过数据库中相关的表层叠修改另外的表。
## 触发程序可以实施比 FOREIGN KEY 约束、CHECK 约束更为复杂的检查和操作。

# 在 MySQL 中，只有执行 INSERT、UPDATE 和 DELETE 操作时才能激活触发器。
## 1) INSERT 触发器,在 INSERT 语句执行之前或之后响应的触发器。
## 使用 INSERT 触发器需要注意以下几点：
### 在 INSERT 触发器代码内，可引用一个名为 NEW（不区分大小写）的虚拟表来访问被插入的行。
### 在 BEFORE INSERT 触发器中，NEW 中的值也可以被更新，即允许更改被插入的值（只要具有对应的操作权限）。
### 对于 AUTO_INCREMENT 列，NEW 在 INSERT 执行之前包含的值是 0，在 INSERT 执行之后将包含新的自动生成值。

## 2) UPDATE 触发器,在 UPDATE 语句执行之前或之后响应的触发器。
## 使用 UPDATE 触发器需要注意以下几点：
### 在 UPDATE 触发器代码内，可引用一个名为 NEW（不区分大小写）的虚拟表来访问更新的值。
### 在 UPDATE 触发器代码内，可引用一个名为 OLD（不区分大小写）的虚拟表来访问 UPDATE 语句执行前的值。
### 在 BEFORE UPDATE 触发器中，NEW 中的值可能也被更新，即允许更改将要用于 UPDATE 语句中的值（只要具有对应的操作权限）。
### OLD 中的值全部是只读的，不能被更新。
### 注意：当触发器设计对触发表自身的更新操作时，只能使用 BEFORE 类型的触发器，AFTER 类型的触发器将不被允许。

## 3) DELETE 触发器,在 DELETE 语句执行之前或之后响应的触发器。
## 使用 DELETE 触发器需要注意以下几点：
### 在 DELETE 触发器代码内，可以引用一个名为 OLD（不区分大小写）的虚拟表来访问被删除的行。
### OLD 中的值全部是只读的，不能被更新。

## 总体来说，触发器使用的过程中，MySQL 会按照以下方式来处理错误。
### 若对于事务性表，如果触发程序失败，以及由此导致的整个语句失败，那么该语句所执行的所有更改将回滚；对于非事务性表，则不能执行此类回滚，即使语句失败，失败之前所做的任何更改依然有效。
### 若 BEFORE 触发程序失败，则 MySQL 将不执行相应行上的操作。
### 若在 BEFORE 或 AFTER 触发程序的执行过程中出现错误，则将导致调用触发程序的整个语句失败。
### 仅当 BEFORE 触发程序和行操作均已被成功执行，MySQL 才会执行AFTER触发程序。

# 创建触发器（CREATE TRIGGER）
# 在满足定义条件时触发，并执行触发器中定义的语句集合。
CREATE <触发器名> < BEFORE | AFTER >
<INSERT | UPDATE | DELETE >
ON <表名> FOR EACH Row<触发器主体>
## 1) 触发器名
### 触发器的名称，触发器在当前数据库中必须具有唯一的名称。如果要在某个特定数据库中创建，名称前面应该加上数据库的名称。
## 2) INSERT | UPDATE | DELETE
### 触发事件，用于指定激活触发器的语句的种类。
### 注意：三种触发器的执行时间如下。
### INSERT：将新行插入表时激活触发器。例如，INSERT 的 BEFORE 触发器不仅能被 MySQL 的 INSERT 语句激活，也能被 LOAD DATA 语句激活。
### DELETE： 从表中删除某一行数据时激活触发器，例如 DELETE 和 REPLACE 语句。
### UPDATE：更改表中某一行数据时激活触发器，例如 UPDATE 语句。
## 3) BEFORE | AFTER
### BEFORE 和 AFTER，触发器被触发的时刻，表示触发器是在激活它的语句之前或之后触发。若希望验证新数据是否满足条件，则使用 BEFORE 选项；若希望在激活触发器的语句执行之后完成几个或更多的改变，则通常使用 AFTER 选项。
## 4) 表名
### 与触发器相关联的表名，此表必须是永久性表，不能将触发器与临时表或视图关联起来。在该表上触发事件发生时才会激活触发器。同一个表不能拥有两个具有相同触发时刻和事件的触发器。例如，对于一张数据表，不能同时有两个 BEFORE UPDATE 触发器，但可以有一个 BEFORE UPDATE 触发器和一个 BEFORE INSERT 触发器，或一个 BEFORE UPDATE 触发器和一个 AFTER UPDATE 触发器。
## 5) 触发器主体
### 触发器动作主体，包含触发器激活时将要执行的 MySQL 语句。如果要执行多个语句，可使用 BEGIN…END 复合语句结构。
## 6) FOR EACH ROW
### 一般是指行级触发，对于受触发事件影响的每一行都要激活触发器的动作。例如，使用 INSERT 语句向某个表中插入多行数据时，触发器会对每一行数据的插入都执行相应的触发器动作。
### 注意：每个表都支持 INSERT、UPDATE 和 DELETE 的 BEFORE 与 AFTER，因此每个表最多支持 6 个触发器。每个表的每个事件每次只允许有一个触发器。单一触发器不能与多个事件或多个表关联。
### 另外，在 MySQL 中，若需要查看数据库中已有的触发器，则可以使用 SHOW TRIGGERS 语句。
## 实例1:创建一个名为 SumOfSalary 的触发器，触发的条件是向数据表 tb_emp8 中插入数据之前，对新插入的 salary 字段值进行求和计算。
mysql> CREATE TRIGGER SumOfSalary
    -> BEFORE INSERT ON tb_emp8
    -> FOR EACH ROW
    -> SET @sum=@sum+NEW.salary;
## 实例2:创建一个名为 double_salary 的触发器，触发的条件是向数据表 tb_emp6 中插入数据之后，再向数据表 tb_emp7 中插入相同的数据，并且 salary 为 tb_emp6 中新插入的 salary 字段值的 2 倍。
CREATE TRIGGER double_salary
    -> AFTER INSERT ON tb_emp6
    -> FOR EACH ROW
    -> INSERT INTO tb_emp7
    -> VALUES (NEW.id,NEW.name,deptId,2*NEW.salary);

# 修改和删除触发器（DROP TRIGGER）
DROP TRIGGER [ IF EXISTS ] [数据库名] <触发器名>
## 修改触发器可以通过删除原触发器，再以相同的名称创建新的触发器。

# 索引:根据表中的一列或若干列按照一定顺序建立的列值与记录行之间的对应关系表，实质上是一张描述索引列的列值与原表中记录行之间一一对应关系的有序表。
## 1) 顺序访问:顺序访问是在表中实行全表扫描，从头到尾逐行遍历，直到在无序的行数据中找到符合条件的目标数据。这种方式实现比较简单，但是当表中有大量数据的时候，效率非常低下。例如，在几千万条数据中查找少量的数据时，使用顺序访问方式将会遍历所有的数据，花费大量的时间，显然会影响数据库的处理性能。
## 2) 索引访问: 索引访问是通过遍历索引来直接访问表中记录行的方式。使用这种方式的前提是对表建立一个索引，在列上创建了索引之后，查找数据时可以直接根据该列上的索引找到对应记录行的位置，从而快捷地查找到数据。索引存储了指定列数据值的指针，根据指定的排序顺序对这些指针排序。
# 索引的分类:根据存储方式的不同，MySQL 中常用的索引在物理上分为以下两类。
## 1) B-树索引
### B-树索引又称为 BTREE 索引，目前大部分的索引都是采用 B-树索引来存储的。B-树索引是一个典型的数据结构，其包含的组件主要有以下几个：
### 叶子节点：包含的条目直接指向表里的数据行。叶子节点之间彼此相连，一个叶子节点有一个指向下一个叶子节点的指针。
### 分支节点：包含的条目指向索引里其他的分支节点或者叶子节点。
### 根节点：一个 B-树索引只有一个根节点，实际上就是位于树的最顶端的分支节点。

### 基于这种树形数据结构，表中的每一行都会在索引上有一个对应值。因此，在表中进行数据查询时，可以根据索引值一步一步定位到数据所在的行。

### B-树索引可以进行全键值、键值范围和键值前缀查询，也可以对查询结果进行 ORDER BY 排序。但 B-树索引必须遵循左边前缀原则，要考虑以下几点约束：
### 查询必须从索引的最左边的列开始。
### 查询不能跳过某一索引列，必须按照从左到右的顺序进行匹配。
### 存储引擎不能使用索引中范围条件右边的列。
## 2) 哈希索引
### 哈希（Hash）一般翻译为“散列”，也有直接音译成“哈希”的，就是把任意长度的输入（又叫作预映射，pre-image）通过散列算法变换成固定长度的输出，该输出就是散列值。

### 哈希索引也称为散列索引或 HASH 索引。MySQL 目前仅有 MEMORY 存储引擎和 HEAP 存储引擎支持这类索引。其中，MEMORY 存储引擎可以支持 B- 树索引和 HASH 索引，且将 HASH 当成默认索引。

### HASH 索引不是基于树形的数据结构查找数据，而是根据索引列对应的哈希值的方法获取表的记录行。哈希索引的最大特点是访问速度快，但也存在下面的一些缺点：
### MySQL 需要读取表中索引列的值来参与散列计算，散列计算是一个比较耗时的操作。也就是说，相对于 B- 树索引来说，建立哈希索引会耗费更多的时间。
### 不能使用 HASH 索引排序。
### HASH 索引只支持等值比较，如“=”“IN()”或“<=>”。
### HASH 索引不支持键的部分匹配，因为在计算 HASH 值的时候是通过整个索引值来计算的。

## 根据索引的具体用途，MySQL 中的索引在逻辑上分为以下 5 类：
### 1) 普通索引
### 普通索引是最基本的索引类型，唯一任务是加快对数据的访问速度，没有任何限制。创建普通索引时，通常使用的关键字是 INDEX 或 KEY。
### 2) 唯一性索引
### 唯一性索引是不允许索引列具有相同索引值的索引。如果能确定某个数据列只包含彼此各不相同的值，在为这个数据列创建索引的时候就应该用关键字 UNIQUE 把它定义为一个唯一性索引。

### 创建唯一性索引的目的往往不是为了提高访问速度，而是为了避免数据出现重复。
### 3) 主键索引
### 主键索引是一种唯一性索引，即不允许值重复或者值为空，并且每个表只能有一个主键。主键可以在创建表的时候指定，也可以通过修改表的方式添加，必须指定关键字 PRIMARY KEY。
### 注意：主键是数据库考察的重点。注意每个表只能有一个主键。

### 4) 空间索引
### 空间索引主要用于地理空间数据类型 GEOMETRY。
### 5) 全文索引
### 全文索引只能在 VARCHAR 或 TEXT 类型的列上创建，并且只能在 MyISAM 表中创建。

### 索引在逻辑上分为以上 5 类，但在实际使用中，索引通常被创建成单列索引和组合索引。
### 单列索引就是索引只包含原表的一个列。
### 组合索引也称为复合索引或多列索引，相对于单列索引来说，组合索引是将原表的多个列共同组成一个索引。
### 提示：一个表可以有多个单列索引，但这些索引不是组合索引。一个组合索引实质上为表的查询提供了多个索引，以此来加快查询速度。比如，在一个表中创建了一个组合索引(c1，c2，c3)，在实际查询中，系统用来实际加速的索引有三个：单个索引(c1)、双列索引(c1，c2)和多列索引(c1，c2，c3)。

### 为了提高索引的应用性能，MySQL中的索引可以根据具体应用采用不同的索引策略。这些索引策略所对应的索引类型有聚集索引、次要索引、覆盖索引、复合索引、前缀索引、唯一索引等。
### 索引的使用原则和注意事项
### 虽然索引可以加快查询速度，提高 MySQL 的处理性能，但是过多地使用索引也会造成以下弊端：
### 创建索引和维护索引要耗费时间，这种时间随着数据量的增加而增加。
### 除了数据表占数据空间之外，每一个索引还要占一定的物理空间。如果要建立聚簇索引，那么需要的空间就会更大。
### 当对表中的数据进行增加、删除和修改的时候，索引也要动态地维护，这样就降低了数据的维护速度。
### 注意：索引可以在一些情况下加速查询，但是在某些情况下，会降低效率。

### 索引只是提高效率的一个因素，因此在建立索引的时候应该遵循以下原则：
### 在经常需要搜索的列上建立索引，可以加快搜索的速度。
### 在作为主键的列上创建索引，强制该列的唯一性，并组织表中数据的排列结构。
### 在经常使用表连接的列上创建索引，这些列主要是一些外键，可以加快表连接的速度。
### 在经常需要根据范围进行搜索的列上创建索引，因为索引已经排序，所以其指定的范围是连续的。
### 在经常需要排序的列上创建索引，因为索引已经排序，所以查询时可以利用索引的排序，加快排序查询。
### 在经常使用 WHERE 子句的列上创建索引，加快条件的判断速度。

### 与此对应，在某些应用场合下建立索引不能提高 MySQL 的工作效率，甚至在一定程度上还带来负面效应，降低了数据库的工作效率，一般来说不适合创建索引的环境如下：
### 对于那些在查询中很少使用或参考的列不应该创建索引。因为这些列很少使用到，所以有索引或者无索引并不能提高查询速度。相反，由于增加了索引，反而降低了系统的维护速度，并增大了空间要求。
### 对于那些只有很少数据值的列也不应该创建索引。因为这些列的取值很少，例如人事表的性别列。查询结果集的数据行占了表中数据行的很大比例，增加索引并不能明显加快检索速度。
### 对于那些定义为 TEXT、IMAGE 和 BIT 数据类型的列不应该创建索引。因为这些列的数据量要么相当大，要么取值很少。
### 当修改性能远远大于检索性能时，不应该创建索引。因为修改性能和检索性能是互相矛盾的。当创建索引时，会提高检索性能，降低修改性能。当减少索引时，会提高修改性能，降低检索性能。因此，当修改性能远远大于检索性能时，不应该创建索引。

# 创建索引（CREATE INDEX）
## 1) 使用 CREATE INDEX 语句
CREATE <索引名> ON <表名> (<列名> [<长度>] [ ASC | DESC])
## 2) 使用 CREATE TABLE 语句
CONSTRAINT PRIMARY KEY [索引类型] (<列名>,…)
## 3) 使用 ALTER TABLE 语句
ADD INDEX [<索引名>] [<索引类型>] (<列名>,…)
## 实例1:创建一般索引,创建一个表 tb_stu_info，在该表的 height 字段创建一般索引。
mysql> CREATE TABLE tb_stu_info
    -> (
    -> id INT NOT NULL,
    -> name CHAR(45) DEFAULT NULL,
    -> dept_id INT DEFAULT NULL,
    -> age INT DEFAULT NULL,
    -> height INT DEFAULT NULL,
    -> INDEX(height));
## 实例2:创建唯一索引,创建一个表 tb_stu_info2，在该表的 id 字段上使用 UNIQUE 关键字创建唯一索引。
mysql> CREATE TABLE tb_stu_info2
    -> (
    -> id INT NOT NULL,
    -> name CHAR(45) DEFAULT NULL,
    -> dept_id INT DEFAULT NULL,
    -> age INT DEFAULT NULL,
    -> height INT DEFAULT NULL,
    -> UNIQUE INDEX(height));
## 查看索引:
SHOW INDEX FROM <表名> [ FROM <数据库名>]
SHOW INDEX FROM tb_stu_info2\G
## 修改和删除索引（DROP INDEX）
DROP INDEX <索引名> ON <表名>

## 实例:删除索引:
mysql> DROP INDEX height
    -> ON tb_stu_info;
mysql> ALTER TABLE tb_stu_info2
    -> DROP INDEX height;

# 创建用户（CREATE USER）
CREATE USER <用户名> [ IDENTIFIED ] BY [ PASSWORD ] <口令>
## 语法说明如下：
### 1) <用户名>
### 指定创建用户账号，格式为 'user_name'@'host_name'。这里user_name是用户名，host_name为主机名，即用户连接 MySQL 时所在主机的名字。若在创建的过程中，只给出了账户的用户名，而没指定主机名，则主机名默认为“%”，表示一组主机。
### 2) PASSWORD
### 可选项，用于指定散列口令，即若使用明文设置口令，则需忽略PASSWORD关键字；若不想以明文设置口令，且知道 PASSWORD() 函数返回给密码的散列值，则可以在口令设置语句中指定此散列值，但需要加上关键字PASSWORD。
### 3) IDENTIFIED BY子句
### 用于指定用户账号对应的口令，若该用户账号无口令，则可省略此子句。
### 4) <口令>
### 指定用户账号的口令，在IDENTIFIED BY关键字或PASSWOED关键字之后。给定的口令值可以是只由字母和数字组成的明文，也可以是通过 PASSWORD() 函数得到的散列值。

## 使用 CREATE USER 语句应该注意以下几点：
### 如果使用 CREATE USER 语句时没有为用户指定口令，那么 MySQL 允许该用户可以不使用口令登录系统，然而从安全的角度而言，不推荐这种做法。
### 使用 CREATE USER 语句必须拥有 MySQL 中 MySQL 数据库的 INSERT 权限或全局 CREATE USER 权限。
### 使用 CREATE USER 语句创建一个用户账号后，会在系统自身的 MySQL 数据库的 user 表中添加一条新记录。若创建的账户已经存在，则语句执行时会出现错误。
### 新创建的用户拥有的权限很少。他们可以登录 MySQL，只允许进行不需要权限的操作，如使用 SHOW 语句查询所有存储引擎和字符集的列表等。
## 实例:创建一个用户:使用 CREATE USER 创建一个用户，用户名是 james，密码是 tiger，主机是 localhost。
mysql> CREATE USER 'james'@'localhost'
    -> IDENTIFIED BY 'tiger';
## 修改用户（RENAME USER）
## 修改用户账号
RENAME USER <旧用户> TO <新用户>
## 实例:使用 RENAME USER 语句将用户名 james 修改为 jack，主机是 localhost。
mysql> RENAME USER james@'localhost'
    -> TO jack@'localhost';
## 修改用户口令
## 可以使用 SET PASSWORD 语句修改一个用户的登录口令。
SET PASSWORD [ FOR <用户名> ] =
{
    PASSWORD('新明文口令')
    | OLD_PASSWORD('旧明文口令')
    | '加密口令值'
}
## 实例: 使用 SET 语句将用户名为 jack 的密码修改为 lion，主机是 localhost。
mysql> SET PASSWORD FOR 'jack'@'localhost'=
    -> PASSWORD('lion');
## 删除用户（DROP USER）
DROP USER <用户名1> [ , <用户名2> ]…
mysql> DROP USER 'jack'@'localhost';
## 用户授权（GRANT）
## 实例:授予用户权限,使用 GRANT 语句创建一个新的用户 testUser，密码为 testPwd。用户 testUser 对所有的数据有查询、插入权限，并授予 GRANT 权限。
mysql> GRANT SELECT,INSERT ON *.*
    -> TO 'testUser'@'localhost'
    -> IDENTIFIED BY 'testPwd'
    -> WITH GRANT OPTION;
## 使用 SELECT 语句查询用户 testUser 的权限
mysql> SELECT Host,User,Select_priv,Grant_priv
    -> FROM mysql.user
    -> WHERE User='testUser';

# 删除用户权限:
## 1) 第一种：
REVOKE <权限类型> [ ( <列名> ) ] [ , <权限类型> [ ( <列名> ) ] ]…
ON <对象类型> <权限名> FROM <用户1> [ , <用户2> ]…
## 2) 第二种：
REVOKE ALL PRIVILEGES, GRANT OPTION
FROM user <用户1> [ , <用户2> ]…
## 实例:使用 REVOKE 语句取消用户 testUser 的插入权限
mysql> REVOKE INSERT ON *.*
    -> FROM 'testUser'@'localhost';
mysql> SELECT Host,User,Select_priv,Insert_priv,Grant_priv
    -> FROM mysql.user
    -> WHERE User='testUser';

# 事务（TRANSACTION）
# 用户一系列的数据库操作序列，这些操作要么全做要么全不做，是一个不可分割的工作单位。
## 为什么要使用事务
## 事务具有 4 个特性：原子性（Atomicity）、一致性（Consistency）、隔离性（Isolation）和持续性（Durability）。这 4 个特性简称为 ACID 特性。
### 1) 原子性
### 事务必须是原子工作单元，事务中的操作要么全部执行，要么全都不执行，不能只完成部分操作。原子性在数据库系统中，由恢复机制来实现。
### 2) 一致性
### 事务开始之前，数据库处于一致性的状态；事务结束后，数据库必须仍处于一致性状态。数据库一致性的定义是由用户负责的。例如，在银行转账中，用户可以定义转账前后两个账户金额之和保持不变。
### 3) 隔离性
### 系统必须保证事务不受其他并发执行事务的影响，即当多个事务同时运行时，各事务之间相互隔离，不可互相干扰。事务查看数据时所处的状态，要么是另一个并发事务修改它之前的状态，要么是另一个并发事务修改它之后的状态，事务不会查看中间状态的数据。隔离性通过系统的并发控制机制实现。
### 4) 持久性
### 一个已完成的事务对数据所做的任何变动在系统中是永久有效的，即使该事务产生的修改不正确，错误也将一直保持。持久性通过恢复机制实现，发生故障时，可以通过日志等手段恢复数据库信息。

### 事务的 ACID 原则保证了一个事务或者成功提交，或者失败回滚，二者必居其一。因此，它对事务的修改具有可恢复性。即当事务失败时，它对数据的修改都会恢复到该事务执行前的状态。

## 开始事务
BEGIN TRANSACTION <事务名称> |@<事务变量名称>
## 提交事务
COMMIT TRANSACTION <事务名称> |@<事务变量名称>
## 撤销事务
ROLLBACK [TRANSACTION]
[<事务名称>| @<事务变量名称> | <存储点名称>| @ <含有存储点名称的变量名>

# 数据库备份
# 使用 SELECT INTO OUTFILE 语句把表数据导出到一个文本文件中进行备份。
mysql> SELECT * FROM test_db.tb_students_info
    -> INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/file.txt'
    -> FIELDS TERMINATED BY '"'
    -> LINES TERMINATED BY '?';
# 数据库恢复（LOAD DATA）
# 使用 LOAD DATA…INFILE 语句来恢复先前备份的数据。
## 创建表 tb_students_copy， tb_students_copy 的表结构和 tb_students_info 相同。
mysql> CREATE TABLE tb_students_copy
    -> LIKE tb_students_info;
## 导入数据与查询表 tb_students_copy 的过程:
mysql> LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/
Uploads/file.txt'
    -> INTO TABLE test_db.tb_students_copy
    -> FIELDS TERMINATED BY ','
    -> OPTIONALLY ENCLOSED BY '"'
    -> LINES TERMINATED BY '?';

'''
一般适用 mysqlclient,几种驱动比较它的速度最快,它是用c语言封装的:
'''
import MySQLdb
# connect() 方法用于创建数据库的连接，里面可以指定参数：用户名，密码，主机等信息。
# 这只是连接到了数据库，要想操作数据库需要创建游标。
db= MySQLdb.connect(
        host= '127.0.0.1',
        port = 3306,
        user='root',
        passwd='z#+=75872158',          # 安装新mysql时,选择了新的密码加密方式(sha2),此处会报错,修改密码加密方式为传统方式,
        db ='',                     # 即可排除错误;参见:https://stackoverflow.com/questions/54106511/django-connec-mysql-mysql-exceptions-operationalerror-2006-null
        )

conn = MySQLdb.connect(
        host= '192.168.3.50',        # 服务器不允许连接服务器,所以服务器上不要用python进行此操作;
        port = 3306,
        user='zhuloo',
        passwd='z20465879',
        db ='test',
        connect_timeout=900          # 需要设置等待时间，否则会断开连接出错
)

# 通过获取到的数据库连接conn下的cursor()方法来创建游标。
cur = db.cursor()

# 创建数据表,通过游标cur 操作execute()方法可以写入纯sql语句。通过execute()方法中写如sql语句来对数据进行操作
cur.execute("create table student(id int ,name varchar(20),class varchar(30),age varchar(10))")

#插入一条数据
cur.execute("insert into student values('2','Tom','3 year 2 class','9')")
cur.execute("insert into name values(8,'mack',0,99)")




#修改查询条件的数据
cur.execute("update student set class='3 year 1 class' where name = 'Tom'")

#删除查询条件的数据
cur.execute("delete from student where age='9'")

#cur.close() 关闭游标
cur.close()

#conn.commit()方法在提交事物，在向数据库插入一条数据时必须要有这个方法，否则数据不会被真正的插入。
conn.commit()

#conn.close()关闭数据库连接
conn.close()

### 插入数据:
# 通过上面execute()方法中写入纯的sql语句来插入数据并不方便。如：
cur.execute("insert into student values('2','Tom','3 year 2 class','9')")
# 我要想插入新的数据，必须要对这条语句中的值做修改。我们可以做如下修改：
#coding=utf-8
import MySQLdb
db= MySQLdb.connect(
        host='127.0.0.1',
        port = 3306,
        user='root',
        passwd='z#+=75872158',
        db ='test',
        )
cur = db.cursor()

# 插入一条数据
sqli="insert into student values(%s,%s,%s,%s)"
cur.execute(sqli,('3','Huhu','2 year 1 class','7'))

# 一次插入多条记录
sqli="insert into student values(%s,%s,%s,%s)"
cur.executemany(sqli,[
    ('3','Tom','1 year 1 class','6'),
    ('3','Jack','2 year 1 class','7'),
    ('3','Yaheng','2 year 2 class','7'),
    ])
cur.close()
conn.commit()
conn.close()

### 查询数据:
# 也许你已经尝试了在python中通过:
cur.execute("select * from student")
# 来查询数据表中的数据，但它并没有把表中的数据打印出来，有些失望。
# 来看看这条语句获得的是什么
aa=cur.execute("select * from student")
print(aa)
5 # 它获得的只是我们的表中有多少条数据。那怎样才能获得表中的数据呢？进入python shell
cur.execute("select * from student")
5L
cur.fetchone()
(1L, 'Alen', '1 year 2 class', '6')
cur.fetchone()
(3L, 'Huhu', '2 year 1 class', '7')
cur.fetchone()
(3L, 'Tom', '1 year 1 class', '6') # fetchone()方法可以帮助我们获得表中的数据，可是每次执行cur.fetchone() 获得的数据都不一样，
...
cur.scroll(0,'absolute')           # scroll(0,'absolute') 方法可以将游标定位到表中的第一条数据。
                                   # 换句话说我没执行一次，游标会从表中的第一条数据移动到下一条数据的位置，所以，我再次执行的时候得到的是第二条数据。
                                   # 还是没解决我们想要的结果，如何获得表中的多条数据并打印出来呢？
# 获得表中有多少条数据
aa=cur.execute("select * from student")
print(aa)

#打印表中的多少数据
info = cur.fetchmany(aa)
for i in info:
    print(i)
cur.close()
conn.commit()
conn.close()
# 通过之前的print aa 我们知道当前的表中有5条数据，fetchmany()方法可以获得多条数据，
# 但需要指定数据的条数，通过一个for循环就可以把多条数据打印出啦！

### 将列表数据写入数据库:
# 先手动建立表格students:
mysql -h192.168.3.50 -uzhuloo -pz20465879
use test;
CREATE TABLE students (
  id int(11) NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  age int(11) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
show tables;

import MySQLdb
connect = None   # 连接对象
cursor = None    # 游标对象
try:
    # 连接对象
    connect = MySQLdb.connect(
        host ='192.168.3.50',   # 主机地址
        port = 3306,
        user ='zhuloo',    # 账号
        password ='z20465879',   # 密码
        database ='test',  # 数据库名
        connect_timeout = 120,
        use_unicode = True,
        charset='utf8' # 指定字符集
    )
    # 游标对象
    cursor = connect.cursor()   # 通过连接对象调用cursor()
except Exception as e:
    print(e)
    connect.close()
try:
    if cursor:
        result = cursor.execute("insert into students (name, age) values ('Angle', 18)")  # 插入操作
        print('result = {}'.format(result))
        connect.commit()   # 提交
except Exception as e:
    print(e)
    connect.rollback()   # 回滚
finally:
    if cursor:
        cursor.close()
    if connect:
        connect.close()

# 批量插入数据:
try:
    if cursor:
        for i in range(10):
            cursor.execute("insert into students (name, age) values ('Angle', {})".format(i))  # 插入操作
        connect.commit()   # 提交

except Exception as e:
    print(e)
    connect.rollback()   # 回滚
finally:
    if cursor:
        cursor.close()
    if connect:
        connect.close()
