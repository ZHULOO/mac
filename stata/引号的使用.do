***help quotes:
	`"   "'  和 "  ",复合引号和普通引号
	`" 表示引号开始
	"' 表示引号结束,复合引号对于比较复杂的字符串(本身含有""的字符串)比较有用;
	disp `A'
	disp "A"
	disp `"A"' 			//复合引号
	disp "`A'"




	disp `"A"B"C"'      // 识别为复合引号`" "'内的内容: A"B"C
	disp "A"B"C" 		//出错,无法识别"
	disp ""A"B"C"" 		//出错,无法识别"
	disp `""A"B"C""' 	// 识别为复合引号`" "'内的内容: "A"B"C"


	local one "1"
	disp `one'
	local two=`one'+1
	disp `two'



	clear 
	set obs 1000
	gen res = rnormal(0,1)
	gen x1 = (_n-1)/(_N-1)*99+1
	gen x2 = rnormal(0,1)
	gen x3 = rnormal(0,1)
	gen y = 2*x1+3*x2+4*x3+res
	
	reg y x1 x2 x3	

	local x "x1 x2 x3"
	disp `x'
	reg y `x'

	local x x1 x2 x3
	disp `x'
	reg y `x'

	local x x1 x2 x3
	reg y `x'

	local x x1 x2 x3
	disp "`x'"
	reg y `x'

	local x x1 x2 x3
	disp "`x'"
	reg y "`x'"

	local x "x1 x2 x3"
	disp `"x"'
	reg y `"x"'

	local x x1 x2 x3
	disp `""`x'""'
	reg y "`x'"

	local x x1 x2 x3
	disp `""`x'""'`""1""'

	local x x1 x2 x3
	disp `""`x'""'    //"1"    `""1""'
	



	local x x1 x2 x3
	disp `x'
	reg y `x'

	



	disp `""absd""' 					//显示带引号的结果: "absd"

	local x = "what"
	disp `""`x'""'
***播放酷狗音乐案例:
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
    qui gen x1 = 1 if ustrregexm(list1,"不了了之")
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


//循环,local局部变量
	local 1 2
	local 2 3
	local 3 4
	disp `1'
	disp `2'
	disp `3'
	disp ```1''' //局部引用符号`',这里有三层引用

	local a 3+3
	disp `a'

	local b 6
	disp b

	local b 6
	disp `b'

	local b string
	disp `b'

	local b string
	disp "`b'"

	local b = 6
	disp `b'



	local a 3+3
	disp "`a'"

	local 1 abc
	local 2 1a
	disp `1'
	disp "`1'"
	disp "`2'"

	local 1 abc
	local 2 1a
	//disp `1'
	disp "`1'"
	disp "`2'"

	local 1 "abc"
	disp "`1'"

	local 1 = abc
	disp "`1'"

	local 1 abc
	disp "`1'"

	local 1 abc
	disp "`1'"




	local 101 1 2 3 10 98
	disp `101'

	//globa全局变量
	global a 3.14
	disp $a //引用用美元符号

	//基本循环
	local i 1
	while `i'<10 {
	disp `i'
	local i =`1'+1
	}
	disp `i'

	forvalue j =1(1) 9 {
	disp `j'
	}
	disp `j'
