%Simulates a Detection algorithm using Neural Network
close all;clear all;
find_best_hidden_size = false

%% Constellation Generation
method = "rHQAM";
dmin = 1;
M = 8;

if method == "rHQAM"
    constellation = rHQAM(M, dmin);
elseif method == "irHQAM"
    constellation = irHQAM(M, dmin);
end

%% NN declaration
if find_best_hidden_size == true
    hidden_size = define_hidden_size(method, M, dmin);
else
    hidden_size = 10;
end
net = patternnet(hidden_size);

%% Sent, Received Signals
SNR = 10;
signalSize = 1000;

sent = createRandomSignal(signalSize, method, M, dmin);
received = awgn(sent, SNR); %use normrnd for better simulation

%% Training
sampleSize = 1000;
net = training(net, sampleSize, constellation, SNR-5, method);
% net.layers{1}.transferFcn % hidden layer [== 'tansig']
% net.layers{2}.transferFcn % output layer [== 'softmax']

%% Detection with Neural Network
input(1, :) = real(received);
input(2, :) = imag(received);

netOutput = net(input);
[~, estimatedSentSignalIndices] = max(netOutput, [], 1);

estimatedSignal = zeros(1, length(received));
for i=1:length(received)
    estimatedSignal(i) = constellation(estimatedSentSignalIndices(i));
end
