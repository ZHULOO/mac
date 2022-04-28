*****便利和娱乐功能:
****日常工作:
***1.打开某个目录:
	local pwd : pwd
    qui cd "D:\Program Files\stata15"
    qui cdout 
	qui cd "`pwd'"
***2.打开音乐:
	*我们通过winexec打开音乐播放器，播放逆流成河，歌曲时长为125秒，我们设置1125秒后关闭播放器，命令如下：
	local play = "周子雷 - 千年风雅.mp3"
    local playname = "F:\Kugou\已下载\"+"`play'"
    disp "`playname'"
    winexec "C:\Program Files (x86)\KuGou2012\KuGou.exe" "`playname'"
	
	winexec "C:\Program Files (x86)\KuGou2012\KuGou.exe" "F:\Kugou\已下载\周子雷 - 千年风雅.mp3"
	sleep 12500
	!taskkill /im KuGou.exe /f
***3.打开chrome:
	winexec "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "https://www.taobao.com/"
	!taskkill /im chrome.exe /f




taskkill:
taskkill用来结束一个或多个任务或进程，可以按进程ID或图像名结束进程。
这是一个dos命令，我们在stata中使用时前面需加上!，
即!taskkill。taskkill的具体命令规则如下：

taskkill [/s Computer] [/u Domain\User [/p Password]]] [/fi FilterName]  ///
[/pid ProcessID]|[/im ImageName] [/f][/t]
对参数进行说明：
/s Computer：指定远程计算机名称或 IP 地址（不能使用反斜杠）。默认值是本地计算机。
/u Domain\User：运行具有由 User 或 Domain\User 指定用户的帐户权限命令。默认值是当前登录发布命令的计算机的用户权限。
/p Password：指定用户帐户的密码，该用户帐户在 /u 参数中指定。
/fi FilterName：指定将要终止或不终止的过程的类型。
/pid ProcessID：指定将终止的过程的过程 ID
/im ImageName：指定将终止的过程的图像名称。使用通配符 (*) 指定所有图像名称。
/f：指定将强制终止的过程。
/t：指定终止与父进程一起的所有子进程，常被认为是“树终止”。
/?：在命令提示符显示帮助。
由上述参数说明可知，关闭音乐播放器命令如下：
!taskkill /im KuGou.exe /f













