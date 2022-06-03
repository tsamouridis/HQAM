% Creates a Regular Hexagonal QAM constellation
%   @param M: order of the constellation
%   @param dmin:  minimum distance between two consecutive symbols
function res = rHQAM(M, dmin)
    exponent = log2(M);
    if hasDecimals(exponent)
        error('M must be power of 2')
    end
    tempQAM = QAM(M, dmin);
    res = zeros(1, M);
    counter = 2;
    currentQAxisCoordinate = imag(tempQAM(1));
    for ii = 1:length(tempQAM)
        if imag(tempQAM(ii)) ~= currentQAxisCoordinate       % when coordinate in Q Axis changes
            counter = counter+1;
            currentQAxisCoordinate = imag(tempQAM(ii));
        end
        
        if mod(counter,2) == 0
            newcoord = tempQAM(ii) - dmin/4;
        else
            newcoord = tempQAM(ii) + dmin/4;
        end
        res(ii) = newcoord;
    end        
end