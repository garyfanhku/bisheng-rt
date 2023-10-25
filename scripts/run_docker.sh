#!/bin/bash

function run_dev() {
    MOUNT="-v /home/work:/home/work -v /home/public:/home/public"
    IMAGE="tritonserver:22.08"
    docker run --gpus=all --net=host -itd --shm-size=10G --name bisheng_rt_v0.0.1 ${MOUNT} $IMAGE bash
}


function up_repo() {
  projdir="$(pwd)"
  output_dir="${projdir}/output/install"
  
  cp ${projdir}/python/pybackend_libs/requirements.txt ./output/deps/
  rm -fr ${output_dir}/resource/internal_model_repository/*
  cp -fr ${projdir}/resource/internal_model_repository/* \
    ${output_dir}/resource/internal_model_repository/

  rm -fr ${output_dir}/backends/python/pybackend_libs
  cp -fr ${projdir}/python/pybackend_libs/src/pybackend_libs ${output_dir}/backends/python/
  pushd ${output_dir}/backends/python
  find ./ -name __pycache__ -exec rm -fr {} \;
  popd
}

function build_image() {
    curr=$(pwd)
    up_repo
    pushd ${curr}/output
    docker build -t dataelement/bisheng-rt:0.0.2 -f "$curr/docker/runtime.Dockerfile" . --no-cache
    popd
}

function temp_build_image() {
    LOCAL_HOME=$HOME
    docker exec bisheng_rt_v001 bash -c "cd ${LOCAL_HOME}/projects/bisheng-rt && bash src/tests/scripts/model_repo_test.sh update"
    docker commit -a "hanfeng@dataelem.com" -m "commit bisheng-rt image" bisheng_rt_v001 dataelement/bisheng-rt:0.0.2
}


function temp_build_image_v003() {
    docker rmi dataelement/bisheng-rt:0.0.3
    LOCAL_HOME=$HOME
    # docker exec bisheng_rt_v001 bash -c "cd ${LOCAL_HOME}/projects/bisheng-rt && bash src/tests/scripts/model_repo_test.sh update"
    docker commit -a "hanfeng@dataelem.com" -m "commit bisheng-rt image" bisheng_rt_v003_dev dataelement/bisheng-rt:0.0.3
    docker push dataelement/bisheng-rt:0.0.3
}

function temp_build_image_v003_alpha1() {
    docker rmi dataelement/bisheng-rt:0.0.3.alpha1
    LOCAL_HOME=$HOME
    # docker exec bisheng_rt_v001 bash -c "cd ${LOCAL_HOME}/projects/bisheng-rt && bash src/tests/scripts/model_repo_test.sh update"
    docker commit -a "hanfeng@dataelem.com" -m "commit bisheng-rt image" bisheng_rt_v003_dev dataelement/bisheng-rt:0.0.3.alpha1
    docker push dataelement/bisheng-rt:0.0.3.alpha1
}

temp_build_image_v003_alpha1
# temp_build_image_v003
# temp_build_image
# build_image
# run_dev

