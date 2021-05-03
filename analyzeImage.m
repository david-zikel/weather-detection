function out_struct = analyzeImage(img)
%ANALYZEIMAGE Returns estimated weather data given an image.
%   Uses edge sharpness, color above skyline, and Retinex brightness as
%   input data to be aggregated into out_struct.

[lightingImgRed,~] = retinexExtract(img(:,:,1),.0001,.1);
[lightingImgGreen,~] = retinexExtract(img(:,:,2),.0001,.1);
[lightingImgBlue,~] = retinexExtract(img(:,:,3),.0001,.1);
[lightingImgGray,~] = retinexExtract(im2gray(img),.0001,.1);

sky_y = findHorizonLine(img);
sky_delta = [0 0 0];
if sky_y>0
    for i=1:3
        color_u = img(1:sky_y,:,i);
        color_d = img(sky_y+1:size(img,1),:,i);
        %figure; imshow(color_u);
        %figure; imshow(color_d);
        sky_delta(i) = mean(color_u(:))-mean(color_d(:));
    end
end

edge_img = edgesDepth(img);
edge_binary = edge_img > 0;
if any(edge_binary(:))
    avg_edge = sum(edge_img(:))/sum(edge_binary(:));
else
    avg_edge = 0;
end

figure; imshow(lightingImgRed);
figure; imshow(lightingImgGreen);
figure; imshow(lightingImgBlue);
figure; imshow(lightingImgGray);
figure; imshow(edge_img);
figure; imshow(img); line([1 size(img,2)],[sky_y sky_y],'LineWidth',2);
avg_edge
sky_delta

imRed = im2double(img(sky_y+1:size(img,1),:,1));
imGreen = im2double(img(sky_y+1:size(img,1),:,2));
imBlue = im2double(img(sky_y+1:size(img,1),:,3));
imGray = im2double(im2gray(img(sky_y+1:size(img,1),:,:)));
lightingImgRed = lightingImgRed(sky_y+1:size(img,1),:,:);
lightingImgGreen = lightingImgGreen(sky_y+1:size(img,1),:,:);
lightingImgBlue = lightingImgBlue(sky_y+1:size(img,1),:,:);
lightingImgGray = lightingImgGray(sky_y+1:size(img,1),:,:);
[mean(imRed(:)) mean(imGreen(:)) mean(imBlue(:)) mean(imGray(:));
 mean(lightingImgRed(:)) mean(lightingImgGreen(:)) mean(lightingImgBlue(:)) mean(lightingImgGray(:))]

if mean(lightingImgRed(:)) > mean(lightingImgBlue(:))
    location = 'Warm/extreme light';
else
    location = 'Cool/midday';
end

if avg_edge < .1
    fog_str = 'High fog';
elseif avg_edge < .2
    fog_str = 'Fog';
else
    fog_str = 'Negligible fog';
end

if mean(imRed(:)) < .2
    time_str = 'Night';
elseif mean(imRed(:)) < .5
    time_str = 'Midday or bright night';
else
    time_str = 'Day';
end

out_struct = struct('fog', 1-avg_edge, ... % heavy fog: > .8
                    'fog_str', fog_str, ...
                    'time', mean(imRed(:)), ... % proportional to red below sky_y
                    'time_str', time_str, ...
                    'warmth', mean(lightingImgRed(:))-mean(lightingImgBlue(:))+1, ...
                    'warmth_str', location);
% or:
%out_struct = categorizeFoundData(mean(lightingImgRed(:)),
%                                 mean(lightingImgGreen(:)),
%                                 mean(lightingImgBlue(:)),
%                                 mean(lightingImgGray(:)),
%                                 sky_delta,
%                                 someFunctionOf(edge_img));
end
