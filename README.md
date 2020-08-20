# BIDS-Auto-Organization

Automatical organization bash script for your MRI images into BIDS format, temporarily available for T1, dwi and restfmri single session modalities.

## Raw DICOM file structure

Dataset_single_ses/
  Dicom/
    anat/
      001/
      002/
      ...
    dwi/
      001/
      002/
      ...
    rest/
      001/
      002/
      ...

## dependencies

The bash script requires dcm2niix and jo to be installed.
