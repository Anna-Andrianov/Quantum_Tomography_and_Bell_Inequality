[file, path] = uigetfile({'*.xlsx;*.csv', 'Excel or CSV Files (*.xlsx, *.csv)'}, 'Select the File');
full_path = fullfile(path, file);

if endsWith(file, '.csv')
    data = readmatrix(full_path);  % Read CSV file =>Goof for simulation matrix
else
    data = readmatrix(full_path, 'Sheet', '50 Bits');  % Read Excel sheet => Good for the experiment data
end

% --- Extract Columns (Bit, Alice V/H, Bob V/H) ---
bit = data(:, 1);     % Column for bit (0/ 1) 
alice_v = data(:, 2); % Alice-V measurements
alice_h = data(:, 3); % Alice-H measurements
bob_v = data(:, 4);   % Bob-V measurements  
bob_h = data(:, 5);   % Bob-H measurements

% --- Calculate Number of 0 and 1 ---
num_1 = sum(bit);              % Total number of 1s
num_0 = length(bit) - num_1;   % Total number of 0s


function prob =  calculate_probability(bit,bit_val, alice_col_d, bob_col_d, alice_col_r, bob_col_r, num)
    if num == 0
        prob = 0;  % Avoid division by zero
    else
        mask = (bit == bit_val);  % Select rows where bit matches
        
        % Avoid empty selection by checking the size
        if sum(mask) == 0
            prob = 0;
        else
            % Sum over the entire array to ensure scalar output
            prob = sum((alice_col_d(mask) + bob_col_d(mask)) ./ ...
                  (alice_col_d(mask) + alice_col_r(mask) + bob_col_d(mask) + bob_col_r(mask))) / num;
        end
    end
end



density_matrix_HHVV = zeros(4, 4);
%VV->VV,VV->HH,HH->VV,HH->HH
PVV_VV = calculate_probability(bit, 1, alice_v, bob_v,alice_h, bob_h, num_1);
PVV_HH = calculate_probability(bit, 1,  alice_h, bob_h, alice_v, bob_v, num_1);
PHH_VV = calculate_probability(bit, 0, alice_v, bob_v, alice_h, bob_h, num_0);
PHH_HH = calculate_probability(bit, 0, alice_h, bob_h, alice_v, bob_v, num_0);


density_matrix_HHVV(1, 1) = PHH_HH;  % Probability of HH -> HH
density_matrix_HHVV(1, 4) = PHH_VV;  % Probability of HH -> VV
density_matrix_HHVV(4, 1) = PVV_HH;  % Probability of VV -> HH
density_matrix_HHVV(4, 4) = PVV_VV;  % Probability of VV -> VV



% --- Visualize the Probability Matrix HH-VV as a 3D Bar Plot ---
figure;
G2_plot = bar3(density_matrix_HHVV);

% Apply interpolated coloring
for k = 1:length(G2_plot)
    zdata = G2_plot(k).ZData;
    G2_plot(k).CData = zdata;
    G2_plot(k).FaceColor = 'interp';
end

% Customize the plot labels
set(gca, 'XTickLabel', {'HH', 'HV', 'VH', 'VV'});
set(gca, 'YTickLabel', {'HH', 'HV', 'VH', 'VV'});
title('Density Matrix Simulation HH-VV');
%title('Density Matrix HH-VV - 50 Bits');
xlabel('\bf Detector');
ylabel('\bf Source');
colormap(parula);
colorbar;

%densitu matrix HVVH
density_matrix_HV = zeros(4, 4);
PHV_HV = calculate_probability(bit, 0, alice_h, bob_v, alice_v, bob_h, num_0);
PHV_VH = calculate_probability(bit, 0, alice_v, bob_h,alice_h,  bob_v, num_0);
PVH_HV = calculate_probability(bit, 1, alice_h, bob_v,alice_v, bob_h, num_1);
PVH_VH = calculate_probability(bit, 1, alice_v, bob_h,alice_h,  bob_v, num_1);

density_matrix_HV(3, 2) =PHV_VH;  % Probability of HV -> VH
density_matrix_HV(3, 3) = PVH_VH;  % Probability of VH -> VH
density_matrix_HV(2, 2) = PHV_HV;  % Probability of HV -> HV
density_matrix_HV(2, 3) = PVH_HV;  % Probability of VH -> HV

% --- Visualize the Probability Matrix H as a 3D Bar Plot ---
figure;
G2_plot = bar3(density_matrix_HV);

% Apply interpolated coloring
for k = 1:length(G2_plot)
    zdata = G2_plot(k).ZData;
    G2_plot(k).CData = zdata;
    G2_plot(k).FaceColor = 'interp';
end

% Customize the plot labels
set(gca, 'XTickLabel', {'HH', 'HV', 'VH', 'VV'});
set(gca, 'YTickLabel', {'HH', 'HV', 'VH', 'VV'});
title('Density Matrix Simulation HV-VH');
%title('Density Matrix HV-VH - 50 Bits');
xlabel('\bf Detector');
ylabel('\bf Source');
colormap(parula);
colorbar;

