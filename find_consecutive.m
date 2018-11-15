function [x, indices] = find_consecutive(sig,n)
j=0;
ind=1;
indices = zeros(size(sig,2),2);

for i = 1:(length(sig)-1)
    if sig(i)==1 && sig(i+1)==1
        j = j+1;
    else
        if j+1 < n
            sig((i-j):i) = 0;
            j = 0;
        else
            indices(ind,2) = i;
            indices(ind,1) = i-j;
            j = 0;
            ind = ind+1;
            
        end
     end
     %j 
end

    
    x = sig;
    M = indices(indices~=0);
    indices = reshape(M,[size(M,1)/2,2]);
    
end
