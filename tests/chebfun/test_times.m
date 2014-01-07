% Test file for @chebfun/times.m.

function pass = test_times(pref)

% Get preferences.
if ( nargin < 1 )
    pref = chebpref();
end

% Generate a few random points to use as test values.
seedRNG(6178);
x = 2 * rand(100, 1) - 1;

% Random numbers to use as arbitrary multiplicative constants.
alpha = -0.194758928283640 + 0.075474485412665i;

%% SCALAR-VALUED

% Check operation for empty inputs.
f = chebfun(@sin, [-1 1], pref);
pass(1) = isempty(f.*[]);
pass(2) = isempty(f.*chebfun());

% Turn on splitting, since we'll need it for the rest of the tests.
pref.enableBreakpointDetection = 1;

% Test multiplication by scalars.
f1_op = @(x) sin(x).*abs(x - 0.1);
f1 = chebfun(f1_op, pref);
pass(3:4) = test_mult_function_by_scalar(f1, f1_op, alpha, x);

% Test multiplication of two chebfun objects.
g1_op = @(x) cos(x).*sign(x + 0.2);
g1 = chebfun(g1_op, pref);
pass(5:6) = test_mult_function_by_function(f1, f1_op, g1, g1_op, x);

%% ARRAY-VALUED

% Test operation for array-valued chebfuns.
f2_op = @(x) [sin(x).*abs(x - 0.1)  exp(x)];
f2 = chebfun(f2_op, pref);
pass(7:8) = test_mult_function_by_scalar(f2, f2_op, alpha, x);

g2_op = @(x) [cos(x).*sign(x + 0.2) tan(x)];
g2 = chebfun(g2_op, pref);
pass(9:10) = test_mult_function_by_function(f2, f2_op, g2, g2_op, x);

% Test operation for transposed chebfuns.
pass(11:12) = test_mult_function_by_scalar(f1.', @(x) f1_op(x).', alpha, x);
pass(13:14) = test_mult_function_by_function(f1.', @(x) f1_op(x).', ...
    g1.', @(x) g1_op(x).', x);

%% QUASIMATRICES
f2q = quasimatrix(f2_op, pref);
pass(15:16) = test_mult_function_by_scalar(f2q, f2_op, alpha, x);

% Quasi * array-cheb
pass(17:18) = test_mult_function_by_function(f2q, f2_op, g2, g2_op, x);

% Quasi * quasi
g2q = quasimatrix(g2_op, pref);
pass(19:20) = test_mult_function_by_function(f2q, f2_op, g2q, g2_op, x);

%% Check error conditions.

try
    h = f1.*'X';
    pass(21) = false;
catch ME
    pass(21) = strcmp(ME.identifier, 'CHEBFUN:times:unknown');
end

try
    h = f1.*f1.';
    pass(22) = false;
catch ME
    pass(22) = strcmp(ME.identifier, 'CHEBFUN:times:matdim');
end

try
    h = f1.*g2q.';
    pass(23) = false;
catch ME
    pass(23) = strcmp(ME.identifier, 'CHEBFUN:times:matdim');
end

end

%% The tests

% Test the multiplication of a chebfun F, specified by F_OP, by a scalar ALPHA
% using a grid of points X in [-1  1] for testing samples.
function result = test_mult_function_by_scalar(f, f_op, alpha, x)
    g1 = f .* alpha;
    g2 = alpha .* f;
    result(1) = isequal(g1, g2);
    g_exact = @(x) f_op(x) .* alpha;
    err = feval(g1, x) - g_exact(x);
    result(2) = norm(err(:), inf) < 10*max(vscale(g1).*epslevel(g1));
end

% Test the multiplication of two chebfuns F and G, specified by F_OP and G_OP,
% using a grid of points X in [-1  1] for testing samples.
function result = test_mult_function_by_function(f, f_op, g, g_op, x)
    h1 = f .* g;
    h2 = g .* f;
    result(1) = isequal(h1, h2);
    h_exact = @(x) f_op(x) .* g_op(x);
    err = feval(h1, x) - h_exact(x);
    result(2) = norm(err(:), inf) < 10*max(vscale(h1).*epslevel(h1));
end

