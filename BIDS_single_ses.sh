#!/bin/bash

set -e

# setting your dataset path here
homedir=~/Desktop/BIDS_test

dcmdir=${homedir}/Dicom
niidir=${homedir}/Nifti

if [ -d ${niidir} ];then
	rm -r ${niidir}
fi

mkdir ${niidir}


jo -p "Name"="KCL Multi-site schizophrenia dataset - Graph Convolutional Network" "BIDSVersion"="1.0.2" >> ${niidir}/dataset_description.json

if [ -d ${dcmdir}/anat ];then
	for subj in `ls ${dcmdir}/anat/`
		do
		echo "processing anatomical images of $subj"
		mkdir -p ${niidir}/sub-${subj}/anat
		dcm2niix -z n -b y -o ${niidir}/sub-${subj}/anat -f ${subj}_%f_%p ${dcmdir}/anat/${subj}
		cd ${niidir}/sub-${subj}/anat
		mv *.json sub-${subj}_T1w.json
		mv *.nii sub-${subj}_T1w.nii
		done
fi

if [ -d ${dcmdir}/dwi ];then
	for subj in `ls ${dcmdir}/dwi/`
		do
		echo "processing diffusion images of $subj"
		mkdir -p ${niidir}/sub-${subj}/dwi
		dcm2niix -z n -b y -o ${niidir}/sub-${subj}/dwi -f ${subj}_%f_%p ${dcmdir}/dwi/${subj}
		cd ${niidir}/sub-${subj}/dwi
		mv *.json sub-${subj}_dwi.json
		mv *.nii sub-${subj}_dwi.nii
		mv *.bval sub-${subj}_dwi.bval
		mv *.bvec sub-${subj}_dwi.bvec
		done
fi

if [ -d ${dcmdir}/rest ];then 
	for subj in `ls ${dcmdir}/rest/`
		do
		echo "processing resting-state functional images of $subj"
		mkdir -p ${niidir}/sub-${subj}/func
		dcm2niix -z n -b y -o ${niidir}/sub-${subj}/func -f ${subj}_%f_%p ${dcmdir}/rest/${subj}
		cd ${niidir}/sub-${subj}/func
		mv *.json sub-${subj}_task-rest_bold.json
		mv *.nii sub-${subj}_task-rest_bold.nii
		for funcjson in `ls *.json`
			do
			taskexist=`cat ${funcjson} | jq '.TaskName'`
			if [ "$taskexist" == "null" ]; then
				taskfield=$(echo $jsonname | cut -d '_' -f2 | cut -d '-' -f2)
				jq '. |= . + {"TaskName":"'${taskfield}'"}' ${funcjson} > tasknameadd.json
				rm ${funcjson}
				mv tasknameadd.json ${funcjson}
				echo "TaskName was added to ${jsonname} and matches the tasklabel in the filename"
			else
				Taskquotevalue=$(jq '.TaskName' ${funcjson})
				Taskvalue=$(echo $Taskquotevalue | cut -d '"' -f2)	
				jsonname="${funcjson%.*}"
				taskfield=$(echo $jsonname | cut -d '_' -f2 | cut -d '-' -f2)
				if [ $Taskvalue == $taskfield ]; then
					echo "TaskName is present and matches the tasklabel in the filename"
				else
					echo "TaskName and tasklabel do not match"
				fi
			fi
			done
		done
fi





