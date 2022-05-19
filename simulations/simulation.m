dmin = 1;
signalSize = 15;
method = "irHQAM";
M = 2^11;

R = dmin/2;
R_stressed = dmin/sqrt(3);
k = 0.7;
radius = k*R_stressed + (1-k)*R;

snr = 10;
sent = createRandomSignal(signalSize, method, M, dmin);     % creates a signal with 500 bits modulated as rHQAM
received = awgn(sent, snr);

% our constellation:
if method == "rHQAM"
    constellation = rHQAM(M, dmin);
elseif method == "irHQAM"
    constellation = irHQAM(M, dmin);
end


nearestSymbol = detection(constellation, sent, received, dmin, M, k);


% SEP = calculateSEP(M, numOfExtSymbols, radius, N0);


plotSignals(constellation, sent, received, nearestSymbol);
