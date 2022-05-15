function neighbours = findNeighbours(symbols, r, dmin)  
    neighbours = 0;
    for i=1:length(symbols)
        if norm(symbols(i) - r) == dmin
           ++neighbours; 
        end
    end
end

