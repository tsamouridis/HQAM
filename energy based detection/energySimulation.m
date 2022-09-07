close all;clear all;

%% Constellation Parameters
dmin = 2;
method = "rHQAM";
M = 8;

if method == "rHQAM"
    constellation = rHQAM(M, dmin);
elseif method == "irHQAM"
    constellation = irHQAM(M, dmin);
end

%% Noise
N0 = 0.1:0.1:1;
sigma = sqrt(N0/2);
Es = 1/M*sum((vecnorm(constellation, 2, 1)) .^ 2);

%% Q and E calculations for energy detection
% qi contains symbols in i-th quadradant
q1 = constellation(imag(constellation)>=0 & real(constellation)>=0);
q2 = constellation(imag(constellation)>=0 & real(constellation)<0);
q3 = constellation(imag(constellation)<0 & real(constellation)<0);
q4 = constellation(imag(constellation)<0 & real(constellation)>=0);
qstressed = constellation(abs(real(constellation)) <= dmin/2);  % used when received is close to imaginary axis

Q = [q1; q2; q3; q4; qstressed];

% E_qi holds the energy of the siymbols in i-th quadradant 
E_q1 = vecnorm(q1, 2, 1);
E_q2 = vecnorm(q2, 2, 1);
E_q3 = vecnorm(q3, 2, 1);
E_q4 = vecnorm(q4, 2, 1);
E_qstressed = vecnorm(qstressed, 2, 1);

E = [E_q1; E_q2; E_q3; E_q4; E_qstressed];
energyParam = 0.1;
%% Sent signal
signalSize = 100;
sent = createRandomSignal(signalSize, method, M, dmin); 

%% Circle for detection
R = dmin/2;
R_stressed = dmin/sqrt(3); 
k = loadK(M, method);
radius = k*R_stressed + (1-k)*R;
gs = 10*log10(Es./N0);
numOfExtSymbols = calculateNumOfExtSymbols(constellation, dmin);

%% Expected SEP from the paper method and Energy Detection
for ii = 1:length(N0)    
    received = sent + normrnd(0, sigma(ii),1,signalSize) + 1i*normrnd(0, sigma(ii),1,signalSize);
    expSEP(ii) = proposedSEP(M, numOfExtSymbols, radius, N0(ii));
    nearestSymbol = energyDetection(constellation, received, dmin, Q, E, energyParam);
    energySEP(ii) = sum([nearestSymbol ~= sent]) / signalSize;
end
figure
semilogy(gs, energySEP)
hold on
semilogy(gs, expSEP, '--')
grid on
legend('energySEP', 'expSEP')

