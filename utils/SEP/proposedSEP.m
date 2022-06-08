% Calculates a proposed Symbol Error Probability
function SEP = proposedSEP(M, numOfExtSymbols, radius, N0)    
    SEP = (2*M - numOfExtSymbols)/(2*M) * exp(-radius^2/N0) + ...
        numOfExtSymbols/M * qfunc(radius*sqrt(2)/sqrt(N0));
end
