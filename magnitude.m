%%formula magnitude = sqrt(horizontalGradient^2 + verticalGradient^2)
function img = magnitude(hGradient, vGradient, n, m)
img = zeros(n,m);
hGradient = double(hGradient);
vGradient = double(vGradient);
    for i = 1:1:n
        for j=1:1:m 
            img(i,j) = sqrt(hGradient(i,j)^2 + vGradient(i,j)^2)/sqrt(2);
        end
    end
end