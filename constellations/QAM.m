%Creates a special QAM constellation.
%The vertical and horizontal distance between two successive symbols are
%sqrt(3)*dmin/2 and dmin respectively.
%   @param M: order of the constellation
%   @param dmin:  minimum distance between two consecutive symbols
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
        if is_even(exponent)    %constellation has orthogonal shape
            positive_x_values = zeros(1, numOfCoordinates);
            positive_x_values(1) = dmin/2;
            
            positive_y_values = zeros(1, numOfCoordinates);
            positive_y_values(1) = 1i*sqrt(3)*dmin/4;
            
            for ii = 2:numOfCoordinates
                positive_x_values(ii) = positive_x_values(ii-1)+dmin;
                positive_y_values(ii) = positive_y_values(ii-1)+1i*sqrt(3)*dmin/2;
            end
            negative_x_values = -flip(positive_x_values);
            negative_y_values = -flip(positive_y_values);
            
            x_values = [negative_x_values, positive_x_values];
            y_values = [negative_y_values, positive_y_values];
            
            % this loop generates the complex numbers x+jy
            kk = 1;
            while kk<=M
                for ii = 1:length(x_values)
                    for jj = 1: length(y_values)
                        result(kk) = x_values(ii)+y_values(jj) ;
                        kk = kk+1;
                    end
                end
            end
            
        else    %constellation has cross-like shape
            %symbols in each Quadrant are divided in the ones forming a
            %square and the ones completing the square on top and on the
            %side
            numOfSymbolsInSquareShape = points_per_quadrant/2;
            LengthOSideOfSquare = sqrt(numOfSymbolsInSquareShape);
            positive_x_values = zeros(1,LengthOSideOfSquare);
            positive_x_values(1) = dmin/2;
            positive_y_values = zeros(1, LengthOSideOfSquare);
            positive_y_values(1) = 1i*sqrt(3)*dmin/4;
            for ii = 2:LengthOSideOfSquare
               positive_x_values(ii) = positive_x_values(ii-1) + dmin;
               positive_y_values(ii) = positive_y_values(ii-1) + 1i*sqrt(3)*dmin/2;
            end
            negative_x_values = -flip(positive_x_values);
            negative_y_values = -flip(positive_y_values);
            
            x_values = [negative_x_values, positive_x_values];
            y_values = [negative_y_values, positive_y_values];
            
            % this loop forms the complex number of the symbols in square
            % shape
            kk = 1;
            while kk <= numOfSymbolsInSquareShape
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
            
            %Adds the rest symbols to the Quadrant
            while pointsAdded < M
                newXcoordinate = max_x+dmin;
                newYcoordinate = max_y+1i*sqrt(3)*dmin/2;
                max_x = newXcoordinate;
                max_y = newYcoordinate;

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
