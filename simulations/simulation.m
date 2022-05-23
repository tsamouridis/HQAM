close all;clear all;
dmin = 2.5;
signalSize = 1000;
method = "rHQAM";
M = 32;

R = dmin/2;
R_stressed = dmin/sqrt(3);
k = 0.3936315;    %calculate it for each value of M
radius = k*R_stressed + (1-k)*R;


% our constellation:
if method == "rHQAM"
    constellation = rHQAM(M, dmin);
elseif method == "irHQAM"
    constellation = irHQAM(M, dmin);
end

N0 = 0.1:0.001:1;
sigma = sqrt(N0/2);
Es = 1/M*sum((vecnorm(constellation, 2, 1)) .^ 2);
sent = createRandomSignal(signalSize, method, M, dmin);     % creates a signal with 500 bits modulated as rHQAM

numOfExtSymbols = 0;
for ii = 1:M
    numberOfNeighbours = findNeighbours(setdiff(constellation, constellation(ii)), constellation(ii), dmin);
    if numberOfNeighbours <= 5
        numOfExtSymbols = numOfExtSymbols+1;
    end
end

K = 0;
Kc = 0;
for i = 1:M
    numOfNearestNeighbours = findNeighbours(setdiff(constellation, constellation(i)), constellation(i), dmin);
    K = K + numOfNearestNeighbours;
    if numOfNearestNeighbours == 6
        Kc = Kc + numOfNearestNeighbours;
    else
        Kc = Kc + numOfNearestNeighbours - 1;
    end
end
K = K/M;
Kc = Kc/M;

approxSEP = zeros(1, length(N0));
expSEP = zeros(1, length(N0));
simulatedSEP = zeros(1, length(N0));
gs = 10*log10(Es./N0);
for ii = 1:length(N0)
    
    received = sent + normrnd(0, sigma(ii),1,signalSize) + 1i*normrnd(0, sigma(ii),1,signalSize);
    
    expSEP(ii) = proposedSEP(M, numOfExtSymbols, radius, N0(ii)); 
    
    a = (dmin/(2*sigma(ii)))^2/gs(ii);
    approxSEP(ii) = approximatedSEP(K, a, gs(ii), Kc);
    
    
    nearestSymbol = detection(constellation, received, dmin, k);

    simulatedSEP(ii) = sum([nearestSymbol ~= sent]) / signalSize;

%     plotSignals(constellation, sent, received, nearestSymbol);
end

% plotSignals(constellation, sent, received, nearestSymbol);
figure
semilogy(gs, simulatedSEP)
hold on
semilogy(gs, approxSEP)
hold on
semilogy(gs, expSEP)
grid on
legend('simulatedSEP', 'approxSEP', 'expSEP')
