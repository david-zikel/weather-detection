function horiz_y = findHorizonLine(img) % img is input as double
    row_sums = sum(img, 2);
    row_squares = sum(img.^2, 2);
    min_error = sum(row_squares) - sum(row_sums).^2/(size(img,1)*size(img,2));
    horiz_y = 0;
    for i=1:size(img,1)-1 % horizon is from pixels 1 through i
        avg_above = sum(row_sums(1:i))/(i*size(img,2));
        err_above = sum(row_squares(1:i)) - avg_above^2*i*size(img,2);
        avg_below = sum(row_sums(i:size(img,1)))/((size(img,1)-i)*size(img,2));
        err_below = sum(row_squares(i:size(img,1))) - avg_below^2*(size(img,1)-i)*size(img,2);
        if sum(err_above + err_below) < sum(min_error)
            min_error = err_above + err_below;
            horiz_y = i;
        end
    end
end