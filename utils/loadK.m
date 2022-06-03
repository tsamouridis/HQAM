function k = loadK(M, method)
    if method == "rHQAM"
        switch M
            case 16
                k = 0.8711505;
            case 32
                k = 0.7233274;
            case 64
                k = 0.5222431;
            case 128
                k = 0.5088351;
            case 256
                k = 0.3936315;
            case 512
                k = 0.3672311;
            case 1024
                k = 0.2982858;
            otherwise
                k = 0.5;
        end
    else
        k = 0.5;
    end
end

