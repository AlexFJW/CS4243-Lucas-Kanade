
function res = cornerDetector(pic)
    [rows, cols] = size(pic);
    gxTemp = pic(:,2:cols) - pic(:,1:cols-1); %do matrix subtraction
    gx = [gxTemp, zeros(rows, 1)];
    
    gyTemp = pic(2:rows, :) - pic(1:rows-1, :);
    gy = [gyTemp; zeros(1, cols)];
    
    I_xx = gx .* gx;
    I_xy = gx .* gy;
    I_yy = gy .* gy;
    
    fullwin = 13;
    gkern = gausswin(fullwin) * gausswin(fullwin).';  % array transpose
    
    W_xx = conv2(double(I_xx), double(gkern));
    W_xy = conv2(double(I_xy), double(gkern));
    W_yy = conv2(double(I_yy), double(gkern));
    
    eig_min = W_xx;
    [e_rows, e_cols] = size(eig_min);
    
    for i = 1:e_rows
       for j = 1:e_cols
           W = [W_xx(i,j), W_xy(i,j); W_xy(i,j), W_yy(i,j)];
           eig_min(i,j) = min(eig(W));
       end
    end
    
    % Pad eig_min with zeroes
    eig_min_temp1 = [eig_min, zeros(e_rows, ceil(e_cols/fullwin)*fullwin - e_cols)];
    eig_min_temp2 = [eig_min_temp1; zeros(ceil(e_rows/fullwin)*fullwin - e_rows ,ceil(e_cols/fullwin)*fullwin)];

    cells = mat2cell(eig_min_temp2, ones(ceil(e_rows/fullwin),1)*fullwin, ones(ceil(e_cols/fullwin),1)*fullwin);
    
    [c_rows, c_cols] = size(cells);
    
    for i = 1:c_rows
        for j = 1:c_cols
            tempMat = cell2mat(cells(i,j));
            [max_val, max_index] = max(tempMat(:));
            [x, y] = ind2sub(size(tempMat), max_index);
            newMat = zeros(fullwin, fullwin);
            newMat(x,y) = max_val;
            cells(i,j) = mat2cell(newMat, [fullwin], [fullwin]);
        end
    end
    
    % eig_min with the highest value in each 13x13 cell
    eig_min_temp3 = cell2mat(cells);
    
    % Cut-off eigenvalue %
    cutoff = 5;
    temp1d = reshape(eig_min_temp3, 1, []);
    temp1d = sort(temp1d); % sort ascendingly
    
    cut_off_eig_val = temp1d(end-cutoff+1); %1-index
    
    [co_rows, co_cols] = find(eig_min_temp3 >= cut_off_eig_val);
    new_pic = pic;

    rectSize = 6;
    offset = floor(fullwin/2)+rectSize/2;
    
    for i = 1:cutoff
        new_pic = insertShape(new_pic, 'Rectangle', [co_cols(i)-offset, co_rows(i)-offset, rectSize, rectSize], 'Color', 'red');
    end
    
    res = new_pic;
    
    % Supposed to return eig values for LK algo %
%     res = eig_min_temp3;
end