ARG BASE_IMAGE=lcas.lincoln.ac.uk/ros:humble-main
ARG ROS_DISTRO=humble

FROM ${BASE_IMAGE} AS base

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    git \
    python3-colcon-common-extensions \
    python3-rosdep \
    python3-vcstool \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/src

FROM base AS deps

COPY . /tmp/src
RUN find /tmp/src -type f ! -name package.xml -delete \
  && find /tmp/src -mindepth 1 -type d -empty -delete

RUN rosdep update --rosdistro ${ROS_DISTRO} \
  && apt-get update \
  && rosdep install --rosdistro ${ROS_DISTRO} --from-paths /tmp/src --ignore-src -r -y \
  && rm -rf /tmp/src /var/lib/apt/lists/*

FROM deps AS final

WORKDIR /workspace/src

COPY . /workspace/src

WORKDIR /workspace

RUN /bin/bash -lc "source /opt/ros/${ROS_DISTRO}/setup.bash && colcon build --symlink-install"

RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /etc/bash.bashrc \
  && echo "source /workspace/install/setup.bash" >> /etc/bash.bashrc

ENV ROS_DOMAIN_ID=10

CMD ["/bin/bash", "-lc", "source /workspace/install/setup.bash && exec ros2 launch hunter_with_arm_robot_description pltf_rsp.launch.py"]