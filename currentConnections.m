function ret = currentConnections(varargin)
  
  xNodes = varargin{1}(1);
  yNodes = varargin{1}(2);
  
  connectionType = varargin{2};
  meshSize = varargin{3};
  
  ret = zeros(yNodes, xNodes);
  
  switch connectionType
    case 'ends'
      ret(:,1) = 1;
      ret(:,yNodes) = -1;
    case 'points'
      %Each additional argument is of the form [x y I]
      for(i = 4:nargin) {
        ret(varargin{2}(2)/meshSize+1, varargin{2}(1)/meshSize+1) = varargin{i}(3);
      }
    case 'circles'
      %Each additional argument is of the form [x y r I]
      


      
    
    
  endswitch
      
  
  
  
endfunction
