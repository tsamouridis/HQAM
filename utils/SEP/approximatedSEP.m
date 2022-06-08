% Calculates an approximated Symbol Error Probability for the detection
% algorithm
function SEP = approximatedSEP(K, a, gs, Kc)
    SEP = K*qfunc(sqrt(a*gs)) + ...
             2/3*Kc*(qfunc(sqrt(2*a*gs/3)))^2 ...
                -2*Kc*qfunc(sqrt(a*gs))*qfunc(sqrt(a*gs/3));
end

