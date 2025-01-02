% Process 16 Videos for Alice and Bob
% -----------------------------------

% Initialize Blank Lists for Alice and Bob
AliceTotal = [];
BobTotal = [];   

% --- Loop to Process 16 Video Files ---
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
        AliceFrames(i) = sum(sum(frame(116:205, 931:1096, 1)));  % Alice (Red channel)
        BobFrames(i) = sum(sum(frame(508:594, 954:1135, 1)));    % Bob (Red channel)
    end
    
   
    
    % --- Append to Total Lists ---
    AliceTotal = [AliceTotal, AliceFrames];
    BobTotal = [BobTotal, BobFrames];
    
end


% Plot Alice and Bob on the Same Graph
% -------------------------------
figure;
plot(AliceTotal, 'Color', [1, 0.5, 0], 'LineWidth', 1.5);  % Orange for Alice
hold on;
plot(BobTotal, 'Color', [0, 0.45, 0.75], 'LineWidth', 1.5); % Blue for Bob
xlabel('Frame Number');
ylabel('Intensity [AU]');
title('Alice and Bob: Intensity vs Frame');
legend('Alice Total', 'Bob Total');
grid on;
hold off;