%% 文件中的局部函数和嵌套函数；
% 局部函数是在同一文件中可用的子例程。局部函数是拆分编程任务的最常见方法。在仅包含
% 函数定义的函数文件中，局部函数可以任意顺序出现在文件中主函数的后面。在包含命令和
% 函数定义的脚本文件中，局部函数必须位于文件末尾。（R2016b 或更高版本支持脚本中的
% 函数。）

% 例如，创建一个名为 myfunction.m 的函数文件，其中包含主函数 myfunction 以及两个
% 局部函数 squareMe 和 doubleMe：

function b = myfunction(a)
   b = squareMe(a)+doubleMe(a);
end
function y = squareMe(x) %后面两个为局部函数，仅限于 myfunction主函数使用；不可直接调用
   y = x.^2;
end
function y = doubleMe(x) 
   y = x.*2;
end

% 可以从命令行或另一程序文件中直接调用主函数，但局部函数仅适用于 myfunction：

