function ret = currentConnections(varargin)
  
  xNodes = varargin{1}(1);
  yNodes = varargin{1}(2);
  
  type = varargin{2};
  
  ret = zeros(yNodes, xNodes);
  
  switch type
    case 'ends'
      ret(:,1) = 1;
      ret(:,yNodes) = -1;
  case 'points'
      
    
    
  endswitch
      
  
  
  
endfunction
