clear all;
close all;
clc;

n = 160;
m = 96;
 
%%20 images are stored in the I
I = cell(1, 30);
%I = zeros([[160,96],10]);

%1-20:training, 21-30:testing (pos,neg)
for d = 1:1:30
    m1 = imread(['D:\cv\pro2\train\', int2str(d),'.bmp']);
    r = m1(:,:,1);
    g = m1(:,:,2);
    b = m1(:,:,3);
    m1 = round(0.299*r + 0.587*g + 0.114*b);
    m1 = im2double(m1);
    m1 = round(m1*255);
    I{d} = m1;
    %I(:,:,d) = m1;
end

horizontal_mask = [-1 0 1;
                   -2 0 2;
                   -1 0 1];
vertical_mask = [1 2 1;
                 0 0 0;
                 -1 -2 -1];
horizontalGradientGroup = cell(1,30);
verticalGradientGroup = cell(1,30);
magnitudeMatrixGroup = cell(1,30);
angleMatrixGroup = cell(1,30);
hog_bin_Group = cell(1,30);
lbp_bin_Group = cell(1,30);
hog_lbp_Group = cell(1,30);
for d = 1:1:30
    img = I{d};
    horizontalGradientGroup{d} = sobel(img, n, m, 3, horizontal_mask);
    verticalGradientGroup{d} = sobel(img, n, m, 3, horizontal_mask);
    magnitudeMatrixGroup{d} = magnitude(horizontalGradientGroup{d}, verticalGradientGroup{d}, n, m);
    angleMatrixGroup{d} = gradientAngle(horizontalGradientGroup{d}, verticalGradientGroup{d}, n, m);
    hog_bin_Group{d} = HOG(angleMatrixGroup{d}, magnitudeMatrixGroup{d}, n, m);
    lbp_bin_Group{d} = LBP(img, n, m);
    hog_lbp_Group{d} = [hog_bin_Group{d}, lbp_bin_Group{d}];
end

hog_bin_size = 7524;
hog_lbp_bin_size = 11064;

b_pr = floor(n/16);
b_pc = floor(m/16);

k=400;

w1 = zeros(k, hog_bin_size);
w2 = zeros(1,k);

b1 = zeros(1,k);
b2 = -1;

count = 0;
flag = 0;
for i = 1:1:k
    for j = 1:1:hog_bin_size
        %w1(i,j) = 0.1;
        w1(i,j) = ((rand(1)*2)-1)/10;
    end
end

for i = 1:1:k
    %w2(1,i) = 0.1;
    w2(1,i) = ((rand(1)*2)-1)/10;
    b1(1,i) = ((rand(1)*2)-1)/10;
end

pro_group = zeros(1,20);
avg_err = 2;
last_avg_err = 0;
cur_err = 0;
w1_new = w1;
w2_new = w2;
b1_new = b1;
b2_new = ((rand(1)*2)-1)/10;
%[probability, err, w1_new, w2_new] = perception(1, hog_bin_Group{2}, w1, w2, 200);
%abs(avg_err-last_avg_err) > 0.1 && 
while(count < 500)
    cur_err = 0;
    last_avg_err = avg_err;
    
%     for d2 = 1:1:10
%         hog_bin1 = hog_bin_Group{d2};
%         w1 = w1_new;
%         w2 = w2_new;
%         [probability, err, w1_new, w2_new] = perception(1, hog_bin1, w1, w2, k);
% %         w1 = w1_new;
% %         w2 = w2_new;  
%         pro_group(1,d2) = probability;
%         cur_err = cur_err + err;
%         
%         hog_bin2 = hog_bin_Group{d2+10};
%         w1 = w1_new;
%         w2 = w2_new;  
%         [probability, err, w1_new, w2_new] = perception(0, hog_bin2, w1, w2, k);
%         pro_group(1,d2+10) = probability;
%         cur_err = cur_err + err;
%     end
    
    for d2 = 1:1:10
        hog_bin = hog_bin_Group{d2};
        [probability, err, w1_new, w2_new, b1_new, b2_new] = perception(1, hog_bin, w1, w2, k, b1, b2);
        w1 = w1_new;
        w2 = w2_new;  
        b1 = b1_new;
        b2 = b2_new;
        pro_group(1,d2) = probability;
        cur_err = cur_err + err;
    end
    
    for d2 = 11:1:20
        hog_bin = hog_bin_Group{d2};
        [probability, err, w1_new, w2_new, b1_new, b2_new] = perception(0, hog_bin, w1, w2, k, b1, b2);
        w1 = w1_new;
        w2 = w2_new;
        b1 = b1_new;
        b2 = b2_new;
        pro_group(1,d2) = probability;
        cur_err = cur_err + err;
    end
    
    count = count + 1;
    avg_err = cur_err/20;

end

test_label = zeros(1,10);
test_probability = zeros(1,10);

for d = 1:1:5
    [probability, err, w1_new, w2_new, b1_new, b2_new] = perception(1, hog_bin_Group{20+d}, w1, w2, k, b1, b2);
    test_probability(1,d) = probability;
    [probability, err, w1_new, w2_new, b1_new, b2_new] = perception(0, hog_bin_Group{20+d+5}, w1, w2, k, b1, b2);
    test_probability(1,d+5) = probability;
end
% 
% for d = 1:1:5
%     [probability, err, w1_new, w2_new] = perception(1, hog_bin_Group{20+d}, w1, w2, k);
%     test_probability(1,d) = probability;
% end
% for d = 6:1:10
%     [probability, err, w1_new, w2_new] = perception(0, hog_bin_Group{20+d}, w1, w2, k);
%     test_probability(1,d) = probability;
% end
for i = 1:1:10
     if test_probability(1,i) >= 0.6
        test_label(1,i) = 1;
    elseif test_probability(1,i) < 0.6 && test_probability(1,i) >0.4
        test_label(1,i) = 0.5;
    end     
end


train_label = zeros(1,20);
for i = 1:1:20
    if pro_group(1,i) >= 0.6
        train_label(1,i) = 1;
    elseif pro_group(1,i) < 0.6 && pro_group(1,i) >0.4
        train_label(1,i) = 0.5;
    end  
end


% img_test = imread('D:\cv\pro2\test(pos)\crop1b.bmp');
% [pro_test, err, w1_new_test, w2_new_test] = perception(1, hog_bin, w1_new, w2_new, 200);

