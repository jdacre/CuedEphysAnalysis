function [ephys_trace, sensor_trigger_vec, sensor_reward_vec, reward_signal_vec, reset_signal_vec, tone_vec] = ...
    labelAbfWavesEphys(trainingsettings, ABF, mouseID, sensor_th, tone_th)
% labelAbfWaves appropriately labels waves of the ABF file depending on the
% training protocol settings

ephys_trace = ABF(:,1);

if trainingsettings.rewardpos{mouseID}=='F'
    protocol=1;            % Rewarded at Front
else protocol=0;           % Rewarded at Back
end

% Rename columns of data appropriately
if protocol==1
    sensor_trigger=ABF(:,2);
    sensor_reward=ABF(:,3);
else
    sensor_trigger=ABF(:,3);
    sensor_reward=ABF(:,2);
end
signal_reward=ABF(:,4);
signal_reset=ABF(:,5);
signal_tone=ABF(:,6);

sensor_trigger_vec = (sensor_trigger>sensor_th);  % Time points at which trigger sensor is  HIGH
sensor_reward_vec  = (sensor_reward>sensor_th);   % Time points at which reward sensor is   HIGH
reward_signal_vec  = (signal_reward>sensor_th);   % Time points at which reward signal is   HIGH
reset_signal_vec   = (signal_reset>sensor_th);    % Time points at which reset signal is    HIGH
tone_vec           = (abs(signal_tone)>tone_th);  % Time points at which tone is            ON


end

