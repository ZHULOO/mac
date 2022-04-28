function X=updateinv(X,p,b)
%此函数用来计算A矩阵的第p列被b向量替代后，其逆的更新
[n,~]=size(X);
d=X*b;
if abs(d(p))<eps
    waring("替换后的矩阵是奇异的");
    newinvA=[];
    return;
else
    %对A的逆做相应的行变换；
    X(p,:)=X(p,:)/d(p);
    if p>1
        for i=1:p-1
            X(i,:)=X(i,:)-X(p,:)*d(i);
        end
    end
    if p<n 
        for i=p+1:n
            X(i,:)=X(i,:)-X(p,:)*d(i);
        end
    end
end
    