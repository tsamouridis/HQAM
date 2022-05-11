% This function chechs if the number a has decimals or not.
% Returns true if there exist decimals, otherweise it returns false
function b = hasDecimals(a)
    if ceil(a) == floor(a)
        b = false;
    else
        b = true;
    end
end