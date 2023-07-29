function vertices = LSLWD(vertices, adjacentMatrix, edgeVertice, fineLine)
    % Loop细分的小波提升的分解算法

    % 引入提升小波的系数矩阵
    load("matrix_coefficient_1.mat");
    load("matrix_coefficient_2.mat");

    d = fineLine; % 用于划分顶点和边点
    % * d: 顶点的最后一个索引
    % * d+1: 边点的第一个索引

    % 使用边点预测顶点坐标
    for v0 = 1:d - 1

        for v1 = v0:d
            e = edgeVertice(v0, v1, 1);

            if e ~= 0

                vertices(v0, :) = updateVi(vertices(v0, :), v0, vertices(e, :), adjacentMatrix);
                vertices(v1, :) = updateVi(vertices(v1, :), v1, vertices(e, :), adjacentMatrix);

            end

        end

    end

    % 对顶点进行放缩
    for i = 1:d
        n = sum(adjacentMatrix(i, :));
        vertices(i, :) = vertices(i, :) / (8 * (3/8 + cos(2 * pi / n) / 4) ^ 2/5);
    end

    % 使用顶点去更新边点坐标
    for v0 = 1:d - 1

        for v1 = 1:d
            e = edgeVertice(v0, v1, 1);

            if e ~= 0
                v2 = edgeVertice(v0, v1, 2);
                v3 = edgeVertice(v0, v1, 3);

                vertices(e, :) = vertices(e, :) - 3 * (vertices(v0, :) + vertices(v1, :)) / 8 - (vertices(v2, :) + vertices(v3, :)) / 8;

            end

        end

    end

    % 确保正交性
    for v0 = 1:d - 1

        for v1 = v0:d
            e = edgeVertice(v0, v1, 1);

            if e ~= 0
                v2 = edgeVertice(v0, v1, 2);
                v3 = edgeVertice(v0, v1, 3);

                n0 = sum(adjacentMatrix(v0, :));
                n2 = sum(adjacentMatrix(v2, :));

                if n0 ~= 6
                    vertices(v0, :) = vertices(v0, :) - matrix_coefficient_1(n0, 1) * vertices(e, :);
                    vertices(v1, :) = vertices(v1, :) - matrix_coefficient_1(n0, 2) * vertices(e, :);
                    vertices(v2, :) = vertices(v2, :) - matrix_coefficient_1(n0, 3) * vertices(e, :);
                    vertices(v3, :) = vertices(v3, :) - matrix_coefficient_1(n0, 3) * vertices(e, :);
                else
                    vertices(v0, :) = vertices(v0, :) - matrix_coefficient_2(n2, 1) * vertices(e, :);
                    vertices(v1, :) = vertices(v1, :) - matrix_coefficient_2(n2, 1) * vertices(e, :);
                    vertices(v2, :) = vertices(v2, :) - matrix_coefficient_2(n2, 2) * vertices(e, :);
                    vertices(v3, :) = vertices(v3, :) - matrix_coefficient_2(n2, 3) * vertices(e, :);
                end

            end

        end

    end

end

function vi = updateVi(vi, i, e, adjacentMatrix)
    n = sum(adjacentMatrix(i, :));
    vi = vi - (1 - 8 * (3/8 + cos(2 * pi / n) / 4) ^ 2/5) / n * e;
end
