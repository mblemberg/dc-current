function errorMap = errorMap (meshSize)
  
  Rcu = 1.68E-8;     %Ohm-meters
  Rman = 4.82E-7;     %Ohm-meters
  Rconnect = 1;   %Ohms
  %meshSize = 2;   %mm in one direction
  xDim = 60;        %mm
  yDim = 22.5;        %mm
  zDimCu = 3;         %mm
  zDimMan = 2.5;      %mm
  manganinBoundaries = [26 34];   %mm from left edge
  sensePoints = [24 14 36 14];
  
  xNodes = floor(xDim/meshSize)+1;
  yNodes = floor(yDim/meshSize)+1;
  
  Rh = hResistors(xNodes, yNodes, meshSize, manganinBoundaries,Rman, Rcu, zDimCu, zDimMan);
  Rv = vResistors(xNodes, yNodes, meshSize, manganinBoundaries,Rman, Rcu, zDimCu, zDimMan);
  
  sensePointIndices = floor(sensePoints./meshSize)+1;
  
  %Get the baseline sensed voltage for an edge-connected shunt
  baselineVoltageMatrix = calcVoltage(10*currentConnections([xNodes yNodes], 'circles', meshSize, [13 10 10 1], [47 10 10 -1]), Rh, Rv, Rconnect);
  baselineSenseVoltage = baselineVoltageMatrix(sensePointIndices(2),sensePointIndices(1)) - baselineVoltageMatrix(sensePointIndices(4),sensePointIndices(3));

  %Calculate the sensed voltage for each injection point on one side of the shunt
  errorMatrix = zeros(yNodes, floor(manganinBoundaries(1)/meshSize));
  h = waitbar((progress=0)/(total=yNodes*floor(manganinBoundaries(1)/meshSize)), "Calculating error at each injection point...");
  for (i = 1:yNodes)
    for (j = 1:floor(manganinBoundaries(1)/meshSize))
      current = 10*currentConnections([xNodes yNodes], 'circles', meshSize, [47 10 10 -1]);
      current += 10*currentConnections([xNodes yNodes], 'indices', meshSize, [j, i, 1]);
      senseVoltageMatrix = calcVoltage(current, Rh, Rv, Rconnect);
      senseVoltage = senseVoltageMatrix(sensePointIndices(2),sensePointIndices(1)) - senseVoltageMatrix(sensePointIndices(4),sensePointIndices(3));
      errorMatrix(i,j) = 100*(senseVoltage - baselineSenseVoltage)/baselineSenseVoltage;

      figure(1);
      subplot(2,2,1); surf(current); title('Connections'); xlim([0 xNodes]); ylim([0 xNodes]);
      subplot(2,2,2); surf(currentMap(senseVoltageMatrix, Rh, Rv)); title('Current'); xlim([0 xNodes]); ylim([0 xNodes]);
      subplot(2,2,3); surf(senseVoltageMatrix); title('Voltage'); xlim([0 xNodes]); ylim([0 xNodes]);
      subplot(2,2,4); surf(errorMatrix); title('Error'); xlim([0 xNodes]); ylim([0 xNodes]);
      pause(0.001);

      waitbar(++progress/total, h);
    endfor
  endfor
  close(h);

  %Plot the difference between the ideal voltage and the varied injection points
  
  errorMap = flipud(errorMatrix);
  
endfunction