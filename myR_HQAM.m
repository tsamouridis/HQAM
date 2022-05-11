% This function creates a Regular Hexagonal QAM constellation
%   @param M: order of the constellation
%   @param dmin:  minimum distance between two consecutive symbols
% PROBLEM: should we check which row i shift -> and whch <- ??

function res = myR_HQAM(M, dmin)
    toCheck = log2(M);
    if ceil(toCheck) ~= floor(toCheck)
        error('M must be power of 2')
    end
    y = myQAM(M, dmin);
    newY = zeros(1, M);
    counter = 2;
    temp = imag(y(1));
    for ii = 1:length(y)
        if imag(y(ii)) ~= temp       % when coordinate in Q Axis changes
            counter = counter+1;
            temp = imag(y(ii));
        end
        
        if mod(counter,2) == 0
            newcoord = y(ii) - dmin/4;
        else
            newcoord = y(ii) + dmin/4;
        end
        newY(ii) = newcoord;
    end
    res = newY;
end