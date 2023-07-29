function []=theorem_2(f,c,t,y,M,rho,i) 
% input-原函数f
%           插值多项式系数c
%          -测试结点t
%          -多项式y
% rho=(1+sqrt(26))/5;
n=length(c);
k=1:n;
s=2*M*rho.^(-k+1);s(1)=M;
figure(6);subplot(2,2,i-3);
scatter(k,abs(c),16,'red');hold on;
scatter(k,s,16,'blue');
xlim([0 2^i]);ylim([0 1]);
error=max(abs(f(t)-y))-4*M*rho^(-n+1)/(rho-1);
if error<=0
    fprintf("N=%d时，定理2验证成立。\n",2^i);
else
    fprintf("N=%d时，定理2验证不成立。\n",2^i);
end
end