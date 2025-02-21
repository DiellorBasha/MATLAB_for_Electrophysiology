function [out, res, frequencies] = wavelet_event_analysis(onsets, eeg, fs, downsampleFactor, freq_range, window_size)
    % WAVELET_EVENT_ANALYSIS Computes the wavelet transform of EEG data
    % around event onsets and averages the results.
    %
    % INPUTS:
    %   onsets            - Vector of event times (in samples)
    %   eeg               - EEG signal (1D array)
    %   fs                - Sampling frequency of EEG signal (Hz)
    %   downsampleFactor  - Factor by which to downsample the EEG signal
    %   freq_range        - Frequency range for wavelet analysis (Hz)
    %   window_size       - Window size around each event (in seconds)
    %
    % OUTPUTS:
    %   out         - Mean wavelet transform magnitude across events
    %   res         - 3D matrix of wavelet transform results (freq x time x event)
    %   frequencies - Frequency vector corresponding to wavelet transform

    % @=============================================================================
        % This function is part of the custom functions library for Basha et al. 2023, 
        % eLife2025;12:RP90826 DOI: https://doi.org/10.7554/eLife.90826.3:
        % 
        % This code is distributed under the terms of the GNU General Public License
        % as published by the Free Software Foundation. Further details on the GPLv3
        % license can be found at https://opensource.org/license/gpl-3-0.
        %
        %
% =============================================================================@
%
% Authors: Diellor Basha, 2020-2023
    
    % Set default parameter values if not provided
    if nargin < 6
        window_size = 2; % Default: 2-second window around the event
    end
    if nargin < 5
        freq_range = [0 50]; % Default frequency range: 0 to 50 Hz
    end
    if nargin < 4
        downsampleFactor = 1; % No downsampling by default
    end
    if nargin < 3
        fs = 1000; % Default sampling rate: 1000 Hz
    end
    
    % Compute new sampling rate after downsampling
    newFs = fs / downsampleFactor;
    
    % Convert window size from seconds to samples
    window_size_in_samples = round(window_size * fs);
    downsampled_window_size_in_samples = round(window_size * newFs);
    
    % Create a continuous wavelet transform (CWT) filter bank
    fb = cwtfilterbank(SignalLength=downsampled_window_size_in_samples,...
            VoicesPerOctave=20, SamplingFrequency=newFs,...
            FrequencyLimits=[min(freq_range), max(freq_range)]);
        
    % Preallocate output matrix for downsampled spindle
    downsampled_spindle = zeros(length(onsets), window_size * newFs);
    
    % Loop through each onset event
    for k = 1:length(onsets)
        start_time = onsets(k) - window_size_in_samples / 2;
        end_time = onsets(k) + window_size_in_samples / 2;
        
        % Ensure window does not exceed the bounds of the EEG signal
        if start_time < 1 || end_time > length(eeg)
            continue;
        end
        
        % Extract and downsample the EEG segment around the event
        downsampled_spindle(k, :) = downsample(eeg(start_time:end_time-1), downsampleFactor);
    end
    
    % Remove empty rows where all values are zero (due to boundary issues)
    downsampled_spindle = downsampled_spindle(any(downsampled_spindle, 2), :);
    
    % Perform one wavelet transform to determine the output size
    cfs = cwt(downsampled_spindle(1, :), newFs, 'VoicesPerOctave', 20, 'FrequencyLimits', [min(freq_range), max(freq_range)]);
    res = zeros(size(cfs, 1), size(cfs, 2), size(downsampled_spindle, 1));
    
    % Compute the wavelet transform for each event and store results
    for j = 1:size(downsampled_spindle, 1)
        res(:, :, j) = wt(fb, downsampled_spindle(j, :));
    end
    
    % Compute the absolute magnitude of the wavelet coefficients
    res_abs = abs(res);
    
    % Compute the mean across all event-related wavelet transforms
    out = mean(res_abs, 3);
    
    % Generate time vector for plotting
    start_time = -window_size / 2;
    end_time = window_size / 2;
    n_samples = round(window_size * newFs);
    t_plot = linspace(start_time, end_time, n_samples);
    
    % Compute frequency vector for plotting (logarithmic scale if applicable)
    if freq_range(1) == 0
        frequencies = logspace(0, log10(freq_range(2)), size(res, 1));
    else
        frequencies = logspace(log10(freq_range(1)), log10(freq_range(2)), size(res, 1));
    end
    
    % Plot the results
    figure(2);
    imagesc('XData', t_plot, 'YData', frequencies, 'CData', flipud(out), 'CDataMapping', 'scaled');
    set(gca, 'YScale', 'log');
    
    xlim([min(t_plot), max(t_plot)]);
    ylim([min(freq_range), max(freq_range)]);
    xlabel('Time to event (s)');
    ylabel('Frequency (Hz)');
    title('Average Wavelet Transform');
    colorbar;
    
    end
    