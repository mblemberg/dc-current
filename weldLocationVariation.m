clear all; close all;
Rcu = 1.68E-8;     %Ohm-meters
Rman = 4.82E-7;     %Ohm-meters
Rconnect = 0.001;   %Ohms
meshSize = 0.2;   %mm in one direction
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

weldLocations = [5.5 7; 5.5 14; 43.5 6; 52 6];  %[x y] hanover nominal
%weldLocations = [5.5 7; 5.5 14; 52 7; 52 14];  %[x y] if we changed the weld geometry to put the welds at the ends of the shunt

colormap('gray');

%Get the baseline sensed voltage
baselineVoltageMatrix = calcVoltage(current=10*currentConnections([xNodes yNodes], 'rings', meshSize, [weldLocations(1,:), 2 1 1], [weldLocations(2,:), 2 1 1], [weldLocations(3,:), 2 1 -1], [weldLocations(4,:), 2 1 -1]), Rh, Rv, Rconnect);
baselineSenseVoltage = baselineVoltageMatrix(sensePointIndices(2),sensePointIndices(1)) - baselineVoltageMatrix(sensePointIndices(4),sensePointIndices(3));
subplot(3,2,1); imagesc(current); title('Connections'); axis('image'); axis("noLabel");
subplot(3,2,3); imagesc(idensity=currentMap(baselineVoltageMatrix, Rh, Rv)); title('Current'); axis('image'); axis("noLabel");
subplot(3,2,5); imagesc(baselineVoltageMatrix); title('Voltage'); axis('image'); axis("noLabel");

%Get the sensed voltage for the shifted weld locations
weldLocations(:, 2) += 2;

shiftedVoltageMatrix = calcVoltage(current=10*currentConnections([xNodes yNodes], 'rings', meshSize, [weldLocations(1,:), 2 1 1], [weldLocations(2,:), 2 1 1], [weldLocations(3,:), 2 1 -1], [weldLocations(4,:), 2 1 -1]), Rh, Rv, Rconnect);

shiftedSenseVoltage = shiftedVoltageMatrix(sensePointIndices(2),sensePointIndices(1)) - shiftedVoltageMatrix(sensePointIndices(4),sensePointIndices(3));

subplot(3,2,2); imagesc(current); title('Connections'); axis('image'); axis("noLabel");
subplot(3,2,4); imagesc(idensity=currentMap(shiftedVoltageMatrix, Rh, Rv)); title('Current'); axis('image'); axis("noLabel");
subplot(3,2,6); imagesc(shiftedVoltageMatrix); title('Voltage'); axis('image'); axis("noLabel");
text(0, -4, ["Measured current changed by " num2str(100*(shiftedSenseVoltage - baselineSenseVoltage)/baselineSenseVoltage) "%"]);
print -dpdf -color plots.pdf

