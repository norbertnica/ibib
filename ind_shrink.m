function x = ind_shrink(m,thresh)
    ind = zeros(size(m,1));
    j = 1;
    for i = 1:(size(m,1)-1)
        if (m(i+1,1)-m(i,2)) < thresh
            m(i,2) = m(i+1,2);
            ind(j) = i+1;
            j = j+1;
        end
    end
    ind = ind(ind~=0);
    m(ind,:) = [];
    x = m;
end

