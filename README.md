# Eye-Tracking-Parameters-Calculation

This repository contains Matlab and Python programming codes, as well as **obtained signal quality parameters and referent annotations for maternal QRS complexes** that reproduce results for the paper titled "From Raw Gaze to Meaningful Features: Assessment of Visual Behavior in Driving Simulator" authored by Smilja Stokanović (ORCiD: 0000-0003-0887-2615), Jaka Sodnik (ORCiD:  0000-0002-8915-9493), and Nadica Miljković (ORCiD: 0000-0002-3933-6076).  database.

## GitHub Repository Contents
This repository contains MATLAB and Python programming codes, as well as obtained signal quality parameters and referent annotations for maternal QRS complexes used for reproducing results presented in the paper titled "From Raw Gaze to Meaningful Features: Assessment of Visual Behavior in Driving Simulator". Also, this repository contains a README.md file with relevant information essential for code reproducibility and a LICENSE file that contains license information that covers shared software codes.

### Code
Shared programs are free software: you can redistribute them and/or modify them under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. These programs are distributed in the hope that they will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with these programs. If not, see https://www.gnu.org/licenses/.

Please, report any bugs to the Authors listed in the Contacts.
The repository is divided into four main folders and the repository contains the following code:

1) Saccades detection: <br>
  [central_der.m]() - MATLAB code for calculating the first derivative of a signal using the central difference method.<br>
  [IVT_algorithm.m]() - <br>
  [LoadTobiiData.m]() - <br>
  [parameterSearch.m]() - <br>
  [saccade_detection_function.m]() - MATLAB code for saccade detection and extraction of statistical features.<br>
  [parameterSearch.m]() - <br>
  [SubjectTimestamps.m]() - <br>
  
2) BCEA: <br>
   [BCEA.m]() -<br>
   [ellipseOverlap.m]() -<br>
   [mahalPts.m]() - <br>
   [sampen.m]() - <br>
   
3) Blink detection: <br>
   [BlinkDetection.m]() - <br>

4) Statistical analysis: <br>
   [SaccadeStatisticsFeatures1.ipynb]() - <br>
   [SaccadeStatisticsFeatures2.ipynb]() - <br>
   [BCEAStatisticsFeatures1.ipynb]() - <br>
   [BCEAStatisticsFeatures2.ipynb]() - <br>
   [BlinksStatisticFeatures1.ipynb]() - <br>
   [BlinksStatisticFeatures2.ipynb]() - <br>

5) [LICENSE file](https://github.com/smiljastokanovic/EyeTrackingParametersCalculation/blob/main/LICENSE) - containing GNU General Public License v3.0

 
### Data
Data provided in this repository are shared under Attribution 4.0 International (CC BY 4.0).



## Contacts
Smilja Stokanović (smiljastokanovic@gmail.com), Jaka Sodnik (jaka.sodnik@fe.uni-lj.si), or Nadica Miljković (e-mail: nadica.miljkovic@etf.bg.ac.rs).

## Funding
Nadica Miljković kindly acknowledges the support from the Grant No. 451-03-137/2025-03/2001 funded by the Ministry of Science, Technological Development, and Innovation of the Republic of Serbia.
This work has been financially supported also by the European Union’s Horizon Europe research and innovation program for the project FRODDO, grant agreement no. 101147819 and by the Slovenian Research and Innovation Agency within the program ICT4QL, grant no. P2-0246.

## How to cite this repository?
If you find provided code and signals useful for your own research and teaching class, please cite the following references:

Tanasković, I., & Miljković, N. (2023). A new algorithm for fetal heart rate detection: Fractional order calculus approach. Medical Engineering & Physics, 104007. https://doi.org/10.1016/j.medengphy.2023.104007 <br>
Tanasković, I., & Miljković, N. (2023). NadicaSm/Fetal-Heart-Rate-Detection: Software and Data for Fetal Heart Rate Detection (Version v1) [Software code and data] Zenodo. https://doi.org/10.5281/zenodo.7824902 <br>
