function output_img = edgesDepth(orig_img)
%EDGESDEPTH Returns edge-detected image where pixel intensity is
%proportional to sharpness of edge
%   Detailed description of algorithm TBD
%orig_img = im2gray(orig_img);
output_img = zeros(size(orig_img,1),size(orig_img,2));
edge_img = edge(orig_img, 'canny', 0.1);
for i = 1:size(edge_img,1)
    for j=1:size(edge_img,2)
        if edge_img(i,j)==0
            continue
        end
        [i_e, j_e] = furthestPoint(edge_img,i,j);
        if i_e == i && j_e == j
            continue
        end
        delta = [i_e - i j_e - j]; delta = 5 * delta / sqrt(delta(1)^2 + delta(2)^2);
        id1 = fix(i + delta(2)); jd1 = fix(j - delta(1));
        id2 = fix(i - delta(2)); jd2 = fix(j + delta(1));
        id1v = sort([1 id1 size(orig_img,1)]); id2v = sort([1 id2 size(orig_img,1)]);
        jd1v = sort([1 jd1 size(orig_img,2)]); jd2v = sort([1 jd2 size(orig_img,2)]);
        colors1 = orig_img(id1v(2), jd1v(2), :);
        colors2 = orig_img(id2v(2), jd2v(2), :);
        % Euclidean distance
        output_img(i,j) = sqrt(sum((colors1-colors2).^2));
    end
end
%output_img = output_img.^2;
%if max(output_img(:)) > 0
%    output_img = output_img ./ max(output_img(:));
%end
end

function [i_e, j_e] = furthestPoint(edge_img,i,j)
for radius=10:-1:1
    for i_c = max([1 i-radius]):min([size(edge_img,1) i+radius])
        if j+radius<=size(edge_img,2) && edge_img(i_c,j+radius)
            i_e = i_c;
            j_e = j + radius;
            return
        end
        if j-radius>=1 && edge_img(i_c,j-radius)
            i_e = i_c;
            j_e = j - radius;
            return;
        end
    end
    for j_c = max([1 j-radius]):min([size(edge_img,2) j+radius])
        if i+radius<=size(edge_img,1) && edge_img(i+radius,j_c)
            i_e = i+radius;
            j_e = j_c;
            return;
        end
        if i-radius>=1 && edge_img(i-radius,j_c)
            i_e = i-radius;
            j_e = j_c;
            return;
        end
    end
end
i_e = i;
j_e = j;
end