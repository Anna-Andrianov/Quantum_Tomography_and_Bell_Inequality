%v= VideoReader('D:\Programs in D\Matlab projects Q tomography\VideoFirstPart\50Bits.mp4');

% --- Select Video File Using Dialog ---
[file, path] = uigetfile({'*.mp4;*.avi;*.mov', 'Video Files (*.mp4, *.avi, *.mov)'}, 'Select a Video File');
if isequal(file, 0)
    disp('No video selected. Exiting...');
    return;
end

% --- Load Video ---
full_path = fullfile(path, file);
v = VideoReader(full_path);
disp(['Processing video: ', full_path]); %for debbugind<=>we choosed the correct video


totalFrames = v.NumFrames;          % Get total number of frames
D2 = zeros(1, totalFrames);         % Preallocate D2 for efficiency

for i = 1:totalFrames
    frame = read(v, i);
    D2(i) = sum(sum(frame(508:597, 954:1135, 1)));
    disp(['Processing frame ', num2str(i), ' of ', num2str(totalFrames)]);
end

% Plot the results
plot(D2);
title('Summed Intensity Over All Frames');
xlabel('Frame Number');
ylabel('Summed Intensity');


pks = [];
locs = [];

%min_distance = 10;  % Minimum distance between peaks (in frames) %step1

for i = 2:length(D2)-1
    if D2(i) >= D2(i-1) && D2(i) >= D2(i+1) && D2(i) > 4e4 % Adjust threshold here
        pks = [pks, D2(i)];
        locs = [locs, i];
       
    end
end
plot(D2);
hold on;
plot(locs, pks, 'ro', 'MarkerSize', 8, 'LineWidth', 2);  % Mark peaks
hold off;

%title('Summed Pixel Intensity Over All Frames - 10 Bits - Alice |H>', 'FontSize', 12, 'FontWeight', 'bold');
title('Summed Pixel Intensity Over All Frames - 50 Bits - Bob |H>', ...
      'FontSize', 13, 'FontWeight', 'bold', 'Interpreter', 'none', ...
      'Units', 'normalized', 'Position', [0.5, 1.05, 0]);
set(gca, 'Position', [0.13, 0.15, 0.775, 0.7]);  % Shrink the plot to create space
xlabel('Frame Number', 'FontSize', 12);
ylabel('Summed Pixel Intensity', 'FontSize', 12);
legend('Summed Intensity', 'Detected Peaks');
peak_values = pks;  % Contains the intensity values at peaks
peak_frames = locs;  % Frame numbers where peaks occurred
csvwrite('peak_values.csv', [peak_frames' pks']);




