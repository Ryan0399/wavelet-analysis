clc
clear
dbstop if error

addpath('obj\');
global edgeVertice;

[x, t] = readObj('obj\Ball.obj'); % 读入初始网格

figure(1); subplot(221); trimesh(t, x(:, 1), x(:, 2), x(:, 3), 'edgecolor', 'k'); axis equal; axis off;

%% 对给定的初始网格使用Loop细分进行加密

fineLine1 = size(x, 1);
adjacentMatrix_old1 = zeros(size(x, 1)); % 邻接矩阵

for i = 1:size(t, 1)
    adjacentMatrix_old1(t(i, 1), t(i, 2)) = 1;
    adjacentMatrix_old1(t(i, 2), t(i, 3)) = 1;
    adjacentMatrix_old1(t(i, 3), t(i, 1)) = 1;
end

% 第一次loop细分
[x2, t2] = loopSubdivision(x', t');
x = x2'; t = t2';
edgeVertice1 = edgeVertice;

fineLine2 = size(x, 1);
adjacentMatrix_old2 = zeros(size(x, 1)); % 邻接矩阵

for i = 1:size(t, 1)
    adjacentMatrix_old2(t(i, 1), t(i, 2)) = 1;
    adjacentMatrix_old2(t(i, 2), t(i, 3)) = 1;
    adjacentMatrix_old2(t(i, 3), t(i, 1)) = 1;
end

% [x2, t2] = loopSubdivision(x', t');
% x = x2'; t = t2';
% edgeVertice2=edgeVertice;
%
% fineLine3=size(x,1);
% adjacentMatrix_old3=zeros(size(x,1)); % 邻接矩阵
% for i=1:size(t,1)
%     adjacentMatrix_old3(t(i,1),t(i,2))=1;
%     adjacentMatrix_old3(t(i,2),t(i,3))=1;
%     adjacentMatrix_old3(t(i,3),t(i,1))=1;
% end

% 第二次loop细分
[x2, t2] = loopSubdivision(x', t');
x = x2'; t = t2';
edgeVertice2 = edgeVertice;

adjacentMatrix_new = zeros(size(x, 1)); % 邻接矩阵

for i = 1:size(t, 1)
    adjacentMatrix_new(t(i, 1), t(i, 2)) = 1;
    adjacentMatrix_new(t(i, 2), t(i, 3)) = 1;
    adjacentMatrix_new(t(i, 3), t(i, 1)) = 1;
end

figure(1); subplot(222); trimesh(t, x(:, 1), x(:, 2), x(:, 3), 'edgecolor', 'k'); axis equal; axis off;

%% 对加密后的网格增加噪声
x = addNoiseSignal(x, adjacentMatrix_new);

figure(1); subplot(223); trimesh(t, x(:, 1), x(:, 2), x(:, 3), 'edgecolor', 'k'); axis equal; axis off;

%% 使用Loop细分的提升小波算法进行降噪
% x=LSLWD(x,adjacentMatrix_old3,edgeVertice3,fineLine3);
x = LSLWD(x, adjacentMatrix_old2, edgeVertice2, fineLine2); % 第一层分解
x = LSLWD(x, adjacentMatrix_old1, edgeVertice1, fineLine1); % 第二层分解

% 阈值滤波降噪
vNorm = zeros(length(x), 1);

for i = 1:length(x)
    vNorm(i) = norm(x(i, :));
end

thr = mean(vNorm);

for i = 1:length(x)

    if norm(x(i, :)) < thr * 2
        x(i, :) = [0 0 0];
    end

end

x = LSLWR(x, adjacentMatrix_old1, edgeVertice1, fineLine1); % 第二层重构
x = LSLWR(x, adjacentMatrix_old2, edgeVertice2, fineLine2); % 第一层重构
% x=LSLWR(x,adjacentMatrix_old3,edgeVertice3,fineLine3);
figure(1); subplot(224); trimesh(t, x(:, 1), x(:, 2), x(:, 3), 'edgecolor', 'k'); axis equal; axis off;
