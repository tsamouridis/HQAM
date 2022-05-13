%This function creates a QAM constellation
% @param M: order of the constellation
% @param dmin:  minimum distance between two consecutive symbols
function result = QAM(M, dmin)
    exponent = log2(M);
    if hasDecimals(exponent)
        error('M must be power of 2')
    end

    if M == 2
        result = [dmin/2 -dmin/2];
        
    else
        points_per_quadrant = M/4;
        numOfCoordinates = sqrt(points_per_quadrant);
        result = zeros(1, M);
%         x_values = [];
%         y_values = [];
        if ~hasDecimals(numOfCoordinates)
            positive_x_values = zeros(1, numOfCoordinates);
            positive_x_values(1) = dmin/2;
%             negative_x_values = zeros(1, numOfCoordinates);
            
            positive_y_values = zeros(1, numOfCoordinates);
            positive_y_values(1) = 1i*dmin/2;
%             negative_y_values = zeros(1, numOfCoordinates);
            
            for ii = 2:numOfCoordinates
                positive_x_values(ii) = positive_x_values(ii-1)+dmin;
                positive_y_values(ii) = positive_y_values(ii-1)+1i*dmin;
            end
            negative_x_values = -flip(positive_x_values);
            negative_y_values = -flip(positive_y_values);
            
            x_values = [negative_x_values, positive_x_values];
            y_values = [negative_y_values, positive_y_values];
            
            kk = 1;
            while kk<=M
                for ii = 1:length(x_values)
                    for jj = 1: length(y_values)
                        result(kk) = x_values(ii)+y_values(jj) ;
                        kk = kk+1;
                    end
                end
            end
        else
            %numofcoordinates not integer ()
            temp = points_per_quadrant/2;
            k = sqrt(temp);
            positive_x_values = zeros(1,k);
            positive_x_values(1) = dmin/2;
            positive_y_values = zeros(1, k);
            positive_y_values(1) = 1i*dmin/2;
            for ii = 2:k
               positive_x_values(ii) = positive_x_values(ii-1) + dmin;
               positive_y_values(ii) = positive_y_values(ii-1) + 1i*dmin;
            end
            negative_x_values = -flip(positive_x_values);
            negative_y_values = -flip(positive_y_values);
            
            x_values = [negative_x_values, positive_x_values];
            y_values = [negative_y_values, positive_y_values];
            
            kk = 1;
            while kk <= k*k
                for ii = 1:length(x_values)
                    for jj = 1: length(y_values)
                        result(kk) = x_values(ii)+y_values(jj) ;
                        kk = kk+1;
                    end
                end
            end
            max_x = x_values(end);
            max_y = y_values(end);
            pointsAdded = kk;
            while pointsAdded < M
                newXcoordinate = max_x+dmin;
                newYcoordinate = max_y+1i*dmin;
                max_x = newXcoordinate;
                max_y = newYcoordinate;
                %x_values = [x_values, newXcoordinate];
                for ii = y_values
                    result(kk) = newXcoordinate+ii;
                    kk = kk+1;
                    result(kk) = -newXcoordinate+ii;
                    kk = kk+1;
                    pointsAdded = pointsAdded+2;
                    
                end
                if pointsAdded >= M
                    break
                end
                for ii = x_values
                    result(kk) = newYcoordinate+ii;
                    kk = kk+1;
                    result(kk) = -newYcoordinate+ii;
                    kk = kk+1;
                    pointsAdded = pointsAdded+2; 
                end            
            end
        end            
    end
    result = sortByImagPart(result);   
end

