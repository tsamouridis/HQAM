% Calculates Symbol Error Probability 
% Note: For the gaussian function used in the formula for the SEP
% calculation, σ = 1 and μ = 0
% SNR = Eb / N0
function SEP = calculateSEP(M, numOfExtSymbols, radius, N0)    
    SEP = (2*M - numOfExtSymbols)/(2*M) * exp(-radius^2/N0) + numOfExtSymbols/M * gaussmf(radius*sqrt(2)/sqrt(N0), [1 0]);
end

