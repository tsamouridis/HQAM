% Calculates an approximated Symbol Error Probability for the detection
% algorithm
function SEP = approximatedSEP(K, a, gs, Kc)
    SEP = K*gaussmf(sqrt(a*gs), [1 0]) + ...
             2/3*Kc*(gaussmf(sqrt(2*a*gs/3), [1 0]))^2 ...
                -2*Kc*gaussmf(sqrt(a*gs), [1 0])*gaussmf(sqrt(a*gs/3), [1 0]);
end

