%%use given mask to compute gradient for each point
%%normlize after computation
function sum = sobelGradient(img, w, h, mask)
    sum = 0;
    %img = uint8(img);
    [len1,len2] = size(mask);
    for i = 1:1:len1
        for j = 1:1:len2
            d1 = w-2;
            d2 = h-2;
            sum = sum + round(img(d1+i,d2+j) * mask(i, j)/4);
        end
    end
end