% 文件2主程序mainfile.m
function [] = mainfile()

%-----------  %主文件,完成以下几项任务
%1,生成数据
%2,第一步估计
%3,第二步估计
%4,计算se
    clear;
    clc;
    global ACTION COST N LCOST HCOST ww
    tic; %计时
%-------part 1 Below-----------------------------
    load rawdata.mat;%  载入原始数据
    thetapara=zeros(2,B);
    for jb = 1:B
        COST=COST0(:,:,jb);
        ACTION=ACTION0(:,:,jb);
    end
%%检查语句,保证生产的数据正常,player=2时可用使用
%scatter3(COST(:,1),COST(:,2),ACTION(:,1),'o');
%hold on;
%scatter3(COST(:,1),COST(:,2),ACTION(:,2),'+');
%close all;
%scatter3(COST(:,1),COST(:,2),PROFIT(:,1),'o');
%hold on;
%scatter3(COST(:,1),COST(:,2),PROFIT(:,2),'+');


%----------------part 2->bestaction(i,s,v)--------------
%Form: bestaction i= bestaction(playeri,cost,shock)

%检查bestaction函数是否正确
    cost0=[6,8];
    shock1=2;
    shock2=1;
%bestaction是非参数估计出的策略函数
    a1 = bestaction(1,cost0,shock1)
    a2 = bestaction(2,cost0,shock2)
%trueaction是解析方法计算的真正的策略函数
    trueaction1 = trueaction(1,cost0,shock1)
    trueaction2 = trueaction(2,cost0,shock2)
%测试通过
%------------------------part 3->min V(.)---------------------------------
%抽很多样本基于解析策略函数的估计
    ni=200;
    drawplayer=unidrnd(N,ni,1);
    drawcost=unifrnd(LCOST,HCOST,ni,N);
%drawdis是对策略的扰动
    drawdis=randn(ni,1);
%%计算与样本相对于的W
    global ww
    ww=zeros(ni,3);
    for i=1:ni
      ww(i,:)=w1(drawplayer(i,1),drawcost(i,:),drawdis(i,1));
    end
    theta0=[20;-0.5];
    theta1=[25;-1];
    qn(theta0)
    qn(theta1)
    x=fminsearch(@qn,theta0)


%-----------------part 4->min V(.)---------------------------------
%基于stepl的非参数策略函数的估计
    ni=100;
    drawplayer=unidrnd(N,ni,1);
    drawcost=unifrnd(LCOST,HCOST,ni,N);
%dis是对策略的扰动
    drawdis=randn(ni,1);
%计算与样本相对于的W
    ww=zeros(ni,3);
    disp('jb=');
    disp(jb);
    for i=1:ni
        ww(i,:)=w1(drawplayer(i,1),drawcost(i,:),drawdis(i,1));
    end
    theta0=[50;-2];
%qn0=qn(theta0)
    thetapara(:,jb)=fminsearch(@qn,theta0);
    save mainresult.mat
end %end jb

%%------------------finish mainfile---------------
%Qn函数,优化的对象
function  fun=qn(theta)
    global ww
    temp=[theta;-1];
    g=ww*temp;
    fun=mean((g<0).*g.^2);
end

function fun=bestaction(playeri,cost,shock)
    a0=5; %initial value
    global ACTION COST
    alpha=normcdf(shock,0,1);
    fun=fminsearch(@objfun,5);
        function y=objfun(a)
        fun0=zeros(400,1),
        temp2=normpdf(1.509*[COST(:,1)-cost(1,1),COST(:,2)-cost(1,2)]);
        fun0=(ACTION(:,playeri)-a).*(alpha==((ACTION(:,playeri)-a)<0)).*temp2(:,1).*temp2(:,2);
        temp2=normpdf(1.509*[COST(:,1)-cost(1,1),COST(:,2)-cost(1,2)]);
        fun0=(ACTION(:,playeri)-a).*(alpha-((ACTION(:,playeri)-a)<0)).*normpdf(1.509*(COST(:,1)-cost(1,1))).*normpdf(1.509*(COST(:,2)-cost(1,2)));
        %*temp2(:,2);
        y=2.277081*sum(fun0);
        end
end

function fun=trueaction(playeri,cost,shock)
    N=2;
    P0=25;
    fun=P0/(N+1)-cost(playeri)+sum(cost)/(N+1)+shock/2;
end