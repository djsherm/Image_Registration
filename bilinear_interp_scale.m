function out_img = bilinear_interp_scale(in_img, Sr, Sc)
%% DOCUMENTAION

% FUNCTION ACCEPTS AN IMAGE AND PERFORMS BILINEAR INTERPOLATION FOR A
% SCALED IMAGE ONLY

% MADE BY: DANIEL SHERMAN
% MARCH 9, 2020

%% START OF CODE

[m,n] = size(in_img); %find size of input image

R_p = round(m*Sr); %find new number of rows
C_p = round(n*Sc); %find new number of columns

J = zeros(R_p, C_p); %initialize new image

%iterate through pixel values to determine new pixel values
for r_p = [1:R_p]
    for c_p = [1:C_p]
        r_f = r_p/Sr;
        c_f = c_p/Sc;
        
        r = floor(r_f); %new number of rows
        c = floor(c_f); %new number of columns
        
        d_c = c_f - c; %difference between current column and new number of columns
        d_r = r_f - r; %difference between current row and new number of rows
      
        %run bilinear interpolation only where pixel values exist
        if r <= m - 1 && c <= n - 1 && r >=2 && c >= 2
            J(r_p, c_p) = in_img(r,c)*(1 - d_r)*(1 - d_c) + ... 
            in_img(r + 1, c)*(d_r)*(1 - d_c) + ...
            in_img(r, c + 1)*(d_c)*(1 - d_r) + ...
            in_img(r + 1, c + 1)*(d_r)*(d_c); %bilinear interpolation formula
        else
        end
        
    end
end

[m_j, n_j] = size(J); %collect size of scaled image

if m_j <= m; %check if new image is smaller than original
    out_img = J;
    out_img(m_j + 1:m, n_j:n) = 0; %ensure same size by padding with 0 to the original dimension
else m_j > m; %check if new image is larger than original
        out_img = J(1:m, 1:n); %take subsection of new image to maintain same size
end
