# Eye-Tracking-Parameters-Calculation

This repository contains MATLAB and Python programming codes, as well as eye movement data in a driving simulator during three conditions: Baseline, Ride (simulated drive under normal visibility), and Fog (simulated drive under reduced visibility)that reproduce results for the paper titled "From Raw Gaze to Meaningful Features: Assessment of Visual Behavior in Driving Simulator" authored by Smilja Stokanović (ORCiD: 0000-0003-0887-2615), Jaka Sodnik (ORCiD:  0000-0002-8915-9493), and Nadica Miljković (ORCiD: 0000-0002-3933-6076).  database.

## GitHub Repository Contents
This repository contains MATLAB and Python programming codes, as well as obtained signal quality parameters and referent annotations for maternal QRS complexes used for reproducing results presented in the paper titled "From Raw Gaze to Meaningful Features: Assessment of Visual Behavior in Driving Simulator". Also, this repository contains a README.md file with relevant information essential for code reproducibility and a LICENSE file that contains license information that covers shared software codes.

### Code
Shared programs are free software: you can redistribute them and/or modify them under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. These programs are distributed in the hope that they will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with these programs. If not, see https://www.gnu.org/licenses/.

This repository contains the complete analysis pipeline for processing eye tracking data from a simulated driving study investigating oculometric changes across three conditions: Baseline, Ride, and Fog.

## Repository Structure
```
├── BCEA/
│   ├── BCEA_BaselineScript.m
│   ├── BCEA_FogScript.m
│   ├── BCEA_RideScript.m
│   ├── mahalPts.m
│   └── sampen.m
├── Blink Detection/
│   └── BlinkDetection.m
├── DataBase/
├── Saccade Detection/
│   ├── BaselineScript.m
│   ├── FogScript.py
│   ├── IVT_algorithm.m
│   ├── RideScript.m
│   ├── central_der.m
│   ├── parameterSearch.m
│   └── saccade_detection_function.m
├── Statistical Analysis/
├── CITATION.cff/
├── LICENSE/
├── README.md/
└── SubjectTimestamps.m
```

Please, report any bugs to the Authors listed in the Contacts.
The repository is divided into four main folders and the repository contains the following code:
1) Database - contains a README.md file with a link to the Zenodo page containing the used eye tracking dataset
2) Saccades detection: <br>
  [BaselineScript.m](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/Saccade%20Detection/BaselineScript.m) - Script for saccade detection and parameter calculation for the Baseline segment.<br>
  [FogScript.m](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/Saccade%20Detection/FogScript.m) - Script for saccade detection and parameter calculation for the Fog segment. <br>
  [IVT_algorithm.m](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/Saccade%20Detection/IVT_algorithm.m) - MATLAB function for the I-VT (Identification by Velocity Threshold) algorithm with adaptive threshold. <br>
  [RideScript.m](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/Saccade%20Detection/RideScript.m) - Script for saccade detection and parameter calculation for the Ride segment.
  [central_der.m](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/Saccade%20Detection/central_der.m) - MATLAB code for calculating the first derivative of a signal using the central difference method.<br>
  [parameterSearch.m](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/Saccade%20Detection/parameterSearch.m) - MATLAB function for optimizing parameter for I-VT algorithm.<br>
  [saccade_detection_function.m](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/Saccade%20Detection/saccade_detection_function.m) - MATLAB code for saccade detection and extraction of statistical features.<br>

4) BCEA: <br>
   [BCEA.m](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/BCEA/BCEA.m) - MATLAB script for calculation of Bivariate Contour Ellipse Area (BCEA) parameters and visualization. <br>
   [ellipseOverlap.m](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/BCEA/ellipseOverlap.m) - MATLAB function for calculation area of ellipse1 overlapped by ellipse2. <br>
   [mahalPts.m](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/BCEA/mahalPts.m) -  mahalPts computes the squared Mahalanobis distance between points and a multivariate Gaussian distribution defined by mean (mu) and covariance (S). The Mahalanobis distance accounts for covariance structure and scaling of the data, unlike Euclidean distance<br>
   [sampen.m](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/BCEA/sampen.m) - Sample Entropy (SampEn) quantifies signal irregularity and complexity by estimating the probability that similar patterns of length m remain similar when extended to length m+1. <br>
   
5) Blink detection: <br>
   [BlinkDetection.m](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/Blink%20detection/BlinkDetection.m) - MATLAB script for calculation of blink parameters and visualization. <br>

6) Statistical analysis: <br>
   [BCEAStatisticsFeatures1.ipynb](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/Statistical%20Analysis/BCEAStatisticsFeatures.ipynb) - Python code for calculating central tendency statistics, box plots, and correlation matrices for BCEA parameters.<br>
   [BCEAStatisticsFeatures2.ipynb](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/Statistical%20Analysis/BCEAStatisticsFeatures2.ipynb) - Python code for the BCEA parameters post-hoc statistical analysis. <br>
   [BlinksStatisticFeatures1.ipynb](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/Statistical%20Analysis/BlinksStatisticsFeatures.ipynb) - Python code for calculating central tendency statistics, box plots, and correlation matrices for blink parameters. <br>
   [BlinksStatisticFeatures2.ipynb](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/Statistical%20Analysis/BlinksStatisticsFeatures2.ipynb) - Python code for blink parameters post-hoc statistical analysis. <br>
   [SaccadeStatisticsFeatures1.ipynb](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/Statistical%20Analysis/SaccStatisticsFeatures.ipynb) - Python code for calculation of central tendency statistics, boxplots, and correlation matrices for saccade detection parameters. <br>
   [SaccadeStatisticsFeatures2.ipynb](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/Statistical%20Analysis/SaccStatisticsFeatures2.ipynb) - Python code for saccade parameters post-hoc statistical analysis. <br>

7) [LICENSE file](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/LICENSE) - containing GNU General Public License v3.0

8) [SubjectTimestamps.m](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/SubjectTimestamps.m) - MATLAB script for the Baseline, Ride, and Fog Timestamps. This script should be used for saccade detection, BCEA, and blink detection.
 
### Data
Data provided in this repository are shared under Attribution 4.0 International (CC BY 4.0).

### Acknowledgements / Third-Party Code

This repository uses the following third-party MATLAB function:

Sample Entropy (SampEn)
Author: Víctor Martínez-Cagigal
Source: MATLAB Central File Exchange
URL: [https://www.mathworks.com/matlabcentral/fileexchange/124326-sampen](https://www.mathworks.com/matlabcentral/fileexchange/69381-sample-entropy)
Accessed: February 2026

## Contacts
Smilja Stokanović (smiljastokanovic@gmail.com)
## Funding
Nadica Miljković kindly acknowledges the support from the Grant No. 451-03-137/2025-03/2001 funded by the Ministry of Science, Technological Development, and Innovation of the Republic of Serbia.
This work has been financially supported also by the European Union’s Horizon Europe research and innovation program for the project FRODDO, grant agreement no. 101147819 and by the Slovenian Research and Innovation Agency within the program ICT4QL, grant no. P2-0246.

## Disclaimer
The MATLAB code is provided without any guarantee and it is not intended for medical purposes.

## How to cite this repository?
If you find provided code and signals useful for your own research and teaching class, please cite the following references:

Stokanović, S., Sodnik, J., and Miljković, N., "From Raw Gaze to Meaningful Features: Assessment of Visual Behavior in Driving Simulator." ArXiv, 2025, https://doi.org/10.48550/arXiv.2511.02689.<br>
Stokanović, S., Sodnik, J., and Miljković, N., 2026. EyeTrackingParametersCalculation: Software and Data for From Raw Gaze to Meaningful Features: Assessment of Visual Behavior in Driving Simulator [Data set]. Zenodo, https://doi.org/10.5281/zenodo.18660836.
