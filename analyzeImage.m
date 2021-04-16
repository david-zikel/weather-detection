function out_struct = analyzeImage(img)
%ANALYZEIMAGE Returns estimated weather data given an image.
%   Uses edge sharpness, color above skyline, and Retinex brightness as
%   input data to be aggregated into out_struct.

[lightingImgRed,~] = retinexExtract(img(:,:,1),.0001,.1);
[lightingImgGreen,~] = retinexExtract(img(:,:,2),.0001,.1);
[lightingImgBlue,~] = retinexExtract(img(:,:,3),.0001,.1);

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

figure; imshow(lightingImgRed);
figure; imshow(lightingImgGreen);
figure; imshow(lightingImgBlue);
figure; imshow(edge_img);
sky_delta

%out_struct = struct('fog', numeric,
%                    'time', 00:00-23:00,
%                    'season', string);
% or:
%out_struct = categorizeFoundData(mean(lightingImgRed(:)),
%                                 mean(lightingImgBlue(:)),
%                                 mean(lightingImgGreen(:)),
%                                 sky_delta,
%                                 someFunctionOf(edge_img));
end
