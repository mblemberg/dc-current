function errorMap = errorMap (input1, input2)
  
  Rcu = 1.68E-2;    %uOhm-meters
  Rman = 48.2E-2;   %uOhm-meters
  meshSize = 0.5;   %mm in one direction
  xDim = 84;        %mm
  yDim = 20;        %mm
  zDim = 3;         %mm
  manganinBoundaries = [36 46];   %mm from left edge
  sensePoints = [32 16 50 16];
  
  xNodes = floor(xDim/meshSize)+1;
  yNodes = floor(yDim/meshSize)+1;
  
  Rh = hResistors(xNodes, yNodes, meshSize, manganinBoundaries,Rman, Rcu, zDim);
  Rv = hResistors(xNodes, yNodes, meshSize, manganinBoundaries,Rman, Rcu, zDim);
  
  sensePointIndices = floor(sensePoints./meshSize);
  
  %Get the baseline sensed voltage for an edge-connected shunt
  
  %Calculate the sensed voltage for each injection point on one side of the shunt
  
  %Plot the difference between the ideal voltage and the varied injection points
  
  
  
endfunction
