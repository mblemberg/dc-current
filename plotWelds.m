data = csvread('shuntLocationMeasurements.csv');for shunt=1:size(data,2)  hold on;    %plot A  %ezplot(@(x,y) (x-data(2,shunt)).^2 + (y-data(4,shunt)).^2 - (data(7,shunt)/2).^2)  ezplot(['(x-' num2str(data(2,shunt))])
endfor
