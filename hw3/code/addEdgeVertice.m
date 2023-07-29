function vNIndex = addEdgeVertice(v1Index, v2Index, v3Index)
	global edgeVertice;
	global newIndexOfVertices;
	if (v1Index>v2Index) % setting: v1 <= v2
		vTmp = v1Index;
		v1Index = v2Index;
		v2Index = vTmp;
    end
	
	if (edgeVertice(v1Index, v2Index, 1)==0)  % new vertex
		newIndexOfVertices = newIndexOfVertices+1;
		edgeVertice(v1Index, v2Index, 1) = newIndexOfVertices; % 新加入顶点的编号
		edgeVertice(v1Index, v2Index, 2) = v3Index; % 边(v1Index,v2Index)对着的第一个顶点v3Index
	else
		edgeVertice(v1Index, v2Index, 3) = v3Index; % 表示边(v1Index,v2Index)已经被使用过，v3Index是其对着的第二个顶点
    end
	vNIndex = edgeVertice(v1Index, v2Index, 1);% 返回新加入顶点编号
end
