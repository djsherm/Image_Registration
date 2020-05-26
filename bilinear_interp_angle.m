function out_img = bilinear_interp_angle(in_img, theta)
%% DOCUMENTAION

% FUNCTION ACCEPTS AN IMAGE AND PERFORMS BILINEAR INTERPOLATION FOR A
% ROTATED IMAGE ONLY

% MADE BY: DANIEL SHERMAN
% MARCH 9, 2020

%% START OF CODE

[m,n] = size(in_img); %find size of image
X_m = m/2; %find midpoint of rows
Y_m = n/2; %find midpoint of columns

J = zeros(m, n); %initialize new image

for x_i = [1:m]
    for y_i = [1:n]
        %rotate about the centre of the image
        x2 = cos(theta)*(x_i - X_m) + sin(theta)*(y_i - Y_m) + X_m;
        y2 = -sin(theta)*(x_i - X_m) + cos(theta)*(y_i - Y_m) + Y_m;
        
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

