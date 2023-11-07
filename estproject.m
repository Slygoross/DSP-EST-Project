% Simulated ultrasonic sensor data with increased noise
sampleRate = 1000;  % Sample rate in Hz
t = (0:1/sampleRate:10)';  % Time vector (simulation period: 10 seconds)

% Simulate fluid flow in an open channel
channelLength = 50;  % Length of the channel in meters
flowSpeed = 1;  % Average flow speed in m/s
initialWaterLevel = 0.5;  % Initial water level in meters
waterLevel = initialWaterLevel + flowSpeed * t;  % Simulated water level (linear increase)

% Add more noise to the water level measurements
noiseAmplitude = 0.1;  % Increased noise level
noisyWaterLevel = waterLevel + noiseAmplitude * randn(size(t));  % Noisy water level

% Design an IIR filter (example: Butterworth low-pass filter)
order = 4;  % Filter order
cutOffFrequency = 2;  % Adjust based on the expected dynamics of the water flow
[b, a] = butter(order, cutOffFrequency / (sampleRate / 2), 'low');  % Design the filter

% Create a figure for real-time visualization
hFig = figure;
subplot(2, 1, 1);
hTrueWaterLevel = plot(t, waterLevel, 'g', 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Water Level (m)');
title('True Water Level');

subplot(2, 1, 2);
hNoisyWaterLevel = plot(t, noisyWaterLevel, 'b', 'LineWidth', 1);
hold on;
hFilteredWaterLevel = plot(t, noisyWaterLevel, 'r', 'LineWidth', 1);
hold off;
xlabel('Time (s)');
ylabel('Water Level (m)');
legend('Noisy Water Level', 'Filtered Water Level');
title('Noisy and Filtered Water Level');

% Main loop for real-time processing
for i = 2:length(t)
    % Simulate the water flow in the channel
    waterLevel(i) = initialWaterLevel + flowSpeed * t(i);
    
    % Update the noisy water level with new simulated data
    noisyWaterLevel(i) = waterLevel(i) + noiseAmplitude * randn(1, 1);
    
    % Apply the IIR filter to reduce noise in real-time
    filteredWaterLevel = filtfilt(b, a, noisyWaterLevel);
    
    % Update the plots with the latest data
    set(hTrueWaterLevel, 'YData', waterLevel);
    set(hNoisyWaterLevel, 'YData', noisyWaterLevel);
    set(hFilteredWaterLevel, 'YData', filteredWaterLevel);
    
    % Pause for real-time effect (adjust as needed)
    pause(0.01);
    
    % Refresh the plots
    drawnow;
end
