function [probability, err, w1_new, w2_new, b1_new, b2_new] = perception(standard, feature, w1, w2, k, b1, b2)
    w1_new = w1;
    w2_new = w2;
    b1_new = b1;
    b2_new = b2;
    [c1,feature_size] = size(feature);
    %standard: 1 for pos, 0 for neg
    %k=200, 400
    %hidden layer
    hidden = hiddenLayer(feature, w1, k);
    hidden_derive = hidden;
    for i = 1:1:k
        if hidden(1,i) > 0
            hidden_derive(1,i) = 1;
        else
            hidden_derive(1,i) = 0;
        end
    end
    
    for i=1:1:k
        b1(1,i) = (-1) * b1(1,i);
    end
    hidden = hidden + b1;
    
    %output layer
    output = outputLayer(hidden, w2, k, b2);
    
    err = abs(standard - output);
    
    b2_new = b2 + 0.01 * err;
    
    probability = output;
    
    delta_i = err * output * (1-output);
    for i = 1:1:k
        w2_new(1,i) = w2(1,i) + 0.01 * hidden(1,i) * delta_i;
    end

    
    delta_j = zeros(1,k);
    for i = 1:1:k
        delta_j(1,i) = hidden_derive(1,i) * w2_new(1,i) * delta_i;
    end
    
    for i = 1:1:k
        b1_new(1,i) = b1(1,i) + 0.01 * delta_j(1,i);
    end
    
    for i = 1:1:k
        for j = 1:1:feature_size
            w1_new(i,j) = w1(i,j) + 0.01 * feature(1,j) * delta_j(1,i);
        end
    end
    

end