#!/bin/bash
# linear transform of point fcsv files
# pre-req: fmriprep output
#~/GitHub/afids-analysis/scripts/PHASE3_04_transform_fcsv_nlin.sh -i ~/graham/project/fid_study_bids/PHASE2/input_data/OAS1_bids_MR1/participants.tsv >& ~/GitHub/afids-analysis/logs/PHASE3_04_transform_fcsv_nlin.log

function usage {
 echo ""
 echo "Transform fcsv files"
 echo ""
 echo "Required args:"
 echo "  -i input_csv with subject names (e.g. sub-C020)"
 echo ""
}

if [ "$#" -lt 2 ]
then
 usage
 exit 1
fi

while getopts "i:" options; do
 case $options in
     i ) 
         in_csv=$OPTARG;;

    * ) usage
        exit 1;;
 esac
done

input_bids_dir=~/graham/project/fid_study_bids/PHASE2/input_data/OAS1_bids_MR1/derivatives/fmriprep_1.1.1/fmriprep_PHASE3/
input_fcsv_dir=~/GitHub/afids-analysis/data/PHASE2_output_afid_postQC/
output_dir=~/GitHub/afids-analysis/data/PHASE3_output_afid_lin/

mkdir -p $output_dir
{
  read # first line is a header
while read SUBJ; do
  echo "---------"
  echo $SUBJ
  echo "---------"

  input_xfm_to_MNI152=${input_bids_dir}/${SUBJ}/anat/${SUBJ}_T1w_target-MNI152NLin2009cAsym_lin.mat
  input_subj_id=`echo $SUBJ | cut -d "-" -f 2`
  input_fcsv=${input_fcsv_dir}/OAS1_${input_subj_id}_MR1_T1_MEAN.fcsv

  output_fcsv=${output_dir}/OAS1_${input_subj_id}_MR1_T1_MEAN_transformed_lin.fcsv

  echo python3 ~/graham/GitHub/sandbox/antsApplyLinearTransformToSlicerFCSV.py -i $input_fcsv -o $output_fcsv -a $input_xfm_to_MNI152
  python3 ~/GitHub/sandbox/antsApplyLinearTransformToSlicerFCSV.py -i $input_fcsv -o $output_fcsv -a $input_xfm_to_MNI152

done
} < "$in_csv"
