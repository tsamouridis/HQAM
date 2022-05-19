clear all;
close all;

% parameters
dmin = 1;
signalSize = 15;
method = "rHQAM";
M = 2^11;

R = dmin/2;
R_stressed = dmin/sqrt(3);
k = 0.7;
radius = k*R_stressed + (1-k)*R;

snr = 10;
sent = createRandomSignal(signalSize, method, M, dmin);     % creates a signal with 500 bits modulated as rHQAM
constellation = rHQAM(M, dmin);                             % our constellation
received = awgn(sent, snr);

% our constellation:
if method == "rHQAM"
    constellation = rHQAM(M, dmin);
elseif method == "irHQAM"
    constellation = irHQAM(M, dmin);
end

nearestSymbol = zeros(size(received));

Q = [];
if length(constellation) > 8
    for i=1:length(constellation)
        numberOfNeighbours = findNeighbours(setdiff(constellation, constellation(i)), constellation(i), dmin);
        
        if numberOfNeighbours <= 5
           Q = [Q constellation(i)]; 
        end
    end
end

Q1 = Q((real(Q) > 0) & (imag(Q) > 0));
Q2 = Q((real(Q) < 0) & (imag(Q) > 0));
Q3 = Q((real(Q) < 0) & (imag(Q) < 0));
Q4 = Q((real(Q) > 0) & (imag(Q) < 0));
    
Sx = sort(unique(real(constellation)));
    
for i = 1:length(received)
    x1 = real(received(i)) + radius;
    x2 = real(received(i)) - radius;

    y1 = imag(received(i)) + radius;
    y2 = imag(received(i)) - radius;
   
    list = [];
     
    x = binarySearch(Sx, x2, x1);
    
    xCandidateConstellationPoints = constellation(ismember(real(constellation), x));
    
    for j = 1:length(x)
        Ai = [constellation(x(j) == real(constellation)); -imag(constellation(x(j) == real(constellation)))]';
        si_c = binarySearch(Ai(:, 2), y2, y1);

        candidateConstellationPoints = xCandidateConstellationPoints(ismember(imag(xCandidateConstellationPoints), si_c));
        
        list = [list, candidateConstellationPoints];
    end

    if isempty(list)
        if sign([real(received(i)), imag(received(i))]) == [1 1]
            nearestSymbol(i) = MLD(Q1, received(i));
        end

        if sign([real(received(i)), imag(received(i))]) == [-1 1]
            nearestSymbol(i) = MLD(Q2, received(i));
        end

        if sign([real(received(i)), imag(received(i))]) == [-1 -1]
            nearestSymbol(i) = MLD(Q3, received(i));
        end

        if sign([real(received(i)), imag(received(i))]) == [1 -1]
            nearestSymbol(i) = MLD(Q4, received(i));
        end     
    end
    
    if ~isempty(list)
        nearestSymbol(i) = MLD(list, received(i));        
    end

end

scatter(real(sent), imag(sent), 40,...
              'MarkerEdgeColor', 'red',...
              'MarkerFaceColor', 'red',...
              'LineWidth', 1.5) 
hold on; 

scatter(real(received), imag(received), 40,...
              'MarkerEdgeColor', 'blue',...
              'MarkerFaceColor', 'blue',...
              'LineWidth', 1.5)     
legend('Transmitted', 'Received');
grid on;          
hold off;

figure;
scatter(real(constellation), imag(constellation), 40,...
              'MarkerEdgeColor', 'black',...
              'MarkerFaceColor', 'black',...
              'LineWidth', 1.5)          
title('Constellation')
grid on;  

figure;
scatter(real(nearestSymbol), imag(nearestSymbol), 40,...
              'MarkerEdgeColor', [0.6350 0.0780 0.1840],...
              'MarkerFaceColor', [0.6350 0.0780 0.1840],...
              'LineWidth', 1.5)          
title('Nearest Symbols')
grid on; 
