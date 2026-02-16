#Open-access Eye tracking Database

Signals from the eye tracker used in this paper are freely available at the Zenodo repository DOI: [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.18660836.svg)](https://doi.org/10.5281/zenodo.18660836)

.

## Description
The database consists of E eye tracking signals from the Tobii Pro Glasses 3 eye tracker. The study was conducted in a simulated driving environment using a motion-based driving simulator. The database contains signals from 26 healthy individuals. The task included Baseline, driving under normal conditions (Ride), and driving during fog (Fog). Sample rate is set at fs = 100 Hz and the resolution is 1920 x 1080 pixels.

## Naming convention
subject'sID_gazedata_output.txt

An example:

2003_01_gazedata_output.txt (subject ID 2003_01)

## Dataset Format

The data is stored in **txt files**. Each row corresponds to a timestamped measurement.  

### Columns

| Column Name            | Description |
|------------------------|-------------|
| `timestamp`            | Time of recording (seconds) |
| `gaze2d_x`, `gaze2d_y` | 2D gaze coordinates on the screen (normalized units) |
| `gaze3d_x`, `gaze3d_y`, `gaze3d_z` | 3D gaze coordinates in space (scene coordinates) |
| `eyeleft_origin_x`, `eyeleft_origin_y`, `eyeleft_origin_z` | 3D position of the left eye origin |
| `eyeleft_dir_x`, `eyeleft_dir_y`, `eyeleft_dir_z` | 3D gaze direction vector of the left eye |
| `pupil_left`           | Pupil diameter of the left eye |
| `eyeright_origin_x`, `eyeright_origin_y`, `eyeright_origin_z` | 3D position of the right eye origin |
| `eyeright_dir_x`, `eyeright_dir_y`, `eyeright_dir_z` | 3D gaze direction vector of the right eye |
| `pupil_right`          | Pupil diameter of the right eye |

If you find these signals useful for your own research, please cite the relevant papers and dataset as:

Stokanović, S., Sodnik, J., and Miljković, N., "From Raw Gaze to Meaningful Features: Assessment of Visual Behavior in Driving Simulator." ArXiv, 2025, https://doi.org/10.48550/arXiv.2511.02689.<br>
Stokanović, S., Sodnik, J., and Miljković, N., 2026. EyeTrackingParametersCalculation: Software and Data for From Raw Gaze to Meaningful Features: Assessment of Visual Behavior in Driving Simulator [Data set]. Zenodo, https://doi.org/10.5281/zenodo.18660836.
