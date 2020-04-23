function lbp_bin = LBP(img, n, m)
    key = [0, 1, 2, 3, 4, 6, 7, 8, 12, 14, 15, 16, 24, 28, 30, 31, 32, 48, 56, 60, 62, 63, 64, 96, 112, 120, 124, 126, 127, 128, 129, 131, 135, 143, 159, 191, 192, 193, 195, 199, 207, 223, 224, 225, 227, 231, 239, 240, 241, 243, 247, 248, 249, 251, 252, 253, 254, 255];
    value = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58];
    map = containers.Map(key,value);
    
    b_pr = floor(n/16);
    b_pc = floor(m/16);
    %lbp_bin = zeros(1,b_pr*b_pc*59);
    lbp_bin = [];
    lbp_res = img;
    lbp_label = img;
    
    %calculate binary lbp for each pixel
    binary_res = 0;
    for i = 1:1:n
        for j = 1:1:m
            binary_res = 0;
            if i == 1 || j == 1 || i ==n || j == m
                binary_res = 5;
            
            else
                if img(i-1, j-1) > img(i, j)
                    binary_res = binary_res + power(2, 7);
                end
                
                if img(i-1, j) > img(i, j)
                    binary_res = binary_res + power(2, 6);
                end
                
                if img(i-1, j+1) > img(i, j)
                    binary_res = binary_res + power(2, 5);
                end
                
                if img(i, j+1) > img(i, j)
                    binary_res = binary_res + power(2, 4);
                end
                
                if img(i+1, j+1) > img(i, j)
                    binary_res = binary_res + power(2, 3);
                end
                
                if img(i+1, j) > img(i, j)
                    binary_res = binary_res + power(2, 2);
                end
                
                if img(i+1, j-1) > img(i, j)
                    binary_res = binary_res + power(2, 1);
                end
                
                if img(i, j-1) > img(i, j)
                    binary_res = binary_res + power(2, 0);
                end
                
            end
            lbp_res(i, j) = binary_res;
            binary_res = 0;
        end
    end    
    
    %classdify each binary lbp into one of the 59 bins label
    for i =1:1:n
        for j = 1:1:m
            if isKey(map, lbp_res(i, j)) == 1
                lbp_label(i, j) = map(lbp_res(i, j));
            else
                lbp_label(i, j) = 59;
            end
        end
    end
    
    for b1 = 1:1:b_pr
        for b2 = 1:1:b_pc
            
            block_histogram = zeros(1,59);
            for w = 1:1:16
                for q = 1:1:16

                    i = w + (b1-1) * 16;
                    j = q + (b2-1) * 16;

                    block_histogram(1, lbp_label(i,j)) = block_histogram(1, lbp_label(i,j)) + 1;

                end
            end    
            
            for di = 1:1:59
                block_histogram(1,di) = block_histogram(1,di)/256;
            end
            
            lbp_bin = [lbp_bin, block_histogram];        
            
        end
    end
    


end