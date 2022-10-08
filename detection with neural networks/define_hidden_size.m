% Finds an optimal number of hidden neurons in the Neural Network.
% A plot of performance in respect to the hidden size is generated. The size
% with the best performance is returned. Miminum size is 2 and maximum
% output is M+10. 
function best_hidden_size = define_hidden_size(method, M, dmin)
    if method == "rHQAM"
        constellation = rHQAM(M, dmin);
    elseif method == "irHQAM"
        constellation = irHQAM(M, dmin);
    end
    
    min_hidden_size = 2;
    max_hidden_size = M+10;
    SNR = 10;
    
    % x, y are used to plot the perf in respect to the hidden_size
    x = [];
    y = [];
    
    best_hidden_size = min_hidden_size;
    best_perf = inf;
    for ii = [min_hidden_size:1:max_hidden_size]
        net = patternnet(ii);

        sampleSize = 1000;
        [~, perf] = training(net, sampleSize, constellation, SNR-5, method);
        x = [x ii];
        y = [y perf];
        if perf < best_perf
           best_perf = perf;
           best_hidden_size = ii;
        end        
    end 
    plot(x,y)
    grid('on')
    title('Performance = f(hidden size) - [smaller perf is desired]')
    xlabel('hidden size')
    ylabel('perf')
end