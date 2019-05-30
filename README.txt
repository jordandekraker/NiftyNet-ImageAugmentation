HCP: 19 hippocampi
agile12: 24 hippocampi
UPenn: 26 hippocampi

1) import data (to multisite_cropped/):
regularInteractive
bash import_trainingdata.sh

2) run all ANTs registrations: (spawns many jobs!)
regularSubmit -j Skinny matlab -nosplash -nodisplay -nojvm -r "'ANTsReg_allcross; exit'"

3) propogate ANTsregistrations:
regularSubmit matlab -nosplash -nodisplay -r "'ANTsProp_3lbl; exit'"
NOTE: if this doesn't complete then corrupted files will have to be deleted and rerun. Use FindCorruptedNii.py. 

4) train highres3dnet model: 
sbatch batch_gpuTrain.sh
NOTE: run dataset_split_overwrite.m to ensure no subjects overlap between training/validation/testing. This should be done after an initial .csv file is created but before training begins (eg. start training in an interactive job and then stop once training begins. dataset_split.csv will not be generated again for later training, and so it can be overwritten as needed. 

5) run inference
regularSubmit -j Long singularity exec -B /scratch/jdekrake:/scratch/jdekrake --nv deeplearning_gpu.simg net_segment -c highres3dnet_hippocampus_parcellation/highres3dnet_hippocampus_config.ini inference

6) run evaluation
regularSubmit singularity exec -B /scratch/jdekrake:/scratch/jdekrake --nv deeplearning_gpu.simg net_run evaluation -a net_segment -c highres3dnet_hippocampus_parcellation/highres3dnet_hippocampus_config.ini
