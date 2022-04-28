## `apm config list`

```
; cli configs
globalconfig = "C:\\Users\\lx\\.atom\\.apm\\.apmrc"
metrics-registry = "https://registry.npmjs.org/"
scope = ""
user-agent = "npm/6.2.0 node/v10.2.1 win32 x64"
userconfig = "C:\\Users\\lx\\.atom\\.apmrc"

; globalconfig C:\Users\lx\.atom\.apm\.apmrc
cache = "C:\\Users\\lx\\.atom\\.apm"
progress = false

; node bin location = D:\Program Files\Atom\Atom x64\resources\app\apm\bin\node.exe
; cwd = C:\Users\lx
; HOME = C:\Users\lx
; "npm config ls -l" to show all defaults.
```

## `npm config list`

```
; cli configs
metrics-registry = "https://registry.npmjs.org/"
scope = ""
user-agent = "npm/6.13.7 node/v13.9.0 win32 x64"

; node bin location = D:\Anaconda\node.exe
; cwd = C:\Users\lx
; HOME = C:\Users\lx
; "npm config ls -l" to show all defaults.
```

## 添加淘宝镜像后:
```
apm config set registry http://registry.npm.taobao.org
apm config list
```
```
; cli configs
globalconfig = "C:\\Users\\lx\\.atom\\.apm\\.apmrc"
metrics-registry = "http://registry.npm.taobao.org/"
scope = ""
user-agent = "npm/6.2.0 node/v10.2.1 win32 x64"
userconfig = "C:\\Users\\lx\\.atom\\.apmrc"

; userconfig C:\Users\lx\.atom\.apmrc
registry = "http://registry.npm.taobao.org/"

; globalconfig C:\Users\lx\.atom\.apm\.apmrc
cache = "C:\\Users\\lx\\.atom\\.apm"
progress = false

; node bin location = D:\Program Files\Atom\Atom x64\resources\app\apm\bin\node.exe
; cwd = C:\Users\lx
; HOME = C:\Users\lx
; "npm config ls -l" to show all defaults.
```
