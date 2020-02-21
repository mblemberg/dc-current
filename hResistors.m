function ret = hResistors(xNodes, yNodes, meshSize, manganinBoundaries, Rman, Rcu, zDim)
  ret = ones(yNodes, xNodes-1).*(1000*Rcu/zDim);
  ret(1:yNodes,floor(manganinBoundaries(1)/meshSize)+1:floor(manganinBoundaries(2)/meshSize))=Rman*1000/zDim;
endfunction