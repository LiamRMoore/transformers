
## Install docker and docker-compose

Install [docker](https://www.docker.com/) and [docker-compose](https://docs.docker.com/compose/install/).

## (Optional) Enable GPU

If you have a CUDA enabled GPU, you can take advantage of GPU acceleration. If you already have CUDA installed, skip steps 1-3.

1. Install a NVIDIA GPU driver from [here](https://www.nvidia.com/download/index.aspx?lang=en-us) or using your system's package manager.

2. Confirm installation and that your GPU is detected. On Linux, you can do this by running `nvidia-smi`.

3. Finally, install [NVIDIA Container Toolkit](https://github.com/NVIDIA/nvidia-docker).

## Launch container

Build the image (if not already) and launch the container (with GPU support) in the background with:

`docker-compose up -d`

This will run a notebook server in a docker container with all the necessary libraries. You can get the URL for the running notebook server by then running:

`docker-compose logs transformers`

The course directory is a bound volume in the container so any additions or changes made within there will persist on your local disk.
