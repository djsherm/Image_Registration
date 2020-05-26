function output_img = transform_image_new(in_img, theta, tx, ty, Sx, Sy)
%% DOCUMENTATION

% FUNCTION ACCEPTS AN IMAGE, ANGLE, TRANSLATION IN X AND Y, AND SCALING FACTOR IN X AND Y
% FUNCTION RETURNS A TRANSLATED IMAGE BY THE FACTORS SPECIFIED

% MADE BY: DANIEL SHERMAN
% MARCH 9, 2020

%% START OF CODE

scale = bilinear_interp_scale(in_img, Sx, Sy); %apply scaling

rotate = bilinear_interp_angle(scale, theta); %apply rotation

translate = bilinear_interp_translate(rotate, tx, ty); %apply translation

%% DISPLAY IMAGE

figure()
imshow(uint8(translate))
xlabel(strcat(['\theta = ', num2str(theta), ', T_x = ', ...
    num2str(tx), ', T_y = ', num2str(ty), ', S_x = ' num2str(Sx), ', S_y = ', num2str(Sy)]))
