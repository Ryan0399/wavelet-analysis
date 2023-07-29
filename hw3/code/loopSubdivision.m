function [newVertices, newFaces] = loopSubdivision(vertices, faces)
    % vertices: 3 * n  顶点:3代表点的坐标(x,y,z)
    % faces: 3 * n     面:3代表三角网格模型中每个三角面顶点，顶点编号为逆时针顺序
    global edgeVertice;
    global newIndexOfVertices;
    newFaces = [];
    newVertices = [];

    nVertices = size(vertices, 2); % 顶点个数
    nFaces = size(faces, 2); % 面的个数
    edgeVertice = zeros(nVertices, nVertices, 3); % 边点矩阵
    newIndexOfVertices = nVertices; % 初始新图形顶点个数

    % ------------------------------------------------------------------------ %
    % 创建一个新的边点矩阵即edgeVertice以及新的三角面newFaces.
    % 时间复杂度 = O(3*nFaces)
    %
    % * edgeVertice(x,y,1): index of the new vertice between (x,y)
    % * edgeVertice(x,y,2): index of the first opposite vertex between (x,y)
    % * edgeVertice(x,y,3): index of the second opposite vertex between (x,y)
    %
    % 一个边最多被两个三角形公用，如果被一个三角形用，那其就是边界，如果被两个三角形共用，就是内部边
    % 原始顶点: va, vb, vc, vd.
    % 新的顶点: vp, vq, vr.
    %
    %        vb                     vb
    %       / \                     /   \
    %     /     \                 vp--vq
    %   /         \              /  \   /  \
    % va ----- vc   ->   va-- vr --vc
    %   \         /              \          /
    %     \     /                  \      /
    %       \ /                      \  /
    %       vd                       vd

    for i = 1:nFaces
        % deal表示分别给vaIndex,vbIndex,vcIndex赋值
        [vaIndex, vbIndex, vcIndex] = deal(faces(1, i), faces(2, i), faces(3, i));
        vpIndex = addEdgeVertice(vaIndex, vbIndex, vcIndex);
        vqIndex = addEdgeVertice(vbIndex, vcIndex, vaIndex);
        vrIndex = addEdgeVertice(vaIndex, vcIndex, vbIndex);

        fourFaces = [vaIndex, vpIndex, vrIndex; vpIndex, vbIndex, vqIndex; vrIndex, vqIndex, vcIndex; vrIndex, vpIndex, vqIndex]';
        newFaces = [newFaces, fourFaces]; %加入新的三角面
    end

    % ------------------------------------------------------------------------ %
    % 更新插入顶点
    for v1 = 1:nVertices - 1

        for v2 = v1:nVertices
            vNIndex = edgeVertice(v1, v2, 1);

            if (vNIndex ~= 0)
                vNOpposite1Index = edgeVertice(v1, v2, 2);
                vNOpposite2Index = edgeVertice(v1, v2, 3);

                if (vNOpposite2Index == 0) % 边界边
                    newVertices(:, vNIndex) = 1/2 * (vertices(:, v1) + vertices(:, v2));
                else % 内部边
                    newVertices(:, vNIndex) = 3/8 * (vertices(:, v1) + vertices(:, v2)) +1/8 * (vertices(:, vNOpposite1Index) + vertices(:, vNOpposite2Index));
                end

            end

        end

    end

    % ------------------------------------------------------------------------ %
    % adjacent vertices (using edgeVertice)
    adjVertice{nVertices} = []; % 定义长度为n的细胞数组，存储每个点的邻接点

    for v = 1:nVertices

        for vTmp = 1:nVertices

            if (v < vTmp && edgeVertice(v, vTmp, 1) ~= 0) || (v > vTmp && edgeVertice(vTmp, v, 1) ~= 0)
                adjVertice{v}(end + 1) = vTmp;
            end

        end

    end

    % ----------------------------------------------------------------------- %
    % new positions of the original vertices
    for v = 1:nVertices
        k = length(adjVertice{v});
        adjBoundaryVertices = []; % 存储边界顶点

        for i = 1:k
            vi = adjVertice{v}(i);

            if (vi > v) && (edgeVertice(v, vi, 3) == 0) || (vi < v) && (edgeVertice(vi, v, 3) == 0)
                adjBoundaryVertices(end + 1) = vi;
            end

        end

        if (length(adjBoundaryVertices) == 2) % 边界边
            newVertices(:, v) = 6/8 * vertices(:, v) +1/8 * sum(vertices(:, adjBoundaryVertices), 2);
        else
            beta = 1 / k * (5/8 - (3/8 +1/4 * cos(2 * pi / k)) ^ 2);
            newVertices(:, v) = (1 - k * beta) * vertices(:, v) + beta * sum(vertices(:, (adjVertice{v})), 2);
        end

    end

end
