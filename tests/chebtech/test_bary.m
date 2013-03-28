% Test file for chebtech/bary.

function pass = test_bary(pref)

% [TODO]: This test is rubbish!

if ( nargin < 1 )
    pref = chebtech.pref;
end

tol = 20*pref.chebtech.eps;

for ( n = 1:2 )
    if ( n == 1 )
        testclass = chebtech1();
    else
        testclass = chebtech2();
    end

    k = 14;
    m = 10;

    x = testclass.chebpts(k);
    f = @(x) sin(x);
    y = linspace(-1, 1, m).';
    fx = f(x);
    fy = f(y);

    % second kind formula
    pass(n, 1) = norm( testclass.bary(y, fx) - fy ) < tol;
    pass(n, 2) = norm( testclass.bary(y, [fx fx]) - [fy fy] ) < tol;
end

end
