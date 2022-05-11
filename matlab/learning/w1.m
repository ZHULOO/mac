% 文件3  模拟最小距离估计的w矩阵w1.m
%计算模拟最小距离估计中的矩阵w,用于和参数作内积
function fun=w1(playeri,cost,dis)
%它是两个值函数之差,一个有扰动,一个没扰动,调用v0函数
    fun=v1(playeri,cost,0)-v1(playeri,cost,dis);
end

%计算i在cost下的平均收益,dis是策略函数的扰动,策略已经给定了
%采用第一步的非参数策略
%非iid抽样,改用对偶方法,对偶4次
function fun = v1(playeri,cost,dis)
    maxiter=40;%计算平均收益的迭代次数
    shock1=rand(maxiter/4,1)-0.5;
    shock2=rand(maxiter/4,2)-0.5;
    shock=[shock1,shock2;
    -shock1,-shock2;
    shock1,-shock2;
    -shock1,shock2];
    fun=zeros(1,3);
    for i=1:maxiter
        actioni=bestaction(playeri,cost,shock(i,playeri))+dis;
        sumaction=actioni+bestaction(3-playeri,cost,shock(i,3-playeri));
        fun(1)=fun(1)+actioni;
        fun(2)=fun(2)+actioni*sumaction;
        fun(3)=fun(3)+actioni*(cost(playeri)-shock(i,playeri));
    end
    fun=fun/maxiter;
end


function fun=bestaction(playeri,cost,shock)
    % a0=5; %initial value
    global ACTION COST
    alpha=shock+0.5;
    fun=fminsearch(@objfun,5);
    %计算分位数需要min的目标函数,见Li Qi page p193
        function y = objfun(a)
        %fun0=zeros(400,1),
        %temp=1.509*(COST-repmat(cost,50,1));
        temp=1.509*[COST(:,1)-cost(1,1),COST(:,2)-cost(1,2)];
        temp2=normpdf(temp);
        %temp2=normpdf(1.509*[COST(:,1)-cost(1,1),COST(:,2)-cost(1,2)]);
        temp3=ACTION(:,playeri)-a;
        fun0=temp3.*(alpha- (temp3<0)).*temp2(:,1).* temp2(:,2);
        %fun0=(ACTION(:,playeri)-a).*(alpha-((ACTION(:,playeri)-a)<0)).*normpdf(1.509*(COST(:,1)-cost(1,1))).*normpdf(1.509*(COST(:,2)-cost(1,2)));
        %*temp2(:,2);
        y=2.277081*sum(fun0);
        end
end


%计算分位数需要min的目标函数,见Li Qi page p193
%function fun = objfun(playeri,cost,alpha,a)
%global ACTION COST
%fun0=zeros(400,1);
%temp2=normpdf(1.509*[COST(:,1)-cost(1,1),COST(:,2)-cost(1,2)]);
%fun0=(ACTION(:,playeri)-a).*(alpha-((ACTION(:,playeri)-a)<0)).*temp2(:,1).*temp2(:,2);
%fun=2.277081*sum(fun0);
%end

%fun = fun+(ACTION(t,playeri)-a)*(alpha-((ACTION(t,playeri)-a)<0))*1.9011^2*normpdf((COST(t,1)-cost(1,1))*1.9011)*normpdf((COST(t,2)-cost(1,2))*1.9011);
%f0 = (ACTION(t,playeri)-a)*(alpha-((ACTION(t,playeri)-a)<0));
%fun = 1.9011^2*normpdf((COST(t,1)-cost(1,1))*1.9011)*normpdf((COST(t,2)-cost(1,2))*1.9011);

%function f0=ea(alpha,shock)
%f0=shock*(alpha-(shock<=0));
%end

%计算wh函数,第一步的非参数估计需要使用,见Li Qi的公式
%function fun=wh(t,cost)
%global COST;
%ih=1.9011;%1/bandwidth
%fun=ih*ih*normpdf((COST(t,1)-cost(1,1))*ih)*normpdf((COST(t,2)-cost(1,2))*ih);
%end