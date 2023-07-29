clc
clear

load tartan
% 读取图像
im = rgb2gray(imread("boy.jpg"));
% im=uint8(X);
% x = [0, 0]; y = [size(im, 1), -size(im, 2)];
% 小波变换
[c, s] = wavedec2(im, 2, 'coif2');

% 对小波系数进行阈值处理
thr=ddencmp('den','wp',c);
c(abs(c)<thr) = 0;


[H1, V1, D1] = detcoef2('all', c, s, 1);
[H2, V2, D2] = detcoef2('all', c, s, 2);
A2 = appcoef2(c, s, 'coif2', 2);

% 显示结果
subplot(2, 4, 1), imshow(im), title('原图');
subplot(2, 4, 2), image(wcodemat(H1, 512)), axis image, axis off, title('水平方向1层');
subplot(2, 4, 3), image(wcodemat(V1, 512)), axis image, axis off, title('垂直方向1层');
subplot(2, 4, 4), image(wcodemat(D1, 512)), axis image, axis off, title('对角线方向1层');
subplot(2, 4, 5), image(wcodemat(H2, 512)), axis image, axis off, title('水平方向2层');
subplot(2, 4, 6), image(wcodemat(V2, 512)), axis image, axis off, title('垂直方向2层');
subplot(2, 4, 7), image(wcodemat(D2, 512)), axis image, axis off, title('对角线方向2层');
subplot(2, 4, 8), image(wcodemat(A2, 512)), axis image, axis off, title('近似系数2层');
colormap("bone")


% 进行小波重构
recon_img = waverec2(c, s, 'coif2');

% 对处理后的图像进行边缘检测
edge_img = edge(recon_img, "canny_old");
% edge_img=edge(H1|V1|D1,'canny_old');

% 显示结果
figure(2);
subplot(1,2,1), imshow(im), title('原图');
subplot(1,2,2), imshow(edge_img), title('边缘检测结果');