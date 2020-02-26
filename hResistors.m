function ret = hResistors(xNodes, yNodes, meshSize, manganinBoundaries, Rman, Rcu, zDimCu, zDimMan)
  ret = ones(yNodes, xNodes-1).*(1000*Rcu/zDimCu);
  ret(1:yNodes,floor(manganinBoundaries(1)/meshSize)+1:floor(manganinBoundaries(2)/meshSize))=Rman*1000/zDimMan;
endfunction