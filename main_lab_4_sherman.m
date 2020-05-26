%% ENGG 4660: MEDICAL IMAGE PROCESSING
% LAB 4: IMAGE REGISTRATION
% DANIEL SHERMAN
% 0954083
% MARCH 7, 2020

%% START OF CODE

close all
clear all
clc

%% LOAD IN FILES

email = imread('img_xfm07.jpg');
points = load('points07.txt');
mri = imread('mri.jpg');

%points in the reference image
x1 = points(1,:);
y1 = points(2,:);
%points in the given image
x2 = points(3,:);
y2 = points(4,:);

disp('Done loading files')

%% FIND TRANSFORMATION MATRIX, AND TRANSFORMATIONS

[tx_matrix, angle, scale, tx, ty] = affine_tx(x1, y1, x2, y2); %find the transformation matrix

angle = double(angle); %convert to usable type
scale = double(scale);

%apply transformation found on 'mri.jpg'
transform_image_new(mri, angle(2), tx, ty, scale(2), scale(2))

disp('Done finding the affine transformation matrix')

%% FIND THE MYSTERY IMAGE TRANSFORMATION

%display optimization function output (MSE) over iteration number
options = optimset('PlotFcns',@optimplotfval);

%determine optimal transformation values by calling the function
%mean_sq_err()
optimized = fminsearch(@mean_sq_err, [deg2rad(-7), 0.8565, -25, -3], options)

%scale original image with optimized scale
optimized_scale = bilinear_interp_scale(mri, optimized(2), optimized(2));
%rotate original image with optimized angle
optimized_rot = bilinear_interp_angle(optimized_scale, optimized(1));
%translate original image with optimized translation
optimized_img = bilinear_interp_translate(optimized_rot, optimized(3), optimized(4));

%display mystery image and optimized transformations applied to original
%image
figure()
subplot(1,2,1)
imshow(email)
title('Emailed Image')
subplot(1,2,2)
imshow(uint8(optimized_img))
title('Minimized MSE Image Transformations')
