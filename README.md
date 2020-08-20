# BIDS-Auto-Organization

Automatical organization bash script for your MRI images into BIDS format, temporarily available for T1, dwi and restfmri single session modalities.

## Raw DICOM file structure

* Dataset/<br>
  * Dicom/<br>
    * anat/<br>
      * 001/<br>
      * 002/<br> 
      * ...
    * dwi/<br>
      * 001/<br>
      * 002/<br>
      * ...<br>
    * rest/<br>
      * 001/<br>
      * 002/<br>
      * ...<br>

## dependencies

The bash script requires dcm2niix and jo to be installed.
