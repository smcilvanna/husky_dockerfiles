FROM osrf/ros:noetic-desktop-full

# Update and install packages
RUN apt-get update && apt-get install -y \
    ros-noetic-husky-desktop \
    ros-noetic-husky-simulator \
    ros-noetic-husky-navigation \
    python3-pip \
    git \
    nano

# Add build arguments for UID/GID synchronization
ARG USERNAME=user
ARG HOST_UID=1000
ARG HOST_GID=1000

# Create user with specified UID/GID
RUN groupadd --gid $HOST_GID $USERNAME && \
    useradd --uid $HOST_UID --gid $HOST_GID -m $USERNAME && \
    apt-get update && \
    apt-get install -y sudo && \
    echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

# Environment setup
USER $USERNAME
RUN echo "# === ROS SETUP ===" >> /home/$USERNAME/.bashrc && \
    echo "source /opt/ros/noetic/setup.bash" >> /home/$USERNAME/.bashrc && \
    echo "export HUSKY_LASER_3D_ENABLED=0" >> /home/$USERNAME/.bashrc && \
    echo "alias python=python3" >> /home/$USERNAME/.bashrc

WORKDIR /home/$USERNAME
