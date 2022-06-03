function numOfExtSymbols = calculateNumOfExtSymbols(constellation, dmin)
    numOfExtSymbols = 0;
    M = length(constellation);
    
    for ii = 1:M
        numberOfNeighbours = findNeighbours(setdiff(constellation, constellation(ii)), constellation(ii), dmin);
        if numberOfNeighbours <= 5
            numOfExtSymbols = numOfExtSymbols+1;
        end
    end
end

