clc
clear

f=@(x) abs(sin(6*x)).^3-cos(5*exp(x));
g=@(x) 1./(1+25*x.^2)-sin(20*x);
% T=@(i,N) -cos((i+1)./(N+2)*pi);
% t=0:100;t=T(t,100);
t=linspace(-1,1,101); % 采样点
figure(1);
plot(t,f(t),'k');hold on;
figure(2);
plot(t,g(t),'k');hold on;
ord=@(o,n) log(o/n)/log(2); % 误差阶函数
error1=zeros(1,4);error2=zeros(1,4);
for i=4:7
    N=2^i;
    [y_1,c_1]=chebyshevPolynomial(f,N,t);
    [y_2,c_2]=chebyshevPolynomial(g,N,t);
    figure(3);subplot(2,2,i-3)
    plot(t,real(y_1),'--');hold on;
    theorem_1(f,c_1,t,y_1,45460,3,i); % 验证定理1
    error1(i-3)=max(abs(y_1-f(t))); 
    figure(5);subplot(2,2,i-3)
    plot(t,real(y_2),'-.');hold on;
    theorem_2(g,c_2,t,y_2,2,(1+sqrt(26))/5,i); % 验证定理2
    error2(i-3)=max(abs(y_2-g(t)));
end

% 计算并输出误差阶
for i=1:4
    fprintf("%d & ",2^(i+3));
    if i==1
        fprintf("%.5e & %s & %.5e & %s %s\n",error1(i),'-',error2(i),'-','\\');
    else
        fprintf("%.5e & %.4f & %.5e & %.4f %s\n",error1(i),ord(error1(i-1),error1(i)),error2(i),ord(error2(i-1),error2(i)),'\\');
    end
end
