% Sorts the Array A by ascending imaginary value
function y = sortByImagPart(A)
    [~, index] = sort(imag(A));
    y = A(index);