function ret = currentConnections(varargin)
  
  xNodes = varargin{1}(1);
  yNodes = varargin{1}(2);
  
  connectionType = varargin{2};
  meshSize = varargin{3};
  
  ret = zeros(yNodes, xNodes);
  
  switch connectionType
    case 'ends'
      %First additional argument is 1 if the left hand side should be set, 0 otherwise
      %Second additional argument is 1 if the right hand side should be set, 0 otherwise
      if (varargin{4}); ret(:,1) = 1; endif;
      if (varargin{5}); ret(:,xNodes) = -1; endif; 
    case 'points'
      %Each additional argument is of the form [x y I] for points in mm
      for(i = 4:nargin) 
        ret(floor(varargin{i}(2)/meshSize)+1, floor(varargin{i}(1)/meshSize)+1) = varargin{i}(3);
      endfor
    case 'indices'
      %Each additional argument is of the form [x y I] for points in terms of the indices
      for(i = 4:nargin)
        ret(varargin{i}(2), varargin{i}(1)) = varargin{i}(3);
      endfor
    case 'circles'
      %Each additional argument is of the form [x y r I]
      for i = 1:yNodes
        for j = 1:xNodes
          for k = 4:nargin
            if ((j-varargin{k}(1)/meshSize-1)^2 + (i-varargin{k}(2)/meshSize-1)^2 <= (varargin{k}(3)/meshSize)^2)
              ret(i,j) = varargin{k}(4);
            endif
          endfor
        endfor
      endfor
    case 'csv'
      %Argument is the filename
      ret = csvread(varargin{4});

  endswitch

endfunction
