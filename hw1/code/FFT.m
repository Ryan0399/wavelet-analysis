function Y=FFT(y,n)
% input-待变换序列y
%           待变换下标n
% output-DFT结果
if length(n)==1 % 递归到底层时，返回自身
    Y=y(n);
else
    N=length(n);
    n1=n(1:2:end);n2=n(2:2:end);
    Y1=FFT(y,n1);Y2=FFT(y,n2); % 二分法
    Y=zeros(1,N);
    for j=1:N/2 % 蝶形运算合并
        Y(j)=Y1(j)+(cos(2*pi*(j-1)/N)-1i*sin(2*pi*(j-1)/N))*Y2(j);
        Y(j+N/2)=Y1(j)-(cos(2*pi*(j-1)/N)-1i*sin(2*pi*(j-1)/N))*Y2(j);
    end
end
end