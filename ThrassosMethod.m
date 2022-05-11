function ThrassosMethod()
    % parameters
    dmin = 1;
    signalSize = 500;
    method = 'rHQAM';
    M = 32;
    R = dmin/2;
    R_stressed = dmin/sqrt(3);
    k = 0.5;
    radius = k*R_stressed + (1-k)*R;
    snr = 25;
    
    sent = createRandomSignal(signalSize, method, M, dmin);    %creates a signal with 500 bits modulated as rHQAM
    constellation = myR_HQAM(M, dmin); % our constellation
    received = awgn(sent, snr);    %received = sent + n
    
    Sx = [];    %contains all X-axis values
    for point = 1:length(constellation)
        if ~ismember(real(point), constellation)
            Sx = [Sx point];
        end
    end
        
    x = sort(x);
    
    %find x1, x2
    for ii = 1:length(received)
        r = received(ii);
        x1 = real(r) + radius;
        x2 = real(r) - radius;
        
        y1 = imag(r) + radius;
        y2 = imag(r) + radius;

        
    x = binarySearch(Sx, x1, x2);   
    nearestSymbol = NaN;
    aList = [];
    % create 4 Q arrays for the external symbols, for the low snr cases
    x = binarySearch()
        


    end
end


