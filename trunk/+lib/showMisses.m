function [o] = showMisses( tagName, in )
    s = stats(in);
    fprintf('[%s] Misses: %i\n', tagName, s.Cache.TotalMisses)
    o = s.Cache.TotalMisses;
    s.Cache.TotalMisses = 0;
end

