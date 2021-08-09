#!/bin/bash

set -ex
set -o pipefail

go_to_build_dir() {
    if [ ! -z $INPUT_SUBDIR ]; then
        cd $INPUT_SUBDIR
    fi
}

check_if_meta_yaml_file_exists() {
    if [ ! -f meta.yaml ]; then
        echo "meta.yaml must exist in the directory that is being packaged and published."
        exit 1
    fi
}

build_package(){
    eval conda build "-c "${INPUT_CHANNELS} --output-folder . . --no-test
    if [ ${INPUT_CONVERT_OSX} = true ]; then
        conda convert -p osx-64 linux-64/*.tar.bz2
    fi
    if [ ${INPUT_CONVERT_WIN} = true ]; then
        conda convert -p win-64 linux-64/*.tar.bz2
    fi
}

build_and_test_package(){
    eval conda build "-c "${INPUT_CHANNELS} --output-folder . .
    if [ ${INPUT_CONVERT_OSX} = true ]; then
        conda convert -p osx-64 linux-64/*.tar.bz2
    fi
    if [ ${INPUT_CONVERT_WIN} = true ]; then
        conda convert -p win-64 linux-64/*.tar.bz2
    fi
}

test_package(){
    # builds and tests one package
    eval conda build "-c "${INPUT_CHANNELS} "--python="${INPUT_TEST_PYVER} "--numpy="${INPUT_TEST_NPVER} --output-folder . .
}

upload_package(){
    export ANACONDA_API_TOKEN=$INPUT_ANACONDATOKEN
    anaconda upload --label main linux-64/*.tar.bz2
    if [ ${INPUT_CONVERT_OSX} = true ]; then
        anaconda upload --label main osx-64/*.tar.bz2
    fi
    if [ ${INPUT_CONVERT_WIN} = true ]; then
        anaconda upload --label main win-64/*.tar.bz2
    fi
}

go_to_build_dir
check_if_meta_yaml_file_exists
if  [ ${INPUT_TEST_ALL} = true ]; then
    build_and_test_package
else
    # build and test only the specified combination of python and numpy
    # build_package
    test_package
fi

# upload package if INPUT_PUBLISH is set to true
if [ ${INPUT_PUBLISH} = true ]; then
    upload_package
fi
