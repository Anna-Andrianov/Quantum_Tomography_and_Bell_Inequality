% Load the video
v = VideoReader('D:\Programs in D\Matlab projects Q tomography\part 2\alice0bob-225_0s4tZRIm.mp4');

% Read the first frame
frame = read(v, 1);

% Display the frame
figure;
imshow(frame);
title('Select the top-left and bottom-right corners of the region of interest');

% Use ginput to select two points
[x, y] = ginput(2);

% Convert points to integers (row and column indices)
row_start = round(y(1));
row_end = round(y(2));
col_start = round(x(1));
col_end = round(x(2));

% Show the selected region
roi = frame(row_start:row_end, col_start:col_end, :); % ROI includes all channels
figure;
imshow(roi);
title('Selected Region of Interest');

% Save the ROI coordinates for further use
fprintf('Row range: %d to %d\n', row_start, row_end);
fprintf('Column range: %d to %d\n', col_start, col_end);
