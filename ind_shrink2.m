function x = ind_shrink2(m,thresh)
    ind = zeros(size(m,1));
    j = 0;
    for i = 1:(size(m,1)-1)
        if (m(i-j+1,1)-m(i-j,2)) < thresh
            m(i-j,2) = m(i-j+1,2);
            m(i-j+1,:) = [];
            j = j+1;
        end
    end
    ind = ind(ind~=0);
    m(ind,:) = [];
    x = m;
end

