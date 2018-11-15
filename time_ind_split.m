function M = time_ind_split(x,time_ind,freq)
    
    ind = time_ind.*freq;
    %maxdim = max(diff(ind,1,2));
    M = cell(size(ind,1),2);
    for i = 1:size(ind,1)
        window = int32(ind(i,1)):int32(ind(i,2));
        %window
        %window
        M{i,1} = double(window).*1/freq;
        M{i,2} = x(window);
        %x(window)
    end
    
end