function hough_img = generateHoughAccumulator(img, theta_num_bins, rho_num_bins)
hough_img = zeros(theta_num_bins,rho_num_bins);
% for any choice of theta, we set
% rho = -x sin theta + y cos theta
max_abs_rho = sqrt(size(img,1)^2 + size(img,2)^2);
for i = 1:size(img,1)
    for j = 1:size(img,2)
        if img(i,j)
            for k=0:(theta_num_bins-1)
                theta = k*pi/theta_num_bins;
                rho = i*cos(theta) - j*sin(theta);
                rho = (rho/max_abs_rho + 1)/2;
                l = floor(rho*rho_num_bins);
                hough_img(k+1,l+1) = hough_img(k+1,l+1)+1;
            end
        end
    end
end
hough_scale = max(hough_img(:));
for i = 1:theta_num_bins
    for j = 1:rho_num_bins
        hough_img(i,j) = hough_img(i,j)*255/hough_scale;
    end
end
