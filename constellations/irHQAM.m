function res = irHQAM(M, dmin)
    % check M==8
    m = 1048576; % == 2^20
    res = zeros(1,M);
    exponent = log2(M);
    if ceil(exponent) ~= floor(exponent)
        error('M must be power of 2')
    end
    l = 1;   %counter
    y = rHQAM(m, dmin);
    y = y - dmin/4; % Shift to the right
    y = y + 1j*sqrt(3)*dmin/4;
    % Center point = 0 + 1j*0;
    Ec = sqrt(real(y).^2 + imag(y).^2); %Ec(index) = energy of point at y(index)
    while l <= M
        [~, index] = min(Ec);
        Ec(index) = inf;
        res(l) = y(index);
        l = l+1;
    end
end