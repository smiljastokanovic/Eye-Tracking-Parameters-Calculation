# Eye-Tracking-Parameters-Calculation

This repository contains MATLAB and Python programming codes, as well as eye movement data in a driving simulator during three conditions: Baseline, Ride (simulated drive under normal visibility), and Fog (simulated drive under reduced visibility)that reproduce results for the paper titled "From Raw Gaze to Meaningful Features: Assessment of Visual Behavior in Driving Simulator" authored by Smilja Stokanović (ORCiD: 0000-0003-0887-2615), Jaka Sodnik (ORCiD:  0000-0002-8915-9493), and Nadica Miljković (ORCiD: 0000-0002-3933-6076).  database.

## GitHub Repository Contents
This repository contains MATLAB and Python programming codes, as well as obtained signal quality parameters and referent annotations for maternal QRS complexes used for reproducing results presented in the paper titled "From Raw Gaze to Meaningful Features: Assessment of Visual Behavior in Driving Simulator". Also, this repository contains a README.md file with relevant information essential for code reproducibility and a LICENSE file that contains license information that covers shared software codes.

### Code
Shared programs are free software: you can redistribute them and/or modify them under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. These programs are distributed in the hope that they will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with these programs. If not, see https://www.gnu.org/licenses/.

Please, report any bugs to the Authors listed in the Contacts.
The repository is divided into four main folders and the repository contains the following code:

1) Saccades detection: <br>
  [central_der.m](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/Saccade%20Detection/central_der.m) - MATLAB code for calculating the first derivative of a signal using the central difference method.<br>
  [IVT_algorithm.m](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/Saccade%20Detection/IVT_algorithm.m) - MATLAB function for the I-VT (Identification by Velocity Threshold) algorithm with adaptive threshold. <br>
  [LoadTobiiData.m](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/Saccade%20Detection/LoadTobiiDataBaseline.m) - MATLAB script for velocity calculation and visualization of saccade parameters<br>
  [parameterSearch.m](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/Saccade%20Detection/parameterSearch.m) - MATLAB function for optimizing parameter for I-VT algorithm.<br>
  [saccade_detection_function.m]() - MATLAB code for saccade detection and extraction of statistical features.<br>

2) BCEA: <br>
   [BCEA.m](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/BCEA/BCEA.m) - MATLAB script for calculation of Bivariate Contour Ellipse Area (BCEA) parameters and visualization. <br>
   [ellipseOverlap.m](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/BCEA/ellipseOverlap.m) - MATLAB function for calculation area of ellipse1 overlapped by ellipse2. <br>
   [mahalPts.m]() - <br>
   [sampen.m]() - <br>
   
3) Blink detection: <br>
   [BlinkDetection.m](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/Blink%20detection/BlinkDetection.m) - MATLAB script for calculation of blink parameters and visualization. <br>

4) Statistical analysis: <br>
   [SaccadeStatisticsFeatures1.ipynb](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/Statistical%20Analysis/SaccStatisticsFeatures.ipynb) - Python code for calculation of central tendency statistics, boxplots, and correlation matrices for saccade detection parameters. <br>
   [SaccadeStatisticsFeatures2.ipynb](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/Statistical%20Analysis/SaccStatisticsFeatures2.ipynb) - Python code for saccade parameters post-hoc statistical analysis. <br>
   [BCEAStatisticsFeatures1.ipynb](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/Statistical%20Analysis/BCEAStatisticsFeatures.ipynb) - Python code for calculating central tendency statistics, box plots, and correlation matrices for BCEA parameters.<br>
   [BCEAStatisticsFeatures2.ipynb](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/Statistical%20Analysis/BCEAStatisticsFeatures2.ipynb) - Python code for the BCEA parameters post-hoc statistical analysis. <br>
   [BlinksStatisticFeatures1.ipynb](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/Statistical%20Analysis/BlinksStatisticsFeatures.ipynb) - Python code for calculating central tendency statistics, box plots, and correlation matrices for blink parameters. <br>
   [BlinksStatisticFeatures2.ipynb](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/Statistical%20Analysis/BlinksStatisticsFeatures2.ipynb) - Python code for blink parameters post-hoc statistical analysis. <br>

5) [LICENSE file](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/LICENSE) - containing GNU General Public License v3.0
6) SubjectTimestamps.m - MATLAB script for the Baseline, Ride, and Fog Timestamps. This script should be used for saccade detection, BCEA, and blink detection.
 
### Data
Data provided in this repository are shared under Attribution 4.0 International (CC BY 4.0).


## Contacts
Smilja Stokanović (smiljastokanovic@gmail.com)
## Funding
Nadica Miljković kindly acknowledges the support from the Grant No. 451-03-137/2025-03/2001 funded by the Ministry of Science, Technological Development, and Innovation of the Republic of Serbia.
This work has been financially supported also by the European Union’s Horizon Europe research and innovation program for the project FRODDO, grant agreement no. 101147819 and by the Slovenian Research and Innovation Agency within the program ICT4QL, grant no. P2-0246.

## How to cite this repository?
If you find provided code and signals useful for your own research and teaching class, please cite the following references:

Stokanović S., Sodnik J., Miljković N. (2025). From Raw Gaze to Meaningful Features: Assessment of Visual Behavior in Driving Simulator. ArXiv, https://doi.org/10.48550/arXiv.2511.02689 <br>
Stokanović S., Sodnik J., Miljković N. (2026). /smiljastokanovic/EyeTrackingParametersCalculation: Software and Data for  From Raw Gaze to Meaningful Features: Assessment of Visual Behavior in Driving Simulator (Version v1) [Software code and data] Zenodo. https://doi.org/ <br>
