% Calculates K and Kc parameters, which are used in HQAM's proposed
% SEP
function [K, Kc] = findNearNeighborParameters(constellation, dmin)
    K = 0;
    Kc = 0;
    
    M = length(constellation);
    for i = 1:M
        numOfNearestNeighbours = findNeighbours(setdiff(constellation, constellation(i)), constellation(i), dmin);
        K = K + numOfNearestNeighbours;
        if numOfNearestNeighbours == 6
            Kc = Kc + numOfNearestNeighbours;
        else
            Kc = Kc + numOfNearestNeighbours - 1;
        end
    end
    K = K/M;
    Kc = Kc/M;
end

