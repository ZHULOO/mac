# MAC使用
## 一、环境变量配置
- 一般bash环境变量保存在～/.bashrc中；
  - 如果修改.bashrc文件，zsh终端中依然不能直接使用，需要在.zshrc中添加source .bashrc语句；
- 而mac默认使用zsh终端，环境变量信息保存在～/.zshrc，直接编辑.zshrc添加：
- 以python为例添加环境变量：
  - vim打开.zshrc添加：`export PATH="/opt/anaconda3/envs/geo/bin:$PATH"`语句，然后运行`source .zshrc`生效；
