function f = simplify( f ) 
% Simplify a SEPARABLEAPPROX
% 
% F = SIMPLIFY( F ) compressed the representation of F to one that is
% numerically the same, but requires fewer parameters to store. Currently this
% simplifies the polynomial degree of F, but not the rank. 

% Copyright 2014 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.

% Simplify the column and row slices. 
f.cols = simplify( f.cols ); 
f.rows = simplify( f.rows ); 

% TODO: Simplify the rank 

end 
