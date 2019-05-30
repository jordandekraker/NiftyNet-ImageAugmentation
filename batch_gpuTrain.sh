#!/bin/bash
#SBATCH --account=def-akhanf-ab
#SBATCH --ntasks=1
#SBATCH --gres=gpu:p100:1
#SBATCH --exclusive
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=24:00:00
#SBATCH --output=/scratch/jdekrake/niftynet/jobs/batch_gpuTrain.%A.out

module load arch/avx512 StdEnv/2018.3
nvidia-smi

singularity exec -B /scratch/jdekrake:/scratch/jdekrake --nv deeplearning_gpu.simg net_segment -c highres3dnet_hippocampus_config.ini train
