function out = outputLayer(hidden, w2, k, b2)
%k = 200, 400
    out = 0;
    %for in
    for i=1:1:k
        out = out + w2(1,i) * hidden(1,i);
    end
    out = out + b2*(-1);
    p = out;
    out = 1/(1+exp(-out));
end