%%This function is used to compute the gradient of each pixel after
%%gaussian smmothing, sobelGraident is the function contains the actual
%%operation to compute the gradient.
%%According to the given mask, compute horizontal and vertical gradient
%%respectively
function gradient = sobel(img, n, m, ud, mask)
gradient = img;
for w = ud+2:1:n-ud-1
    for h = ud+2:1:m-ud-1
        gradient(w,h) = sobelGradient(img, w, h, mask);
    end
end

%%for which outside the range, we set it as undefined and assign zero
for h = 1:1:m
    gradient(4,h) = 0;
    gradient(n-3,h) = 0;
end

for w = 1:1:n
    gradient(w,4) = 0;
    gradient(w,m-3) = 0;
end

for i=1:1:n
    for j=1:1:m
        gradient(i,j) = abs(gradient(i,j));
    end
end

end
             
             
             