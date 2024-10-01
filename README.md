# Dockerfiles for Husky Gazebo Simulation

## File Descriptions
```husky.Dockerfile```  
Environment with ros-noetic desktop (full), husky-desktop, husky-simulator and husky-navigation. Also includes git, nano and pip.  
  
```husky_cbfrl.Dockerfile```  
Environment to train cbf parameter model with husky-gazebo simulation. Includes all the packages per "husky.Dockerfile" with additional pip packages casadi, stable-baselines3 gymnasium imageio required to run NMPC and CBF-RL parameter training.


## Prerequisites
These files will build docker images allowing the simulation environment to be run independently of packages already installed on the host machine.  
Docker engine is required to be installed on the host machine, docker desktop includes docker engine as well as additional gui features for managing images and containers but is not required.

[Docker Engine Install Guide](https://docs.docker.com/engine/install/) (recommended)  
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
  
```docker run -it -<args>``` starts the container with arguments as:  
```--gpus all```  enable nvidia gpu (requires nvidia drivers)  
```--volume="</path/to/local/dir>:/home/user/husky"``` mounts a directory from host system within docker container.   
> [!IMPORTANT]
> The local host directory </path/to/local/dir> should be set to an existing folder on the host.   

```--privileged```  
```--network="host"``` share host network with container
```--name husky_container``` this is optional but assigns a non random name to the container which can be used to start/stop/commit later
```--user user``` the container has a non root user named "user" which will be used by default, user has sudo permissions  
> [!IMPORTANT]
> The docker user has been created with user id 1000, in order to avoid permissions conflicts check the output of ```echo $UID``` is 1000 in the host terminal shell. If it is not 1000 you will need to modify the container user id to match.   

```--entrypoint /bin/bash``` start the container in bash shell, from here can execute ros commands  
```husky_docker:latest``` the final argument is the image tag, modify this if a different tag was used to build image earlier.   

Running the command above should start the docker container and present a bash shell as @user inside the docker container.  

To open a second terminal tab/window execute the following command in a new terminal:  
```docker exec -it husky_container /bin/bash```  
This can be run in as many terminal windows as needed.  

