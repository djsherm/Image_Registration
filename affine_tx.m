function [tx_matrix, out_theta, out_scale, t_x, t_y] = affine_tx(x1, y1, x2, y2)
%% DOCUMENTATION

% FUNCTION COMPUTES THE AFFINE TRANSFORM BETWEEN TWO SETS OF POINTS, 
% IN THIS CASE, x1, y1, x2, y2
% WHERE x1, y1 ARE POINTS IN THE REFERENCE IMAGE, 
% AND x2, y2 ARE POINTS IN THE TRANSFORMED IMAGE

% MADE BY: DANIEL SHERMAN
% MARCH 7, 2020

%% START OF CODE

%% CREATE THE AFFINE TRANSFORMATION MATRIX

img_input_v = [x1;y1;ones(size(x1))]; %create points in original image vector
img_output_x = [x2;y2;ones(size(x2))]; %create points in transformed image vector

%matrix multiplication to get the 3x3 transformation matrix
tx_matrix = (img_output_x*(img_input_v.'))*inv(img_input_v*img_input_v.');

%% EVALUATE THE TRANSFORMATION MATRIX

%apply the transformation matrix to the given set of input points
affine_output = tx_matrix*img_input_v;

x_output = affine_output(1,:); %parse out x coordinates
y_output = affine_output(2,:); %parse out y coordinates

figure()
scatter(x_output,y_output, 'filled') %plot the output of the transformation matrix
hold on
scatter(x2,y2, 'filled') %plot the given output points
legend('Output Points', 'Transfomed Input Points')
xlabel('X Points')
ylabel('Y Points')
title('Output Points and Transformed Input Points')

%euclidean distance between given output points and calculated transformed points
err = sqrt((x_output - x2).^2 + (y_output - y2).^2);
av_err = mean(err); %average euclidean error

%% FIND THETA, TX, TY, AND SCALE

t_x = tx_matrix(1,3); %grab x translation from matrix element
t_y = tx_matrix(2,3); %grab y translation from matrix element

syms theta scale %symbolically define the angle and scaling factor
%define equations based on the transformation matrix elements and
%theoretical definitions
eq1 = scale*cos(theta) == tx_matrix(1,1);
eq2 = -sin(theta) == tx_matrix(1,2);

[out_theta, out_scale] = solve([eq1, eq2], [theta, scale]); %solve nonlinear system of equations