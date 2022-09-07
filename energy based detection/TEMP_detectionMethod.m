dmin = 1;
order = 64;
a = rHQAM(order,dmin);
% qi contains symbols in i-th quadradant
q1 = a(imag(a)>=0 & real(a)>=0);
q2 = a(imag(a)>=0 & real(a)<0);
q3 = a(imag(a)<0 & real(a)<0);
q4 = a(imag(a)<0 & real(a)>=0);

% E_qi holds the energy of the siymbols in i-th quadradant 
E_q1 = vecnorm(q1, 2, 1);
E_q2 = vecnorm(q2, 2, 1);
E_q3 = vecnorm(q3, 2, 1);
E_q4 = vecnorm(q4, 2, 1);

tests = 10000;
errors = 0;
for jj = 1:tests
    sent = randsample(a, 1);    % random symbol
    r = awgn(sent, 20);

%     hold on;
%     scatter(real(a), imag(a));
%     scatter(real(r), imag(r), 'd');

    % find quadrant of received symbol and specify working quadrant
    x = real(r);
    y = imag(r);

    if x>=0 && y >=0
        quadOfReceivedSymbol = 1;
        q = q1;
        E_q = E_q1;
    elseif x<0 && y >=0
        quadOfReceivedSymbol = 2;
        q = q2;
        E_q = E_q2;
    elseif x<0 && y <0
        quadOfReceivedSymbol = 3;
        q = q3;
        E_q = E_q3;
    else
        quadOfReceivedSymbol = 4;
        q = q4;
        E_q = E_q4;
    end

    % if the symbol of constellation has a distance greater than dmin(?or sth else?)
    % from the received symbol, except it from the comparison
    for ii = 1:length(q)
        if norm(q(ii) - r) > dmin
            q(ii) = 0+0i;
            E_q(ii) = inf;
        end
    end

    E_r = vecnorm(r);

    B = abs(E_q - E_r);

    [minValue, idx] = min(B);  % find the minimum 
    allMinimumIndices = find(minValue == B);
    if length(allMinimumIndices) == 1
        ds = q(idx);    % detected symbol
    else    %if the method gives more than 1 possible answers(i think at maximum gives only 2) do mld
        ds = MLD(q(allMinimumIndices), r);
    end
%     scatter(real(ds), imag(ds), 'filled')
    
    mldDetected = MLD(a, r);
    if MLD(a, r) ~= ds
        errors = errors + 1;
    end
end

toPrint = 'error Detections: %d / %d';
fprintf(toPrint,errors,tests)
fprintf('\n')


% possible problem: mld symbol may have larger energy than the 

