function [x,ind] =  find_sleep(sig,n,tresh)
    sig2 = sig < tresh(1)& sig > tresh(2);
    [x,ind] = find_consecutive(sig2,n);
end