function f = thresholdBreakpointValues(f)
%THRESHOLDBREAKPOINTVALUES   Set small breakpoint values to zero.
%   G = THRESHOLDBREAKPOINTVALUES(F), where F is a CHEBFUN, returns a CHEBFUN
%   G such that all breakpoint values smaller than VSCALE(F)*EPSLEVEL(F) are
%   set to zero.

% Copyright 2013 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org for Chebfun information.

for k = 1:numel(f)
    breakVals = f(k).impulses(:,:,1);
    breakVals(abs(breakVals) < vscale(f(k))*epslevel(f(k))) = 0;
    f(k).impulses(:,:,1) = breakVals;
end

end
