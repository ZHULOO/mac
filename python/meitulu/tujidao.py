def get_jigou(url,n):
    import os
    os.chdir(r'E:\MyGit\python\meitulu')
    from meitulu3 import get_pics
    for i in range(1,n):
        get_pics(url+"&page="+str(i))