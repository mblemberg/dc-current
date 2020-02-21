function ret = vResistors(xNodes, yNodes, meshSize, manganinBoundaries, Rman, Rcu, zDim)
  ret = ones(yNodes-1, xNodes).*(1000*Rcu/zDim);
  ret(1:yNodes-1,floor(manganinBoundaries(1)/meshSize)+2:floor(manganinBoundaries(2)/meshSize))=Rman*1000/zDim;
endfunction