# Simple Ubuntu Linux container
# Ubuntu 24.04 base image
FROM ubuntu:24.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install essential development tools
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    gcc \
    g++ \
    gdb \
    clang \
    lldb \
    make \
    ninja-build \
    git \
    curl \
    wget \
    vim \
    nano \
    htop \
    tmux \
    unzip \
    zip \
    software-properties-common \
    iputils-ping \
    net-tools \
    iproute2 \
    openssh-client \
    sudo \
    bash-completion \
    && rm -rf /var/lib/apt/lists/*



# --- Add Non-Root User ---
ARG USERNAME=linux
ARG USER_UID=1001
ARG USER_GID=$USER_UID

# Create the user and add to sudo group
RUN apt-get update && apt-get install -y sudo \
    && groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

RUN git config --global user.name "lokesh" && \
    git config --global user.email "g.sailokesh9@gmail.com" && \
    git config --global init.defaultBranch main

# Set this user as the default for the container
USER $USERNAME

# 5. Set the working directory
WORKDIR /workspace

# Default command: launch a bash shell
CMD ["/bin/bash"]