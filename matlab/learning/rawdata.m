function[]=rawdata()
    %在一个独立文件中生成数据,存入一个mat文件中,之后的主程序只要调用这个文件生成的
    %原始数据就可以了。方便在mainfile中进行bootstrap操作。
    clear;
    clc;
    global T N B P0 BETA LCOST HCOST %这句千万别删
    B=400; %run MC 400 times
    N=2; %number of players
    T=50; %number of data in each game
    P0=25; %初始的价格,待估参数1
    %
    BETA=-1;
    LCOST=5;
    HCOST=10;
    ACTION0=zeros(T,2,B);
    COST0=zeros(T,2,B);
    PROFIT=zeros(T,2,B);
    for i = 1:B
        [action,cost,profit]=gendata(); %随机的生成数据global variables
        ACTION0(:,:,i)=action;
        COST0(:,:,i)=cost;
        PROFIT(:,:,i)=profit;
    end
    save rawdata.mat
end

function[action,cost,profit]=gendata()
    global N T P0 LCOST HCOST
    cost=unifrnd(LCOST,HCOST,T,N); %generate cost data
    tcost=repmat(sum(cost,2),1,N);           %total cost
    shock=rand(T,N)-0.5;                     %random shock N(0,1)
    action=P0/(N+1)-cost+tcost/(N+1)+shock/2;%均衡策略
    profit=(P0-repmat(sum(action,2),1,N)-cost+shock).*action; %均衡收益
end