# 1. Use the official PyTorch base (Runtime is lighter than Devel)
FROM pytorch/pytorch:2.6.0-cuda12.6-cudnn9-runtime

# 2. Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# 3. Install system dependencies for Gymnasium/Rendering
# These are essential for RL environments like Atari or MuJoCo
RUN apt-get update && apt-get install -y --fix-missing \
    libgl1-mesa-glx \
    libosmesa6-dev \
    swig \
    xvfb \
    bash-completion \
    && rm -rf /var/lib/apt/lists/*

# 4. Upgrade pip and install your specific stack
# We use the PyTorch index to ensure we get the CUDA-enabled binaries
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir \
    "numpy>=2.0.0" \
    "pandas>=2.2.0" \
    "matplotlib>=3.8.0" \
    "gymnasium[all]" \
    "stable-baselines3>=2.3.0"

# --- Add Non-Root User ---
ARG USERNAME=rl
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user and add to sudo group
RUN apt-get update && apt-get install -y sudo \
    && groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Set this user as the default for the container
USER $USERNAME

# 5. Set the working directory
WORKDIR /workspace

# Default command: launch a bash shell
CMD ["/bin/bash"]