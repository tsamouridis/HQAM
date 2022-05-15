% Returns the values of the matrix M that are with the lower bound
% (lower_bound matrix) and the upper bound (upper_bound)
function within_bounds = binarySearch(M, lower_bound, upper_bound)    
    within_bounds = M(M>=lower_bound & M<=upper_bound);  
end