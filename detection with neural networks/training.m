% Trains a Neural Network to detect Constellation via MLD method
function [net, targetOutput] = training(net, sampleSize, constellation, method)
    SNR = 5;
    dmin = 2;
    M = length(constellation);
    
    trainingSent = createRandomSignal(sampleSize, method, M, dmin);

    received = awgn(trainingSent , SNR);

    trainingInput(1, :) = real(received);
    trainingInput(2, :) = imag(received);

    mld = zeros(1, length(received));
    for i=1:length(received)
        mld(i) = MLD(constellation, received(i));
    end

    targetOutput = zeros(M, length(received));
    for i=1:length(mld)  
        index = find(constellation==mld(i));
        targetOutput(index, i) = targetOutput(index) + 1;
    end
    
    net = train(net, trainingInput, targetOutput);
end