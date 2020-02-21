function resistorProduct = resistorProduct(x, y, Rh, Rv)
  resistorProduct = 1;

  if (x>1)
    resistorProduct *= Rh(y,x-1);
  endif
  
  if (x<size(Rv,2))
    resistorProduct *= Rh(y,x);
  endif
  
  if (y>1)
    resistorProduct *= Rv(y-1,x);
  endif
  
  if (y<=size(Rv,1))
    resistorProduct *= Rv(y,x);
  endif
  
endfunction
