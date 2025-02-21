# Wavelet Event Analysis

## Overview
This repository contains the MATLAB code used to generate **Figure 2L** of the paper:

> *Title: The reuniens nucleus of the thalamus facilitates hippocampo-cortical dialogue during sleep*  
> Authors: Diellor Basha, Amirmohammad Azarmehri, Eliane Proulx, Sylvain Chauvette, Maryam Ghorbani, Igor Timofeev  
> Published in: eLife  
> DOI: [https://elifesciences.org/reviewed-preprints/90826](https://elifesciences.org/reviewed-preprints/90826)

The core function, `wavelet_event_analysis.m`, computes the wavelet transform of EEG data surrounding event onsets, averages the results across multiple trials, and visualizes the frequency-time representation.

![image](https://github.com/user-attachments/assets/5e9a38b2-79ae-489a-9f52-6ab1ae1d5902)

## Repository Structure
```
Wavelet-Event-Analysis/
│── README.md             # Documentation
│── wavelet_event_analysis.m # MATLAB function for wavelet analysis
│── example_script.m      # Example script demonstrating function usage
│── data/                 # Example EEG data (if applicable)
│── results/              # Output results and figures
```

## Requirements
This code is written in **MATLAB** and requires the **Wavelet Toolbox**. Ensure that you have the following dependencies:
- MATLAB R2021b or later (recommended)
- Signal Processing Toolbox
- Wavelet Toolbox

## Usage
### Running the Analysis
To perform wavelet analysis on EEG data, use the function:
```matlab
[out, res, frequencies] = wavelet_event_analysis(onsets, eeg, fs, downsampleFactor, freq_range, window_size);
```
**Inputs:**
- `onsets`: Vector of event times (in samples)
- `eeg`: 1D array of EEG signal
- `fs`: Sampling frequency (Hz)
- `downsampleFactor`: Factor to downsample the signal
- `freq_range`: Frequency range for analysis (Hz)
- `window_size`: Time window around each event (seconds)

### Example
An example script (`example_script.m`) is included to demonstrate function usage. Run:
```matlab

%% Load or Generate Example Data
fs = 1000; % Sampling frequency (Hz)
duration = 10; % Duration of simulated EEG signal (seconds)
t = 0:1/fs:duration-1/fs; % Time vector

% Simulated EEG signal: sum of sine waves + noise
eeg = sin(2*pi*10*t) + sin(2*pi*20*t) + randn(size(t))*0.5;

% Define event onsets (randomly placed within signal duration)
num_events = 20;
onsets = sort(randi([fs, length(t)-fs], 1, num_events));

%% Define Analysis Parameters
downsampleFactor = 2;
freq_range = [1 50]; % Frequency range (Hz)
window_size = 2; % Window size around each event (seconds)

%% Run Wavelet Event Analysis
[out, res, frequencies] = wavelet_event_analysis(onsets, eeg, fs, downsampleFactor, freq_range, window_size);

%% Plot the Results
figure;
imagesc(out);
set(gca, 'YScale', 'log');
colorbar;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('Wavelet Transform - Average Across Events');

```
This will load sample EEG data, process it, and generate the corresponding wavelet plot.

## Citation
If you use this code in your work, please cite the corresponding paper:
```
Diellor Basha, Amirmohammad Azarmehri,Eliane Proulx, Sylvain Chauvette, Maryam Ghorbani, Igor Timofeev
2023
The reuniens nucleus of the thalamus facilitates hippocampo-cortical dialogue during sleepeLife12:RP90826
https://doi.org/10.7554/eLife.90826.2
```

## License
This repository is distributed under the terms of the GNU General Public License
as published by the Free Software Foundation. Further details on the GPLv3
license can be found at https://opensource.org/license/gpl-3-0.

## Contact
For questions or issues, please contact **[Your Name]** at **[Your Email]** or open an issue in this repository.

