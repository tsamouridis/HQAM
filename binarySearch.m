function result = binarySearch(a, left, right, toFind)
    result = -1;
    while left <= right
        mid = floor((left + right)/2);
        if a(mid) == toFind
            result = mid;
            break;
        elseif a(mid) < toFind
            left = mid + 1;
        else
            right = mid - 1;
        end
    end
end