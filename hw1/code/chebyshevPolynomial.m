function [s,c] = chebyshevPolynomial(f,N,t)
% input-被插函数f
%           插值结点个数N
%           自变量t
%output-因变量s
%            插值多项式系数c
T=@(n,x) cos(n*acos(x)); % Chebyshev多项式
x=0:N;
x=cos(pi/N*x);
y=f(x);
y=[y y(end-1:-1:2)];n=1:2*N;
%% FFT计算Chebyshev多项式系数
Y=FFT(y,n);
c=zeros(1,N+1);
c(1)=Y(1)/(2*N);
c(2:N)=Y(2:N)/N;
c(N+1)=Y(N+1)/(2*N);
%% 计算Chebyshev多项式
s=zeros(1,length(t));
for j=0:N
    s=s+c(j+1)*T(j,t);
end
end

