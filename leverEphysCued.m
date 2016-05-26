%% Script to analyse whole cell patch clamp data recorded during cued lever push task
% Script loads all traces recorded from an individual cell and analyses
% them in the context of the cued lever push task.

clear all
close all

%% Script determinants


%% Constants

sample_rate=10000;  % Sample rate (Hz)
sensor_th=2.5;      % Threshold for sensor state change
tone_th=2.5;        % Threshold for detecting tone
cycle_time=5;       % Minimum time for a complete lever action

%CHOOSE WHICH MOUSE/CELL TO ANALYSE

%LOAD META DATA

%% Analyse each trace for the mouse

for traceID = 1:numtraces
    
    filename=date.ABF{traceID};
    
    ABF = loadAbfDate(filename);
    
    trace_length = length(ABF);
    
    [ephys_trace, sensor_trigger_vec, sensor_reward_vec, reward_signal_vec, reset_signal_vec, tone_vec] = ...
        labelAbfWavesEphys(trainingsettings, ABF, mouseID, sensor_th, tone_th);
    
    %% Calculate behavioural statistics 
    
    [num_rewards, num_resets] = numRewardsResets(file_length,  reward_signal_vec, reset_signal_vec);
        
        [reward_pos, reward_time] = rewardStats(file_length, num_rewards, reward_signal_vec);
        
        if trainingdata.Tone_mode(dayID) == 2
            
            [reset_pos, reset_time]   = resetStats(file_length, num_resets, reset_signal_vec);
            
            [tone_start_time, tone_length, tone_pos, tone_success] = toneStats(file_length, tone_vec, tone_th, reward_pos);
            
            num_tones           = numel(tone_start_time);
            num_missed_tones    = num_tones - num_rewards;
            num_preemptive      = num_resets - num_missed_tones;
            
            [ missed_tone_reset_time, preemptive_episode_time, num_preemptive_episodes] = ...
                preemptiveStats(reset_time, tone_success, tone_start_time, num_missed_tones);
            
            
        end
    
    
end