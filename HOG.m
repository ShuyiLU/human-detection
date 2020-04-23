function bin_res = HOG(angle, magnitude, n, m)
    
    b_pr = floor((n-2*8)/8) + 1;
    b_pc = floor((m-2*8)/8) + 1;
    
    bin_res = zeros(1, b_pr*b_pc*9*2*2);
    bin = zeros(1,9);
    bin_center = [0, 20, 40, 60, 80, 100, 120, 140, 160];
    lower_bound = angle;
    upper_bound = angle;
    
    for w = 1:1:n
        for h=1:1:m
            target = angle(w,h);
            lower_bound(w,h) = 1;
            upper_bound(w,h) = 9;
            for t=1:1:9
                if bin_center(1,t) < target
                    lower_bound(w,h) = max(lower_bound(w,h),t);
                end
                if bin_center(1,t) > target
                    upper_bound(w,h) = min(upper_bound(w,h), t);
                end
                if bin_center(1,t) == target
                    lower_bound(w,h) = max(lower_bound(w,h),t);
                    upper_bound(w,h) = min(upper_bound(w,h),t);
                end
            end
        end
    end

    k = 1;
    %there are total b_pr * b_pc block
    for b1 = 1:1:b_pr
        for b2 = 1:1:b_pc
        
             %per block : 4 cell
             for cell = 1:1:4     
                 bin = zeros(1,9);
                % per cell, 8*8 pixel, obtain bin [1*9]
                 for p = 1:1:8
                     for q = 1:1:8

                         if cell == 1
                            i = p;
                            j = q;
                         end
                         if cell == 2
                             i = p;
                             j = q+8;
                         end
                         if cell == 3
                             i = p+8;
                             j = q;
                         end
                         if cell == 4
                             i = p + 8;
                             j = q + 8;
                         end
                         i = i + (b1-1) * 8;
                         j = j + (b2-1) * 8;
                        lower_no = lower_bound(i,j);
                        upper_no = upper_bound(i,j);
                        
                        if lower_no == upper_no
                            bin(1,lower_no) = bin(1,lower_no) + magnitude(i,j);
                        else
                            lower_dis = (angle(i,j) - bin_center(1, lower_no))/20 * magnitude(i,j);
                            upper_dis = (bin_center(1, upper_no) - angle(i,j))/20 * magnitude(i,j);
                            bin(1, lower_no) = bin(1, lower_no) + upper_dis;
                            bin(1, upper_no) = bin(1, upper_no) + lower_dis;
                        end

                    end
                 end

                 %bin_res : 1*9, concatenate each cell in one block
                 for c = 1:1:9
                     bin_res(1, k) = bin(1, c);
                     k = k+1;
                     bin(1, c) = 0;
                 end
                
             end
             
             
             L2_sum = 0;
             for di = 36:-1:1
                 L2_sum = L2_sum + bin_res(1, k-di)^2;
             end
             normal_base = sqrt(L2_sum);
             if normal_base > 0
                 for di = 36:-1:1
                     bin_res(1, k-di) = bin_res(1,k-di)/normal_base;
                 end
             end

         end        
            
       
    end
    

     

    
%     k = 1;
%     for nk = 1:1:floor(n/8)
%         for mk = 1:1:floor(m/8)
%             bin = zeros(1,9);
%             for p = 1:1:8
%                 for q = 1:1:8
%                     lower_no = lower_bound(p+(nk-1)*8, q+(mk-1)*8);
%                     upper_no = upper_bound(p+(nk-1)*8, q+(mk-1)*8);
%                     lower_dis = (angle(p+(nk-1)*8, q+(mk-1)*8) - bin_center(1, lower_no))/20 * magnitude(p+(nk-1)*8, q+(mk-1)*8);
%                     upper_dis = (bin_center(1, upper_no) - angle(p+(nk-1)*8, q+(mk-1)*8))/20 * magnitude(p+(nk-1)*8, q+(mk-1)*8);
%                     bin(1, lower_no) = bin(1, lower_no) + upper_dis;
%                     bin(1, upper_no) = bin(1, upper_no) + lower_dis;
%                 end
%             end
%             for c = 1:1:9
%                 pixel_bin(1,k) = bin(1,c);
%                 k = k+1;
%             end        
%         end
%     end
end