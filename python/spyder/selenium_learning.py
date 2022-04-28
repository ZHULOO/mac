###############################selenium的使用############################
### 简单实用用例:
from selenium import webdriver                  # 支持的浏览器有：chrome，firefox和IE等
from selenium.webdriver.common.keys import Keys # 提供键盘按键的支持；

driver = webdriver.Chrome()
driver.get("http://www.baidu.com")
assert "百度一下" in driver.title                 # 通过页面标题是否含有“百度一下”来确认页面是否加载完毕；
elem = driver.find_element_by_name("wd")         # 通过name = wd来定义搜索框对象；
elem.clear()                                     # 清空搜索框；
elem.send_keys("python")                         # 输入python关键字
elem.send_keys(Keys.RETURN)                      # 点击搜索；
assert "No results found." not in driver.page_source # 确保某些特定结果被找到；
driver.close()

### 一、声明浏览器对象：
driver = webdriver.Chrome()

### 二、访问页面：
driver.get("http://www.baidu.com")

### 三、元素交互：
#### 1.元素定位：多种查找元素的方法：
##### 1.1 根据ID和NAME定位：
###### 公有方法：
elem = driver.find_element_by_name("wd")               # 根据name = wd来查找元素，返回查找到的第一个元素；
elem = driver.find_elements_by_name("wd")              # 根据name = ws来查找元素，返回一个列表；
###### 私有方法：
from selenium.webdriver.common.by import By
driver.find_element(By.XPATH,'//button[text()="some text"]')
driver.find_elements(By.NAME,'wd')
#####By类的可用属性：
ID = "id"
XPATH = "xpath"
LINK_TEXT = "link text"
PARTIAL_LINK_TEXT = "partial link text"
NAME = "name"
TAG_NAME = "tag_name"
CLASS_NAME = "class name"
CSS_SELECTOR = "css selector"
# XPATH是定位XML文档节点的语言，不过HTML可以看成是XML(XHTML)的一种实现。
# 用XPath的主要理由之一，就是你想定位的元素没有合适的id或者name属性的时候，你可以用XPath来对元素进行绝对定位(不推荐)或者把这个元素和另外一个有确定id或者name的元素关联起来（即相对定位）。
##### 1.2 根据链接文本定位超链接：
driver.find_element_by_link_text('Continue')
driver.find_element_by_partial_link_text('conti') # 输入部分子字符串即可匹配；
##### 1.3 根据标签名定位
driver.find_elements_by_tag_name('h1')
##### 1.4 根据class定位
driver.find_elements_by_class_name('content')
##### 1.5 CSS选择器定位
driver.find_elements_by_css_selector('p.content')

#### 2.元素交互
##### Waits
# 现在很多Web应用都在使用AJAX技术。浏览器载入一个页面时，页面内的元素可能是在不同的时间载入的，这会加大定位元素的困难程度，因为元素不在DOM里，会抛出ElementNotVisibleException异常，使用waits，我们就可以解决这个问题。



### 四、动作链：
### 五、