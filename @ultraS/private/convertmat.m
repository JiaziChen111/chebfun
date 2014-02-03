function S = convertmat( n, K1, K2 )
%CONVERTMAT  Conversion matrix used in the ultraspherical spectral method.
%
% S = CONVERTMAT( N, K1, K2 ) is a private method for constructing conversion
% matrices. It returns the N-by-N matrix realization of the conversion operator.
% The matrix S maps N coefficients in a C^{(K1)} basis to N coefficients in a
% C^{K2} basis. Here, C^{(K)} is the ultraspherical polynomial basis with
% parameter K.

%  Copyright 2013 by The University of Oxford and The Chebfun Developers.
%  See http://www.chebfun.org for Chebfun information.

%CONVERTMAT(A, K1, K2), convert C^(K1) to C^(K2)
S = speye(n);
for s = K1:K2
    S = spconvert(n, s) * S;
end
end
