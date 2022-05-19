function neighbours = findNeighbours(symbols, r, dmin)  
    neighbours = 0;
    for i=1:length(symbols)
        if abs(norm(symbols(i) - r) - dmin) < 10^-10
           neighbours = neighbours + 1; 
        end
    end
end

