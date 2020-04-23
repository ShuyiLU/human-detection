function angleDegree = gradientAngle(horizontal, vertical, n, m)
    angleDegree = horizontal;
    h_gradient = horizontal;
    v_gradient = vertical;
    for w = 6:1:n-5
        for h=6:1:m-5
            angleDegree(w,h) = atan2(v_gradient(w,h), h_gradient(w,h))/pi * 180;
            while angleDegree(w,h) >= 170
                angleDegree(w,h) = angleDegree(w,h) - 180;
            end
        end
    end
end
                