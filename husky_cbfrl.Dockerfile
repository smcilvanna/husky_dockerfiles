FROM osrf/ros:noetic-desktop-full

# update 
RUN apt-get update 
# apt install packages
RUN apt-get install -y \
    ros-noetic-husky-desktop \
    ros-noetic-husky-simulator \
    ros-noetic-husky-navigation \
    python3-pip \
    git \
    nano

RUN python3 -m pip install --no-cache-dir casadi gymnasium imageio stable-baselines3

# Setup new non root user (called user) with sudo privlages
ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # Add sudo support.
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME

RUN echo "# === ROS SETUP ===" >> /home/user/.bashrc && \
    echo "source /opt/ros/noetic/setup.bash" >> /home/user/.bashrc && \
    echo "source /home/user/husky/husky_mpc_ws/devel/setup.bash" >> /home/user/.bashrc && \
    echo " " >> /home/user/.bashrc && \
    echo "# === HUSKY CONFIG ===" >> /home/user/.bashrc && \
    echo "export HUSKY_LASER_3D_ENABLED=0   # set to 1 to enable simulated lidar" >> /home/user/.bashrc && \
    echo " " >> /home/user/.bashrc && \
    echo "#Python3 alias " >> /home/user/.bashrc && \
    echo "alias python=python3" >> /home/user/.bashrc

# [Optional] Set the default user. Omit if you want to keep the default as root.

WORKDIR /home/user/husky