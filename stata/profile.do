*--------------------------
* profile.do 设定和说明
*--------------------------

*-说明：
* 此文件设定了每次启动 Stata 时需要做的一些基本设定
* 你可以在此文件中添加你希望在stata启动时立刻执行的命令

/*-不要自动更新
  set update_query  off

*-基本参数设定								
  set type double           // 设定 generate 命令产生的新变量为双精度类型
  set matsize 800           // 设定矩阵的维度为 2000x2000
  set scrollbufsize 2000000 // 结果窗口中显示的行数上限
  set more off, perma       // 关闭分页提示符
  
  set cformat  %4.3f  //回归结果中系数的显示格式
  set pformat  %4.3f  //回归结果中 p 值的显示格式      
  set sformat  %4.2f  //回归结果中 se值的显示格式     
  
  set showbaselevels off, permanently
  set showemptycells off, permanently
  set showomitted off, permanently
  set fvlabel on, permanently


*-PLUS 和 PERSONAL 文件夹  
*-有关这一部分的完整设定命令，请输入 help set 命令进行查看
  sysdir set PLUS "`c(sysdir_stata)'ado\plus"    // 外部命令的存放位置
  sysdir set PERSONAL "`c(sysdir_stata)'ado\personal"  // 个人文件夹位置

*-采用相似的方式，可添加其它允许stata搜索的目录
  adopath + "`c(sysdir_stata)'\ado\personal\_myado"
 *adopath + "路径2"
*/

* log文件：自动以当前日期为名存放于 stata15\do 文件夹下
* 若 stata 安装目录下无【do】文件夹，则自动建立一个,用于存放日志文件
  cap cd "`c(sysdir_stata)'do"
  if _rc{
    mkdir "`c(sysdir_stata)'do"
  }

*-启动时自动创建日志文件
  local fn = subinstr("`c(current_time)'",":","-",2)
  local fn1 = subinstr("`c(current_date)'"," ","",3)
  log using "`c(sysdir_stata)'do\log-`fn1'-`fn'.log",text replace
  cmdlog using "`c(sysdir_stata)'do\cmd-`fn1'-`fn'.log",replace   //只记录键入的命令

 
*-----------------------------------------------
*-以下是我的个性设定，可以忽略，也可以自行修改
*-----------------------------------------------

 /* 
dis in w _n(5) ///
           "    ------------------------------------------------------"
dis in w   "    -------------- Stata 15 dofile 转码方法 --------------" 
dis in w   "    ------------------------------------------------------" _n
  
  dis in w _n(1) ///
           "    用 Stata15 打开 Stata14 以下的 dofile 时，屏幕会提示 " _n
  dis in w "    ....... The document is not encoded in UTF-8! ......." _n
  dis in w "    处理方法：在 Encoding: 下拉菜单中选择 「Chinese(GBK)」，点击 OK " _n
  dis in w "    注意：不要勾选「[ ] Dot not show this message again」" _n _n
  
dis in w _n _n ///
         "    ------------------------------------------------------"
dis in w "    ----- Stata 15 转码方法(一次性处理 .dta 转码问题) ----" 
dis in w "    ------------------------------------------------------" _n
dis in w "    *-说明: dofile 或 数据文件中包含中文字符时，需要转码才能正常显示"
dis in w "                      "
dis in w "    *-Step 1: 分析当前工作路径下的编码情况(可省略)                "
dis in w "      ua: unicode analyze *                                         "    
dis in w "    *-Step 2: 设定转码类型                                          "   
dis in w "      ua: unicode encoding set gb18030  // 中文编码                 "                       
dis in w "    *-Step 3: 转换文件                                              "
dis in w "      ua: unicode translate *                                       "    

*---------
*-常逛网址
*---------
  dis in w _n "   "
  
  dis _n in w _col(10) _dup(45) "="
  dis    in w _col(10) _n _skip(20) "Hello World! Hello Stata!" _n
  dis    in w _col(10) _dup(45) "=" _n 
  
  dis in w  "常用网站：" ///
      `"{browse "http://www.baidu.com":      [百度] }"' ///
      `"{browse "http://http://www.cnki.net":[知网] }"' ///
      `"{browse "https://www.taobao.com/":   [淘宝] }"' ///
      `"{browse "http://www.jd.com/":        [京东] }"' _n
*/  
*----------------- 
*-快速进入相应目录
*----------------- 
* 定义一些小程序，在命令窗口中输入几个字母便可打开指定文件 
  dis in w _n(1) "Please Enter The Following Command Or Click It To Complete The Mission:"
  dis in w _n(1) "Files: {stata stata:[stata]} | {stata gitee:[gitee]} | {stata data:[data]} | {stata paper:[paper]} | {stata down:[down]} "
  dis in w _n(1) "Music: {stata kugou:[kugou]} | music+name | {stata quitk:[quitk]}" 
  dis in w _n(1) "Webs : {stata baidu:[baidu]} | web+url | {stata quitc:[quitc]} " 
  /*
  dis in w _n(1) "Files: stata | gitee | data | paper | down "
  dis in w _n(1) "Music: kugou | music+name | quitk" 
  dis in w _n(1) "Webs : baidu | web+url | quitc " 
  */
  local p "stata"
  cap program drop `p'
  program define `p'
    local pwd : pwd
    qui cd "D:\Program Files\stata15"
    qui cdout 
	  qui cd "`pwd'"
  end
  
  local p "gitee"
  cap program drop `p'
  program define `p'
    local pwd : pwd
    qui cd "E:\Mycode\Stata"
    qui cdout 
    qui cd "`pwd'"
  end
  
  local p "data"
  cap program drop `p'
  program define `p'
    local pwd : pwd
    qui cd "E:\data"
    qui cdout 
    qui cd "`pwd'"
  end

  local p "paper"
  cap program drop `p'
  program define `p'
    local pwd : pwd
    qui cd "E:\学术论文\"
    qui cdout 
    qui cd "`pwd'"
  end

  local p "down"
  cap program drop `p'
  program define `p'
    local pwd : pwd
    qui cd "F:\DownLoad\chrome"
    qui cdout 
    qui cd "`pwd'"
  end

*----------------- 
*-快速打开常用程序
*----------------- 
* 定义一些小程序，在命令窗口中输入几个字母便可打开指定文件
  local p "music"
  cap program drop `p'
  program define `p'
    args musicname    
    local pwd : pwd
    preserve
    qui cd "F:\Kugou\已下载"    
    cap postclose muspost
    postfile muspost str100 list1 using muslist.dta,replace
    local musicnames : dir . files "* - *" 
    foreach mus in `musicnames' {
      post muspost ("`mus'")
    }
    postclose muspost
    use muslist.dta,clear
    qui gen x1 = 1 if ustrregexm(list1,"`musicname'")
    qui sum x1
    if `r(sum)'>0 {
    qui keep if x1 == 1
    local play = list1[1]
    local playname = "F:\Kugou\已下载\"+"`play'"
    qui winexec "C:\Program Files (x86)\KuGou2012\KuGou.exe" "`playname'"
    }
    else {
      disp "无此歌曲"
    }
    qui cd "`pwd'"
    restore
  end

  local p "kugou"
  cap program drop `p'
  program define `p'
    local pwd : pwd
    qui cd "C:\Program Files (x86)\KuGou2012" 
    qui winexec "KuGou.exe" "F:\Kugou\已下载\周子雷 - 千年风雅.mp3"
    qui cd "`pwd'"
  end

  local p "quitk"
    cap program drop `p'
    program define `p'
    !taskkill /im KuGou.exe /f
    end

  local p "baidu"
    cap program drop `p'
    program define `p'
      local pwd : pwd
      qui cd "C:\Program Files (x86)\Google\Chrome\Application\"
      qui winexec "chrome.exe" "https://www.baidu.com/"
      qui cd "`pwd'"
    end  

    cap program drop web
    program define web
      args adress
      local pwd : pwd
      qui cd "C:\Program Files (x86)\Google\Chrome\Application\"
      if regexm("`adress'","\.") {
        qui winexec "chrome.exe" "https://`adress'"
      }
      else {
        qui winexec "chrome.exe" "https://www.`adress'.com/"
      }
      qui cd "`pwd'"
    end 

  local p "quitc"
      cap program drop `p'
      program define `p'
      !taskkill /im chrome.exe /f
      end

/*
*------------------------------------------------------
*----- Stata 15 转码方法(一次性处理 .dta 转码问题) ----
*------------------------------------------------------
*-一次性转换当前工作路径下的所有文件
* 使用方法：在命令窗口中输入 uniall 命令即可。
cap program drop uniall
program define uniall
    *-说明: dofile 或 数据文件中包含中文字符时，需要转码才能正常显示
    *-Step 1: 分析当前工作路径下的编码情况                         
      *unicode analyze *                                         
    *-Step 2: 设定转码类型                                          
      ua: unicode encoding set gb18030  // 中文编码                     
    *-Step 3: 转换文件                                              
      ua: unicode translate *
end  
*/
