
% Set the number of random numbers to generate
n = 20;

% Generate n random numbers, either 0 or 1, using the randi() function
%rand_nums = randi([0 1], 1, n);
rand_nums = randi([0 1], n, 1);

% Display the random numbers
disp(rand_nums);

sum(rand_nums)

% Calculate the sum of the random numbers
total_sum = sum(rand_nums);
disp(['Sum of pulses: ', num2str(total_sum)]);

% Export to CSV file
writematrix(rand_nums, 'random_pulses.csv');

% Append the sum to the CSV file
fileID = fopen('random_pulses.csv', 'a');  % Open in append mode
fprintf(fileID, 'Total\n%d\n', total_sum);  % Append the sum to a new row
fclose(fileID);

disp('Random pulses and sum exported to random_pulses.csv');