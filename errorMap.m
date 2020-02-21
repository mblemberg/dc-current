function errorMap = errorMap (input1, input2)
  
  Rcu = 1.68E-2;    %uOhm-meters
  Rman = 48.2E-2;   %uOhm-meters
  Rconnect = 1E-3;  %Ohms
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
  baselineVoltageMatrix = calcVoltage(currentConnections([xNodes yNodes], 'ends', meshSize), Rh, Rv, Rconnect);
  baselineSenseVoltage = baselineVoltageMatrix(sensePointIndices(2),sensePointIndices(1)) - baselineVoltageMatrix(sensePointIndices(4),sensePointIndices(3));
  
  %Calculate the sensed voltage for each injection point on one side of the shunt
  errorMatrix = zeros(yNodes, xNodes);
  h = waitbar((progress=0)/(total=xNodes*yNodes), "Calculating error at each injection point...");
  for (i = 1:yNodes)
    for (j = 1:floor(manganinBoundaries(1)/meshSize))
      current = currentConnections([xNodes yNodes], 'ends', meshSize, 0, 1);
      current += currentConnections([xNodes yNodes], 'indices', [i, j, 1]);
      senseVoltageMatrix = calcVoltage(current, Rh, Rv, Rconnect);
      senseVoltage = senseVoltageMatrix(sensePointIndices(2),sensePointIndices(1)) - senseVoltageMatrix(sensePointIndices(4),sensePointIndices(3));
      errorMatrix(i,j) = 100*(senseVoltage - baselineSenseVoltage)/baselineSenseVoltage;
      waitbar(++progress/total), h);
    endfor
  endfor
  close(h);

  
  %Plot the difference between the ideal voltage and the varied injection points
  
  
  
endfunction
