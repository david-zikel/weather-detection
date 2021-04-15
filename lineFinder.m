function line_detected_img = lineFinder(orig_img, hough_img, hough_threshold)
max_abs_rho = sqrt(size(orig_img,1)^2 + size(orig_img,2)^2);
fh = figure(); imshow(orig_img); hold on;
for k = 0:(size(hough_img,1)-1)
    for l = 0:(size(hough_img,2)-1)
        if hough_img(k+1,l+1)>=hough_threshold
            theta = k*pi/size(hough_img,1);
            rho = (2*l/size(hough_img,2)-1)*max_abs_rho;
            x = [-max_abs_rho*cos(theta)-rho*sin(theta) max_abs_rho*cos(theta)-rho*sin(theta)];
            y = [-max_abs_rho*sin(theta)+rho*cos(theta) max_abs_rho*sin(theta)+rho*cos(theta)];
            line(x,y);
        end
    end
end
line_detected_img = saveAnnotatedImg(fh);

function annotated_img = saveAnnotatedImg(fh)
figure(fh); % Shift the focus back to the figure fh

% The figure needs to be undocked
set(fh, 'WindowStyle', 'normal');

% The following two lines just to make the figure true size to the
% displayed image. The reason will become clear later.
img = getimage(fh);
truesize(fh, [size(img, 1), size(img, 2)]);

% getframe does a screen capture of the figure window, as a result, the
% displayed figure has to be in true size. 
frame = getframe(fh);
frame = getframe(fh);
pause(0.5); 
% Because getframe tries to perform a screen capture. it somehow 
% has some platform depend issues. we should calling
% getframe twice in a row and adding a pause afterwards make getframe work
% as expected. This is just a walkaround. 
annotated_img = frame.cdata;
