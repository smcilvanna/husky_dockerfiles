# Dockerfiles for Husky Gazebo Simulation

## File Descriptions
```husky.Dockerfile``` : Environment with ros-noetic desktop (full), husky-desktop, husky-simulator and husky-navigation. Also includes git, nano and pip.
```husky_cbfrl.Dockerfile``` : Environment to train cbf parameter model with husky-gazebo simulation, includes all packages as "husky.Dockerfile" with additional pip packages casadi, stable-baselines3 gymnasium imageio.


## Prerequsites
These files will build docker images allowing the simulation environment to be run independently of packages already installed on the host machine.  
Docker engine is requred to be installed on the host machine, docker desktop includes docker enginer as well as additional gui features for managing images and containers but is not requred.

[Docker Engine Install Guide](https://docs.docker.com/engine/install/) (reccomended)  
  OR  
[Docker Desktop Install Guide](https://docs.docker.com/desktop/)  

## Build Instructions
Download the dockerfile or clone this repository. In the local directory with the dockerfile run the command:  

```docker build -f <file>.dockerfile -t husky_docker:latest .```  
The ```-f <file>``` argument should be entered with the exact file you want to build a image for.  
The ```-t <tag>:<version>``` sets the name (tag) for the built image, will need this name when running the final image.  
The console should indicate the progress of the build, when it is complete, run ```docker images``` and you should see the husky_docker:latest image in the list of docker images.


## Run Instructions
When the image build is complete, the container can be started using the command below:  
```
xhost +local:docker && \
docker run -it \
    --gpus all \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="/home/sm/Documents/docker/husky:/home/user/husky" \
    --privileged \
    --network="host" \
    --name husky_container \
    --user user \
    --entrypoint /bin/bash \
    husky_docker:latest
```  
Above consists of two commands:  
```xhost +local:docker``` allows the gui window elements to render on the host system.  
```docker run -it -<args>``` starts the container with the following options:  
    --gpus all  = enable nvidia gpu
    --volume="/home/sm/Documents/docker/husky:/home/user/husky" - mount volume from host system in docker container, adjust paths as necessary
