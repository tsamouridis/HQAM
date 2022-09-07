% Simulates a detection Algorithm for HQAM constellations based on the
% energy of each symbol
%   @param constellation: the constellation beeing used.
%   @param received: received signal with length(received) symbols
%   @param dmin: minimum distance.
%   @param Q: Array with 5 rows. Each row contains the symbols of each
%             quadrant. The fifth row contains symbols close to the axes.
%   @param E: Array that contains the Energy of all the symbols of Q array.
%   @param energyParam: a parameter used in the detection.
%Returns the detected signal.
function detectedSignal = energyDetection(constellation, received, dmin, Q, E, energyParam)
    detectedSignal = zeros(1, length(received));
    for jj = 1:length(received)
        r = received(jj);

        % find quadrant of received symbol and specify working quadrant
        x = real(r);
        y = imag(r);

        if (-dmin/4<x) && (x<dmin/4)    % if r close to x = 0
            q = Q(5, :);
            E_q = E(5, :);
        elseif x>=0 && y>=0
            q = Q(1, :);
            E_q = E(1, :);
        elseif x<0 && y>=0
            q = Q(2, :);
            E_q = E(2, :);
        elseif x<0 && y<0
            q = Q(3, :);
            E_q = E(3, :);
        else
            q = Q(4, :);
            E_q = E(4, :);
        end

        % if the symbol of constellation has x or y distance greater than
        % max_x and max_y accordingly and it is not external(?)
        % from the received symbol, it is excepted from the comparison
        max_x = dmin/2;
        max_y = sqrt(3)*dmin/3;
        for ii = 1:length(q)
            if (abs(real(q(ii)) - x) > max_x || abs(imag(q(ii)) - y) > max_y)
                E_q(ii) = inf;
            end
        end

        E_r = vecnorm(r);
        B = abs(E_q - E_r);
        %%%%%
        % delete it after debugging
        % checks the case in which B contains only infinite values
%         allInf = true;
%         for kk = 1:length(B)
%             if B(kk) ~= inf
%                 allInf = false;
%                 break
%             end
%         end
%         if allInf
%             what = 0;
%         end
        %%%%%%%
        [minValue, minIdx] = min(B);  % find the minimum 
        allMinimumIndices = find(B <= (minValue + energyParam));    % find all the minimums indices
        if length(allMinimumIndices) == 1
            ds = q(minIdx);    % detected symbol
        else    %if the method gives more than 1 possible answers(i think at maximum gives only 2) do mld
            ds = MLD(q(allMinimumIndices), r);
            %or....
        end
        detectedSignal(jj) = ds;
        mld = MLD(constellation, r);
        
        count =0;
        hold on;
        if mld ~= ds
            scatter(real(constellation), imag(constellation));
            scatter(real(mld), imag(mld), 'd');
            scatter(real(ds), imag(ds), 'filled');
            scatter(real(r), imag(r), 'd', 'filled');
            count = count +1;
        end
        close all
% possible problem: mld symbol may have larger energy than the 
    end
end
