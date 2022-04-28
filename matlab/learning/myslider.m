% 嵌套函数完全包含在另一函数内。嵌套函数与局部函数的主要区别是，嵌套函数可以使用
% 在父函数内定义的变量，无需将这些变量作为参数显式传递。
function myslider
value = 0;
f = figure;
s = uicontrol(f,'Style','slider','Callback',@slider);
e = uicontrol(f,'Style','edit','Callback',@edittext,...
                'Position',[100,20,100,20]);

   function slider(obj,~)
      value = obj.Value;
      e.String = num2str(value);
   end
   function edittext(obj,~)
      value = str2double(obj.String);
      s.Value = value;
   end

end

% 创建一个函数，该函数允许您使用滑块或可编辑的文本框设置介于 0 与 1 之间的一个值。
% 如果您将嵌套函数用于回调，滑块和文本框可以共享值和彼此的句柄，无需显式传递它们：

%%子文件夹中的私有函数
% 与局部或嵌套函数一样，私有函数仅供特定位置的函数访问。但是，私有函数与可以调用它
% 们的函数不在同一个文件中。它们位于名称为 private 的子文件夹中。仅 private 文件
% 夹紧邻的上一级文件夹内的函数可使用私有函数。使用私有函数将代码分割为不同的文件，
% 或在多个相关函数间共享代码。