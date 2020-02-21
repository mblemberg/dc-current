function voltage = calcVoltage(currentInjection, Rh, Rv, Ri)
  %currentInjection is a matrix where each node of the shunt is marked with a 1 or -1.
  %1 for current source, -1 for current sink
  %Rh is the matrix of horizontal resistances in the shunt grid
  %Rv is the matrix of vertical resistances in the shunt grid
  %Ri is the resistance of each connection to the current source/sink
  
  nNodes = size(Rh,1)*size(Rv,2)+1; %Number of nodes, plus one for the current source
  resistances = zeros(nNodes);      %A square matrix for resistance between each node
  voltages = zeros(nNodes,1);       %A column vector for the node voltages
  
  for j = 1:nNodes-1;
    x = mod(j, size(Rv,2));  %x node within shunt resistor grid
    if (x==0); x = size(Rv,2); endif;
    y = ceil(j/size(Rv,2));  %y node within shunt resistor grid
    
    %Calculate the product of all connecting resistors
    prodResistances = resistorProduct(x, y, Rh, Rv);
    if (currentInjection(y,x) != 0); prodResistances *= Ri; endif;

    %Calculate the term for resistances(j,j)
    if(x>1);                  resistances(j,j) -= prodResistances/Rh(y, x-1); endif;
    if(x<=size(Rh,2));        resistances(j,j) -= prodResistances/Rh(y, x);   endif;
    if(y>1);                  resistances(j,j) -= prodResistances/Rv(y-1, x); endif;
    if(y<=size(Rv,1));        resistances(j,j) -= prodResistances/Rv(y, x);   endif;
    if (currentInjection(y,x) != 0);
      resistances(j,j) -= prodResistances/Ri;
    endif;
    
    %For each of the neighboring nodes, calculate resistance matrix terms as well
    if (x>1)
      resistances(j, j-1) = prodResistances/Rh(y,x-1);
    endif
    
    if (x<=size(Rh,2))
      resistances(j,j+1) = prodResistances/Rh(y,x);
    endif
    
    if (y>1)
      resistances(j,j-size(Rv,2)) = prodResistances/Rv(y-1,x);
    endif
    
    if (y<=size(Rv,1))
      resistances(j,j+size(Rv,2)) = prodResistances/Rv(y,x);
    endif
    
    if (currentInjection(y,x) > 0)
      resistances(j,nNodes) = prodResistances/Ri;
    endif
 
  endfor
  
  %Need to update the last two rows, for the current source/sink
  resistances(nNodes,nNodes)  = -1*sum(currentInjection(:)>0)/Ri;
  
  %Now for every connection to the current source/sink, make the term for that node = 1/Ri
  for (i=1:size(Rh,1))
    for (j=1:size(Rv,2))
      if (currentInjection(i,j)>0)
        resistances(nNodes, (i-1)*size(Rv,2)+j) = 1/Ri;
      endif
    endfor
  endfor
  
  %Generate the current column vector
  currents = zeros(nNodes,1);
  currents(nNodes)   = -1*max(currentInjection(:));
  
  voltage = resistances\currents;
  voltage = reshape(voltage(1:nNodes-1), size(Rv,2), size(Rh,1))';
  
endfunction
