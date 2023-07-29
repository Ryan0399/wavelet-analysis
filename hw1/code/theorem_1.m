function []=theorem_1(f,c,t,y,V,m,i)
% input-原函数f
%           插值多项式系数c
%          -测试结点t
%          -全变差V
%          -导数阶m
%          -多项式y
n=length(c);
k=m+1:n-1;
s=2*V./(pi*(k-m).^(m+1));
figure(4);subplot(2,2,i-3);
scatter(k,abs(c(k+1)),16,'red');hold on;
scatter(k,s(k-m),16,'blue');
xlim([m 2^i]);ylim([0 1]);
error=max(abs(f(t)-y))-4*V/(pi*m*(n-1-m)^m);
if error<=0
    fprintf("N=%d时，定理1验证成立。\n",2^i);
else
    fprintf("N=%d时，定理1验证不成立。\n",2^i);
end
end
