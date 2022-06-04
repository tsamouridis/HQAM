close all;clear all;

%% Constellation Parameters
dmin = 2.5;
method = "rHQAM";
M = 8;

if method == "rHQAM"
    constellation = rHQAM(M, dmin);
elseif method == "irHQAM"
    constellation = irHQAM(M, dmin);
end

%% Circle for detection
R = dmin/2;
R_stressed = dmin/sqrt(3); 
k =  loadK(M, method);
radius = k*R_stressed + (1-k)*R;

%% Noise
N0 = 0.1:0.001:1;
sigma = sqrt(N0/2);
Es = 1/M*sum((vecnorm(constellation, 2, 1)) .^ 2);

%% Sent signal
signalSize = 10000;
sent = createRandomSignal(signalSize, method, M, dmin); 

%% Matrices initialization
approxSEP = zeros(1, length(N0));
expSEP = zeros(1, length(N0));
simulatedSEP = zeros(1, length(N0));
gs = 10*log10(Es./N0);

%% Nearest Neighbors Parameters
[K, Kc] = findNearNeighborParameters(constellation, dmin);
numOfExtSymbols = calculateNumOfExtSymbols(constellation, dmin);

%% SEP calculations
for ii = 1:length(N0)    
    received = sent + normrnd(0, sigma(ii),1,signalSize) + 1i*normrnd(0, sigma(ii),1,signalSize);
    
    expSEP(ii) = proposedSEP(M, numOfExtSymbols, radius, N0(ii)); 
    
    a = (dmin/(2*sigma(ii)))^2/gs(ii);
    approxSEP(ii) = approximatedSEP(K, a, gs(ii), Kc);
       
    nearestSymbol = detection(constellation, received, dmin, radius);

    simulatedSEP(ii) = sum([nearestSymbol ~= sent]) / signalSize;
end

%%Result plotting
figure
semilogy(gs, simulatedSEP)
hold on
semilogy(gs, approxSEP)
hold on
semilogy(gs, expSEP)
grid on
legend('simulatedSEP', 'approxSEP', 'expSEP')
