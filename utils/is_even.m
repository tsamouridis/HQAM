%Returns true if the number num is even. Otherwise, it returns false
function res = is_even(num)
    if mod(num,2) == 0
        res = true;
    else
        res = false;
    end
end
