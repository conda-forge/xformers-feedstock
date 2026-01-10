set -ex

# Target the same CUDA archs as conda-forge pytorch package
# https://github.com/conda-forge/pytorch-cpu-feedstock/blob/main/recipe/build_pytorch.sh
# Number of CUDA archs reduced to fit CI resources
if [[ ${cuda_compiler_version} != "None" ]]; then
    if [[ ${cuda_compiler_version} == 12.9 ]]; then
        export TORCH_CUDA_ARCH_LIST="5.0;6.0;7.0;7.5;8.0;8.6;8.9;10.0;12.0+PTX"
    else
        echo "Unsupported CUDA compiler version. Edit build.sh to add target CUDA archs."
        exit 1
    fi
    export TORCH_NVCC_FLAGS="-Xfatbin -compress-all"
    export FORCE_CUDA=1
fi

# avoid "error: 'value' is unavailable: introduced in macOS 10.13"
export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"

export BUILD_VERSION=${PKG_VERSION}

$PYTHON -m pip install . -vv --no-deps --no-build-isolation
