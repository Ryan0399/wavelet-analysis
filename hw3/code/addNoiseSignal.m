function newVertices = addNoiseSignal(vertices,adjacentMatrix)
    % 对网格增加一些噪声信号
    % 我们使用Laplace坐标表示当前顶点的法方向，并对其随机添加扰动来达到增加噪声的目的
    nVertice = size(vertices, 1);
    

    % 计算均匀权重的Laplace坐标
    laplaceMatrix = -adjacentMatrix;

    for i = 1:nVertice

        if sum(laplaceMatrix(i, :)) ~= 0
            laplaceMatrix(i, :) = laplaceMatrix(i, :) / abs(sum(laplaceMatrix(i, :)));
            laplaceMatrix(i, i) = 1;
        end

    end

    delta = laplaceMatrix * vertices;

    % 增加噪声
    newVertices = vertices + 4 * randn(nVertice, 3) .* delta;

end
