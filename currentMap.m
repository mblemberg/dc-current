function currentMap = currentMap(voltage, Rh, Rv)
	xNodes = size(Rv, 2);
	yNodes = size(Rh, 1);
	currentMap = zeros(yNodes, xNodes);

	for (i=1:yNodes)
		for (j=1:xNodes)
			if (i>1);
				current = (voltage(i,j)-voltage(i-1, j))/Rv(i-1, j);
				if (current > 0); currentMap(i, j) += (voltage(i,j)-voltage(i-1, j))/Rv(i-1, j); endif;
			endif;

			if (i<yNodes);
				current = (voltage(i,j)-voltage(i+1, j))/Rv(i, j);
				if (current > 0); currentMap(i, j) += (voltage(i,j)-voltage(i+1, j))/Rv(i, j); endif;
			endif;

			if (j>1);
				current = (voltage(i,j)-voltage(i, j-1))/Rh(i, j-1);
				if (current > 0); currentMap(i, j) += (voltage(i,j)-voltage(i, j-1))/Rh(i, j-1); endif;
			endif;

			if (j<xNodes);
				current = (voltage(i,j)-voltage(i, j+1))/Rh(i, j);
				if (current > 0); currentMap(i, j) += (voltage(i,j)-voltage(i, j+1))/Rh(i, j); endif;
			endif;

		endfor
	endfor

endfunction