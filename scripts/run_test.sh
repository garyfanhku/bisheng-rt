#!/bin/bash


function run_test() {
  pushd python/pybackend_libs/src
  # PYTHONPATH=. TF_CPP_MIN_LOG_LEVEL=2 CUDA_VISIBLE_DEVICES=6 python3 tests/test_layout_mrcnn.py
  PYTHONPATH=. python3 tests/test_layout_mrcnn.py
  popd
}


function run_container_dev() {
  LOCAL_MODEL_REPO="/home/public/llm"
  MOUNT="-v $LOCAL_MODEL_REPO:$LOCAL_MODEL_REPO -v $HOME:$HOME"
  IMAGE="dataelement/bisheng-rt:0.0.3.alpha1"
  docker run --gpus=all --net=host -itd --workdir /opt/bisheng-rt \
      --shm-size=10G --name bisheng_rt_v003_dev ${MOUNT} $IMAGE bash
}


function run_container() {
  LOCAL_MODEL_REPO="/home/public/llm"
  MAPING_MODEL_REPO="/opt/bisheng-rt/models/model_repository"
  MOUNT="-v $LOCAL_MODEL_REPO:$MAPING_MODEL_REPO -v $HOME:$HOME"
  IMAGE="dataelement/bisheng-rt:0.0.2"
  docker run --gpus=all -p 9001:9001 -p 9002:9002 -itd --workdir /opt/bisheng-rt \
      --shm-size=10G --name bisheng_rt_v002 ${MOUNT} $IMAGE ./bin/rtserver f
}


function run_container_v003() {
  LOCAL_MODEL_REPO="/home/public/llm"
  MAPING_MODEL_REPO="/opt/bisheng-rt/models/model_repository"
  MOUNT="-v $LOCAL_MODEL_REPO:$MAPING_MODEL_REPO -v $HOME:$HOME"
  IMAGE="dataelement/bisheng-rt:0.0.3"
  docker run --gpus=all -p 9000:9000 -p 9001:9001 -p 9002:9002 -itd --workdir /opt/bisheng-rt \
      --shm-size=10G --name bisheng_rt_v003 ${MOUNT} $IMAGE bash
}


run_container_dev
# run_container
# run_container_v003
# run_test