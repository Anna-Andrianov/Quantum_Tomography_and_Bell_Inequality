% Threshold and Initialization
% ----------------------------
threshold = 0.96e5;  % Set threshold value

% --- Initialize Total Counts for Alice and Bob ---
N_a_total = zeros(1, 16);
N_b_total = zeros(1, 16);
N_total = zeros(1, 16);  % Combined counts for each video

% --- Define Alpha and Beta Angle Lists ---
alpha_angles = [-45, -45, -45, -45, 0, 0, 0, 0, 45, 45, 45, 45, 90, 90, 90, 90];
beta_angles  = [-22.5, 22.5, 67.5, 112.5, -22.5, 22.5, 67.5, 112.5, -22.5, 22.5, 67.5, 112.5, -22.5, 22.5, 67.5, 112.5];

% Loop Through 16 Videos
% ----------------------
for video_idx = 1:16
    
    % --- Select Video File for Each Iteration ---
    [file, path] = uigetfile({'*.mp4;*.avi;*.mov', 'Video Files (*.mp4, *.avi, *.mov)'}, ...
                              sprintf('Select Video %d of 16', video_idx));
    if isequal(file, 0)
        disp('No video selected. Exiting loop...');
        break;
    end
    full_path = fullfile(path, file);
    v = VideoReader(full_path);
    disp(['Processing video: ', full_path]);
    
    % --- Initialize Temporary Storage for Current Video ---
    AliceFrames = zeros(1, v.NumFrames);
    BobFrames = zeros(1, v.NumFrames);
    
    % --- Process Each Frame in the Video ---
    for i = 1:v.NumFrames
        frame = read(v, i);
        
        % --- Calculate Intensity for Alice and Bob's Pixel Regions ---
        AliceFrames(i) = sum(sum(frame(130:180, 954:1035, 1)));  % Alice 
        BobFrames(i) = sum(sum(frame(490:594, 930:1135, 1)));    % Bob 
    end
    
    
    % Plot Alice and Bob Signals
    % --------------------------
    % --- First Graph (Fixed Title and Labels) ---
    figure;  % Create new figure for the first plot
    plot(AliceFrames, 'Color', [1, 0.5, 0], 'LineWidth', 1.5);  % Alice (Orange)
    hold on;
    plot(BobFrames, 'Color', [0, 0.45, 0.75], 'LineWidth', 1.5);  % Bob (Blue)
    yline(threshold, '--k', 'Threshold');  % Threshold line
    xlabel('Frames');
    ylabel('Signal Intensity [AU]');
    title(sprintf('\\alpha = %.1f^\\circ, \\beta = %.1f^\\circ', alpha_angles(video_idx), beta_angles(video_idx)));
    hold off;

    % --- Second Graph (Custom Title or Labels) ---(OPTIONAL-cosmetical
    % only)---
    figure;  % Create another figure for the second plot
    plot(AliceFrames, 'Color', [1, 0.5, 0], 'LineWidth', 1.5);  % Alice (Orange)
    hold on;
    plot(BobFrames, 'Color', [0, 0.45, 0.75], 'LineWidth', 1.5);  % Bob (Blue)
    yline(threshold, '--k', 'Threshold');
    hold off;
    
    
    % --- Ask for Custom Title and Labels ---
    promptTitle = input('Enter title for second graph (leave blank for none): ', 's');
    promptXLabel = input('Enter x-label (leave blank for none): ', 's');
    promptYLabel = input('Enter y-label (leave blank for none): ', 's');
    
    if ~isempty(promptTitle)
        title(promptTitle);
    end
    if ~isempty(promptXLabel)
        xlabel(promptXLabel);
    end
    if ~isempty(promptYLabel)
        ylabel(promptYLabel);
    end
    
  % --- Initialize Counters ---
    N_a = 0;
    N_b = 0;
    cooldown = 10;  % Minimum frame separation for counting peaks

    % --- Alice Peak Detection ---
    last_peak_idx = -cooldown;
    for i = 1:length(AliceFrames)
        if AliceFrames(i) > threshold && (i - last_peak_idx) > cooldown
            N_a = N_a + 1;
            last_peak_idx = i;
        end
    end

    % --- Bob Peak Detection ---
    last_peak_idx = -cooldown;
    for i = 1:length(BobFrames)
        if BobFrames(i) > threshold && (i - last_peak_idx) > cooldown
            N_b = N_b + 1;
            last_peak_idx = i;
        end
    end

    
    % --- Store Counts for Each Video ---
    N_a_total(video_idx) = N_a;
    N_b_total(video_idx) = N_b;
    N_total(video_idx) = N_a + N_b;  % Combined count for Alice and Bob
    
    fprintf('Video %d: N_a = %d, N_b = %d\n', video_idx, N_a, N_b);
end

% Display Results
% ----------------
disp('Total Counts (Alice):');
disp(N_a_total);
disp('Total Counts (Bob):');
disp(N_b_total);
disp('Combined Counts:');
disp(N_total);


% Calculate Bell's Inequality S
% ------------------------------

% Extract N values for readability
N1 = N_total(1);  N2 = N_total(2);  N3 = N_total(3);  N4 = N_total(4);
N5 = N_total(5);  N6 = N_total(6);  N7 = N_total(7);  N8 = N_total(8);
N9 = N_total(9); N10 = N_total(10); N11 = N_total(11); N12 = N_total(12);
N13 = N_total(13); N14 = N_total(14); N15 = N_total(15); N16 = N_total(16);

% Bell's Inequality Formula
S = ((N1 + N11 - N3 - N9) / (N1 + N11 + N3 + N9)) ...
  - ((N2 + N12 - N4 - N10) / (N2 + N12 + N4 + N10)) ...
  + ((N5 + N15 - N7 - N13) / (N5 + N15 + N7 + N13)) ...
  + ((N6 + N16 - N8 - N14) / (N6 + N16 + N8 + N14));

% Display the result of S
fprintf('Bell''s Inequality Result: S = %.4f\n', S);


% Calculate Error for Bell's Inequality S
% ---------------------------------------

% Partial derivatives of S with respect to each N_i
dS_dN = zeros(1, 16);  % Initialize array for partial derivatives

% Calculate the denominator sums
D1 = N1 + N11 + N3 + N9;
D2 = N2 + N12 + N4 + N10;
D3 = N5 + N15 + N7 + N13;
D4 = N6 + N16 + N8 + N14;

% Calculate each partial derivative explicitly
dS_dN(1)  =  2 * (N3 + N9)  / D1^2;
dS_dN(3)  = -2 * (N1 + N11) / D1^2;
dS_dN(11) =  2 * (N3 + N9)  / D1^2;
dS_dN(9)  = -2 * (N1 + N11) / D1^2;

dS_dN(2)  = -2 * (N4 + N10) / D2^2;
dS_dN(4)  =  2 * (N2 + N12) / D2^2;
dS_dN(12) = -2 * (N4 + N10) / D2^2;
dS_dN(10) =  2 * (N2 + N12) / D2^2;

dS_dN(5)  =  2 * (N7 + N13) / D3^2;
dS_dN(7)  = -2 * (N5 + N15) / D3^2;
dS_dN(15) =  2 * (N7 + N13) / D3^2;
dS_dN(13) = -2 * (N5 + N15) / D3^2;

dS_dN(6)  =  2 * (N8 + N14) / D4^2;
dS_dN(8)  = -2 * (N6 + N16) / D4^2;
dS_dN(16) =  2 * (N8 + N14) / D4^2;
dS_dN(14) = -2 * (N6 + N16) / D4^2;

% Calculate the error using the formula
sigma_S = sqrt(sum(N_total .* (dS_dN .^ 2)));

% Display the Result
fprintf('Bell''s Inequality Error: sigma_S = %.4f\n', sigma_S);


