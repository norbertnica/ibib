function fft_cell = power_in_band2(sleep_cell,tw,freq,band)
    fft_cell = cell(15,1);
    n = tw*freq;
    df = 1/tw;
    for i = 1:size(sleep_cell,1)
        x = sleep_cell{i,2};
        t = sleep_cell{i,1};
        rows = ceil(size(x,2)/n);
        M = zeros(rows,3);
        for j = 1:size(M,1)
            a = 1+(j-1)*n;
            b = j*n;
            y = [];
            if b < size(x,2)
                y = fft(x(a:b));
                M(j,3) = t(b);
            else
                y = fft(x(a:end));
                M(j,3) = t(end);
            end
            %length(y)
            y = 2.*y./n;
            y = (abs(y)).^2;
            y2 = y(1:round(length(y)/2));
            range = band(1):band(2);
            range = range.*df;
            range = ceil(range);
            M(j,1) = sum(y2(range));
            M(j,2) = t(a);
    
        end
        fft_cell{i,1} = M;
        
    end
end