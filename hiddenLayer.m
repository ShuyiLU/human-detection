function hidden = hiddenLayer(feature,w1, k)
    hidden = zeros(1, k);
    [c1,n] = size(feature);
    
    %for in
    for i = 1:1:k
        for j=1:1:n
            hidden(1,i) = hidden(1,i) + w1(i,j) * feature(1,j);
        end
    end
    
    %for g(in)
    for i = 1:1:k
        if hidden(1,i) < 0
            hidden(1,i) = 0;
        end
    end
    
end