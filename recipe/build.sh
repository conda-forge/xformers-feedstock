set -ex

# Target the same CUDA archs as conda-forge pytorch package
# https://github.com/conda-forge/pytorch-cpu-feedstock/blob/main/recipe/build_pytorch.sh
if [[ ${cuda_compiler_version} != "None" ]]; then
    export TORCH_CUDA_ARCH_LIST=$(${PYTHON} -c "import torch;print(';'.join([f'{y[0]}.{y[1]}' for y in [x[3:] for x in torch._C._cuda_getArchFlags().split() if x.startswith('sm_')]])+'+PTX')")
    export TORCH_NVCC_FLAGS="-Xfatbin -compress-all"
fi

$PYTHON -m pip install . -vv --no-deps --no-build-isolation
