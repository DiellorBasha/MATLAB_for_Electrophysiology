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
example_script
```
This will load sample EEG data, process it, and generate the corresponding wavelet plot.

## Citation
If you use this code in your work, please cite the corresponding paper:
```
@article{YourPaper2025,
  author = {Author Name},
  title = {Paper Title},
  journal = {eLife},
  year = {2025},
  doi = {10.7554/eLife.XXXXXX}
}
```

## License
This repository is distributed under the **MIT License**. See `LICENSE` for details.

## Contact
For questions or issues, please contact **[Your Name]** at **[Your Email]** or open an issue in this repository.

