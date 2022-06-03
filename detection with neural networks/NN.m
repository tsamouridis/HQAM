close all;clear all;

%% Constellation Generation
method = "rHQAM";
dmin = 2;
M = 2*16;

if method == "rHQAM"
    constellation = rHQAM(M, dmin);
elseif method == "irHQAM"
    constellation = irHQAM(M, dmin);
end

%% NN declaration
net = patternnet;

%% Training
sampleSize = 10000;
[net, t] = training(net, sampleSize, constellation, method);

%% Sent, Received Signals
SNR = 10;
signalSize = 1000;

sent = createRandomSignal(signalSize, method, M, dmin);
received = awgn(sent, SNR);

%% Detection with Neural Network
input(1, :) = real(received);
input(2, :) = imag(received);

netOutput = net(input);
[~, estimatedSentSignalIndices] = max(netOutput, [], 1);

estimatedSignal = zeros(1, length(received));
for i=1:length(received)
    estimatedSignal(i) = constellation(estimatedSentSignalIndices(i));
end
