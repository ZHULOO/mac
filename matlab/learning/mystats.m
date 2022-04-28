x = 3;
y = 2;
z = perm(x,y)

function p = perm(n,r) % 脚本中的函数必须位于脚本的结尾，放在前面不行；
    p = fact(n)*fact(n-r);
end

function f = fact(n)
    f = prod(1:n);
end