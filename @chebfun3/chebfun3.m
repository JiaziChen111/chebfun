classdef chebfun3
%CHEBFUN3   CHEBFUN3 class for representing functions on [a,b]x[c,d]x[e,g].
% 
%   Class for approximating functions defined on finite cubes. The 
%   functions should be smooth.
%
%   CHEBFUN3(F) constructs a CHEBFUN3 object representing the function F on
%   [-1, 1] x [-1, 1] x [-1, 1]. F should be a function handle, e.g.,
%   @(x,y,z) x.*y + cos(x).*z, or a tensor of doubles corresponding to 
%   values of a function at points generated by ndgrid. F should be 
%   "vectorized" in the sense that it may be evaluated at a tensor of 
%   points and returns a tensor output. 
%
%   CHEBFUN3(F, 'eps', ep) specifies chebfun3eps to be ep.
%
%   CHEBFUN3(F, [A B C D E G]) specifies a cube [A B] x [C D] x [E G] where
%   the function is defined. A, B, C, D, E and G must all be finite.
%
%   If F is a tensor, F = (f_{ijk}), the numbers f_{ijk} are used as 
%   function values at tensor Chebyshev points of the 2nd kind generated by 
%   ndgrid.
%
%   CHEBFUN3(F, 'equi'), for a discrete tensor of values at equispaced 
%   points in 3D.
%
%   CHEBFUN3(F, [m n p]) returns a representation of a trivariate 
%   polynomial of length (m, n, p), i.e., with degree (m-1) in x, degree 
%   (n-1) in y and degree (p-1) in z. The polynomial is compressed in low 
%   multilinear rank form and the multilinear rank (r1, r2, r3) is still 
%   determined adaptively.
%
%   CHEBFUN3(F, 'rank', [r1 r2 r3]) returns a CHEBFUN3 with multilinear 
%   rank (r1, r2, r3) approximation to F.
% 
%   CHEBFUN3(F, 'coeffs') where F is a tensor, uses F as coefficients in 
%   a Chebyshev tensor expansion.
%
%   See also CHEBFUN3V and CHEBFUN3T.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CLASS PROPERTIES:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
properties
    % COLS: Mode-1 fibers, i.e., columns which are functions of x used in 
    % Tucker representation.
    cols
    
    % ROWS: Mode-2 fibers, i.e. rows which are functions of y used in 
    % Tucker representation.
    rows
    
    % TUBES: Mode-3 fibers, i.e. tubes which are functions of z used in 
    % Tucker representation.
    tubes
    
    % CORE: discrete core tensor in Tucker representation
    core
    
    % DOMAIN: box of CHEBFUN3, default is [-1, 1] x [-1, 1] x [-1, 1].
    domain
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CLASS CONSTRUCTOR:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
methods
    function f = chebfun3(varargin)
        % The main CHEBFUN3 constructor!
        
        % Return an empty CHEBFUN3:
        if ( (nargin == 0) || isempty(varargin{1}) )
            return
        end
        
        % Call the constructor, all the work is done here:
        f = constructor(f, varargin{:});
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CLASS METHODS:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
methods (Access = public, Static = true)
    % Outer product of tensors
    varargout = outerProd(varargin);
    
    % tensor x matrix
    varargout = txm(varargin);
    
    % Unfold a tensor to create a matrix.
    varargout = unfold(varargin);
    
    % Reshape a matrix to get a tensor.
    varargout = fold(varargin);
    
    % vals2coeffs
    coeffs3D = vals2coeffs(vals3D);
    
    % coeffs2vals
    vals3D = coeffs2vals(coeffs3D);
    
    % Tensor product of Chebyshev points:
    [xx, yy, zz] = chebpts3(m, n, p, domain, kind);
    
    varargout = myind2sub(varargin);
    
    varargout = discrete_hosvd(varargin);
    
    varargout = gallery3(varargin);
end

methods (Access = public)
    % Retrieve and modify preferences for this class.
    varargout = subsref(f, index);
    
    % Evaluate a CHEBFUN3.
    y = feval(f, varargin);
    
    % Permute a CHEBFUN3.
    g = permute(f, varargin);
    
    % Evaluate at vectors to get a tensor of values.
    y = fevalt(f, varargin);
    
    % Get properties of a CHEBFUN3 object.
    out = get(f, idx);
    
    % Rank of a CHEBFUN3 (i.e., size of the core in each direction)
    varargout = rank(f);
    
    % Size of a CHEBFUN3 
    varargout = size(f);
    
    % Length of a CHEBFUN3 (i.e., no of Chebyshev or Fourier points at each
    % direction)
    varargout = length(f);
    
    % Slice-Tucker decomposition of a CHEBFUN3
    varargout = st(f);
    
    varargout = chebpolyval3(varargin);
    
    % Sample a CHEBFUN3 on a tensor product grid
    varargout = sample(varargin);
    
    % Minimum of a CHEBFUN3
    varargout = min(varargin);
    
    % Maximum of a CHEBFUN3
    varargout = max(varargin);
    
    % Display a CHEBFUN3.
    varargout = disp(f, varargin);
    
    % Display a CHEBFUN3.
    varargout = display(varargin);
    
    % Simplify a CHEBFUN3.
    out = simplify(varargin);
    
    % Vertical scale of a CHEBFUN3.
    out = vscale(f);
    
    % Minimum of a CHEBFUN3 along two dimensions
    varargout = min2(varargin);
    
    % Maximum of a CHEBFUN3 along two dimensions
    varargout = max2(varargin);
    
    % Global minimum of a CHEBFUN3
    varargout = min3(f);
    
    % Global maximum of a CHEBFUN3
    varargout = max3(f);
    
    % Global minimum and maximum of a CHEBFUN3
    varargout = minandmax3(f);
    
    varargout = norm(f, p);
    
    out = vertcat(varargin);
    
    % Just one common root of 3 CHEBFUN3 objects.
    varargout = root(f, g, h); 
    
    % roots of a CHEBFUN3 object.
    varargout = roots(f, varargin);
    
    % Number of degrees of freedom needed to represent a CHEBFUN3
    out = ndf(f);
    
    % Definite integral of a CHEBFUN3 over its domain. out is a scalar.
    out = sum3(f);
    
    % Definite integral of a CHEBFUN3 over the domain in two directions. 
    % The output is a Chebfun object.
    out = sum2(varargin);
    
    % Definite integral of a CHEBFUN3 over the domain in one
    % direction. The output is a Chebfun2 object.
    out = sum(varargin);
    
    % Volume of the domain of a CHEBFUN3.
    out = domainvolume(f);
    
    % Line integral of a CHEBFUN3 over a 3D parametric curve.
    out = integral(f, varargin);
    
    % Surface integral of a CHEBFUN3 over a surface represented as a CHEBFUN2.
    out = integral2(f, varargin);
    
    out = std3(f);
    
    out = mean3(f);
    
    out = mean(f, varargin);
    
    out = mean2(f, varargin);
    
    % Create a scatter plot of the core tensor of a CHEBFUN3
    varargout = coreplot(f, varargin);
    
    out = plot(f, varargin);
    
    out = slice(f, varargin);
    
    out = scan(f, varargin);
    
    out = isosurface(f, varargin);
    
    % SURF for a CHEBFUN3 over its domain
    varargout = surf(f, varargin);
    
    % plotcoeffs of a CHEBFUN3.
    varargout = plotcoeffs(f, varargin);
    
    % Tensor of coefficients of a CHEBFUN3.
    varargout = chebcoeffs3(f);
    
    % A wrapper for chebcoeffs3.
    varargout = coeffs3(f);
end

methods
    out = domainCheck(f, g);
    
    out = uplus(f, g);
    
    out = plus(f, g);
    
    out = uminus(f);
    
    out = minus(f, g);
    
    %out = times(f, g);
    out = times(f, g, varargin);
    
    out = mtimes(f, g, varargin);
    
    out = power(varargin);
    
    out = rdivide(f, g);
    
    out = mrdivide(f, g);
    
    % Pointwise CHEBFUN3 left array divide.
    out = ldivide(f, g);
    
    out = mldivide(f, g);
    
    out = abs(f);
    
    out = real(f);
    
    out = imag(f);
    
    out = conj(f);
    
    % Create f + i g
    out = complex(f, g);
    
    out = sin(f);
    
    % Cosine of a CHEBFUN3.
    out = cos(f);
    
    out = tan(f);
      
    out = tand(f);
      
    out = tanh(f);
      
    out = exp(f);
      
    out = sinh(f);
      
    out = cosh(f);
            
    out = compose(f, varargin);
      
    out = sqrt(f, varargin);
      
    out = log(f, varargin);
      
    varargout = hosvd(f, varargin);
      
    out = isempty(f);
      
    % Determine whether a CHEBFUN3 is identically zero on its domain
    varargout = iszero(f);
        
    out = isreal(f);

    out = isequal(f, g);
      
    out = diff(f, varargin);
      
    out = diffx(f, varargin);
      
    out = diffy(f, varargin);
      
    out = diffz(f, varargin);
      
    varargout = grad(f);
      
    varargout = gradient(f);
      
    out = lap(f);
      
    out = laplacian(f);
      
    out = biharm(f);
      
    out = biharmonic(f);
      
    out = del2(f);
      
    out = cumsum(f, varargin);
      
    out = cumsum2(f, varargin);
      
    out = cumsum3(f);
end

end