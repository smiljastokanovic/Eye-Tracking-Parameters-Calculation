# Eye-Tracking-Parameters-Calculation

This repository contains Matlab and Python programming codes, as well as **obtained signal quality parameters and referent annotations for maternal QRS complexes** that reproduce results for the paper titled "From Raw Gaze to Meaningful Features: Assessment of Visual Behavior in Driving Simulator" authored by Smilja Stokanović (ORCiD: 0000-0003-0887-2615), Jaka Sodnik (ORCiD:  0000-0002-8915-9493), and Nadica Miljković (ORCiD: 0000-0002-3933-6076).  database.

# GitHub Repository Contents
This repository contains MATLAB and Python programming codes, as well as obtained signal quality parameters and referent annotations for maternal QRS complexes used for reproducing results presented in the paper titled "From Raw Gaze to Meaningful Features: Assessment of Visual Behavior in Driving Simulator". Also, this repository contains a README.md file with relevant information essential for code reproducibility and a LICENSE file that contains license information that covers shared software codes.

# Code
Shared programs are free software: you can redistribute them and/or modify them under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. These programs are distributed in the hope that they will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with these programs. If not, see https://www.gnu.org/licenses/.

Please, report any bugs to the Authors listed in the Contacts.

The repository contains the following code:
 Saccades detection:
  central_der.m - MATLAB code for calculating the first derivative of a signal using the central difference method.
  IVT_algorithm.m - 
  LoadTobiiData.m - 
  parameterSearch.m - 
  saccade_detection_function.m - MATLAB code for saccade detection and extraction of statistical features.
  parameterSearch.m - 
  SubjectTimestamps.m - 
  
 BCEA:
   BCEA.m -
   ellipseOverlap.m -
   mahalPts.m - 
   sampen.m - 
   
 Blink detection:
   BlinkDetection.m

 Statistical analysis:
   SaccadeStatisticsFeatures1.ipynb
   SaccadeStatisticsFeatures2.ipynb
   BCEAStatisticsFeatures1.ipynb
   BCEAStatisticsFeatures2.ipynb
   BlinksStatisticFeatures1.ipynb
   BlinksStatisticFeatures2.ipynb

 
# Data
Data provided in this repository are shared under Attribution 4.0 International (CC BY 4.0).

signal quality parameters for statistical test.csv - table with signal quality parameters before and after maternal QRS cancellation with the following columns:
1.1. snr_pre is signal to noise ratio calculated using SNR_time_domain.m before maternal QRS cancellation.
1.2. snr_post is signal to noise ratio calculated using SNR_time_domain.m after maternal QRS cancellation.
1.3. xSQI_pre is extravagance of fetal QRS complex calculated using xSQI_calc.m - a Matlab software code that estimates extravagance of fetal QRS peak (parameter used for signal quality assessment) before maternal QRS cancellation.
1.4. xSQI_post is extravagance of fetal QRS complex calculated using xSQI_calc.m - a Matlab software code that estimates extravagance of fetal QRS peak (parameter used for signal quality assessment) after maternal QRS cancellation.
1.5. fQRS_to_mQRS_pre is the mean amplitude ratio between fetal QRS complexes and maternal QRS complexes before mQRS cancellation.
1.6. fQRS_to_mQRS_post is the mean amplitude ratio between fetal QRS complexes and maternal QRS complexes after mQRS cancellation.
maternal QRS annotations - folder with .csv tables with annotations of maternal QRS complexes performed on signals in files a01, a02, ..., a25 from the initial Set A from PhysioNet database "Noninvasive Fetal ECG: The PhysioNet/Computing in Cardiology Challenge 2013" (CinC). The annotations are saved in form of samples with sampling frequency 1000 Hz. References for this database are:
2.1. Goldberger, A. L., Amaral, L. A., Glass, L., Hausdorff, J. M., Ivanov, P. C., Mark, R. G., ... & Stanley, H. E. (2000). PhysioBank, PhysioToolkit, and PhysioNet: components of a new research resource for complex physiologic signals. circulation, 101(23), e215-e220. https://doi.org/10.1161/01.CIR.101.23.e215
2.2. Silva, I., Behar, J., Sameni, R., Zhu, T., Oster, J., Clifford, G. D., & Moody, G. B. (2013, September). Noninvasive fetal ECG: the PhysioNet/computing in cardiology challenge 2013. In Computing in cardiology 2013 (pp. 149-152). IEEE.

# Contacts
Smilja Stokanović (smiljastokanovic@gmail.com), Jaka Sodnik (jaka.sodnik@fe.uni-lj.si), or Nadica Miljković (e-mail: nadica.miljkovic@etf.bg.ac.rs).

# Funding
Nadica Miljković kindly acknowledges the support from the Grant No. 451-03-137/2025-03/2001 funded by the Ministry of Science, Technological Development, and Innovation of the Republic of Serbia.
This work has been financially supported also by the European Union’s Horizon Europe research and innovation program for the project FRODDO, grant agreement no. 101147819 and by the Slovenian Research and Innovation Agency within the program ICT4QL, grant no. P2-0246.

# How to cite this repository?
If you find provided code and signals useful for your own research and teaching class, please cite the following references:

Tanasković, I., & Miljković, N. (2023). A new algorithm for fetal heart rate detection: Fractional order calculus approach. Medical Engineering & Physics, 104007. https://doi.org/10.1016/j.medengphy.2023.104007
Tanasković, I., & Miljković, N. (2023). NadicaSm/Fetal-Heart-Rate-Detection: Software and Data for Fetal Heart Rate Detection (Version v1) [Software code and data] Zenodo. https://doi.org/10.5281/zenodo.7824902
