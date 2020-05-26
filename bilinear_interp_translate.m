function out_img = bilinear_interp_translate(in_img, tx, ty)
%% DOCUMENTAION

% FUNCTION ACCEPTS AN IMAGE AND PERFORMS BILINEAR INTERPOLATION FOR A
% TRANSLATED IMAGE ONLY

% MADE BY: DANIEL SHERMAN
% MARCH 9, 2020

%% START OF CODE

[m,n] = size(in_img);

J = zeros(m, n); %initialize new image

for x_i = [1:m]
    for y_i = [1:n]
        
        %translate image pixels
        x2 = x_i + tx;
        y2 = y_i + ty;
        
        r = floor(x2);
        c = floor(y2);
        
        d_r = x2 - r;
        d_c = y2 - c;
        
        %run bilinear interpolation only where pixel values exist
        if r <= m - 1 && c <= n - 1 && r >=2 && c >= 2
            J(x_i, y_i) = in_img(r,c)*(1 - d_r)*(1 - d_c) + ... 
                in_img(r + 1, c)*(d_r)*(1 - d_c) + ...
                in_img(r, c + 1)*(d_c)*(1 - d_r) + ...
                in_img(r + 1, c + 1)*(d_r)*(d_c); %bilinear interpolation formula
        else
        end
        
    end
end

out_img = J;

