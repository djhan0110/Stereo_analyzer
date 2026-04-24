# Stereo_analyzer
ImageJ macro for automated colony formation assay analysis for stereomicroscopy

### Automated Stereomicroscopy Colony Assay Analysis Macro

**ColonyStream-Fiji** is an automated ImageJ/Fiji macro designed to streamline the quantification of colony formation assays. It processes stereomicroscopic images through automated binarization, interactive ROI (Region of Interest) designation, and high-throughput area quantification.

## Key Features
- **Persistent ROI**: Define the well boundary once on the first image; the macro applies the exact coordinates to all subsequent images for statistical consistency.
- **Automated Segmentation**: Utilizes `RenyiEntropy` thresholding and `Subtract Background` to isolate colonies from the extracellular matrix (e.g., Matrigel) noise.
- **Area-Restricted Quantification**: Strictly quantifies only the area within the designated ROI, preventing edge artifacts or external black backgrounds from skewing results.
- **Color-Coded Visualization**: Generates "Count Masks" where individual particles are color-indexed for easy visual verification.

## Workflow Overview
1. **Directory Initialization**: Upon execution, the macro prompts the user to define the Source Directory (input images) and the Destination Directory (output data/masks).
2. **Preprocessing**: Converts images to 8-bit, subtracts background noise, and enhances contrast.
3. **Interactive Selection**: Pauses at the first image to allow the user to adjust a high-contrast ROI (Oval) to fit the well boundary.
4. **Binarization**: Applies an automated threshold to create a binary mask.
5. **Signal Correction**: Automatically verifies and inverts signal polarity to ensure colonies are treated as foreground (White/255).
6. **Particle Analysis**: Quantifies colony area, area fraction, and counts based on user-defined size filters.

## Installation & Usage
1. Open **Fiji (ImageJ)**.
2. Drag and drop the `.ijm` script into the Fiji main window.
3. Click **Run**.
4. Select the **Source Directory** (containing your `.tif`, `.png`, or `.jpg` images).
5. Select the **Destination Directory** (where masks and CSV results will be saved).
6. **Important**: When the first image appears, adjust the oval ROI to fit your well and click **OK** in the dialog box.

## Requirements
- **Software**: Fiji (Is Just ImageJ)
- **Input**: 2D stereomicroscopic images.
- **Configuration**: Ensure your images have consistent scaling if absolute area (e.g., mm²) is required.

## Data Output
- **Final_Mask_[Filename].png**: A color-indexed mask showing detected colonies.
- **Summary_Results.csv**: A consolidated spreadsheet containing:
    - Total Area
    - Area Fraction (%)
    - Average Size
    - Colony Count

## License
This project is licensed under the **Apache License 2.0** - see the LICENSE file for details.

## Author
**Dongjun Han, Ph.D.**
Senior Scientist | Disease Modeling Team Leader
Rznomics Inc., South Korea.

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Profile-blue?style=flat-square&logo=linkedin)](https://www.linkedin.com/in/dongjun-han-19a17889/)
[![Email](https://img.shields.io/badge/Email-Contact-green?style=flat-square&logo=gmail)](mailto:djhan0110@gmail.com)

