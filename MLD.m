% Returns the constellation symbol that is nearest to the received signal
% given a set of candidate symbols
function nearestSymbol = MLD(symbols, r)
    minimumDistance = realmax;
    
    for i=1:length(symbols)
        if norm(symbols(i) - r) < minimumDistance
           minimumDistance = norm(symbols(i) - r);
           nearestSymbol = symbols(i); 
        end
    end
end

