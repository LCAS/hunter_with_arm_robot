# Hunter With Arm Robot

```bash 

export GAZEBO_PLUGIN_PATH=/opt/ros/humble/lib:$GAZEBO_PLUGIN_PATH && echo "GAZEBO_PLUGIN_PATH=$GAZEBO_PLUGIN_PATH"


ros2 launch hunter_with_arm_robot_description sim_bringup.launch.py
```

--- 

This repository contains the non-CUDA robot workspace for the Hunter base, UR arm, Livox sensors, and robot-owned TF for fixed camera mounts. The CUDA ZED driver stack is not part of this repository anymore and should run from `aoc_zed` in separate camera containers.

Official Robot Website: [AgileX Hunter V2B](https://global.agilex.ai/products/hunter-2-0)

---

## Key Features

- **Ackermann Steering**: Configured for front-wheel steering with accurate kinematics.
- **ROS 2 Control Integration**: Leverages `ros2_control` for simulating robot kinematics and dynamics.
- **Robot-Owned Camera TF**: Publishes the fixed `base_link -> <camera>_link` mount frames so ZED drivers can run in separate containers without a shared build workspace.
- **URDF Description**: Detailed robot description based on manufacturer specifications.
- **Gazebo Simulation**: Visualize and simulate the Hunter V2 robot in Gazebo.
- **Rviz Support**: Visualize the robot and interact with its joints using Rviz.

---


## Installation and Build Instructions

### Prerequisites
Ensure you have a ROS 2 workspace set up. If not, create one:
```bash
mkdir -p ~/ros2_ws/src
cd ~/ros2_ws
colcon build
```

### Clone and Build
1. Clone this repository into your ROS 2 workspace:
    ```bash
    cd ~/ros2_ws/src
    git clone https://github.com/LCAS/hunter_robot.git
    ```
2. Install dependencies:
    ```bash
    rosdep update
    rosdep install --from-paths . --ignore-src -r -y
    ```
3. Build the workspace:
    ```bash
    cd ~/ros2_ws
    colcon build
    source install/setup.bash
    ```

---

## Packages Overview

This repository includes the following ROS 2 packages:

1. **`hunter_with_arm_description`**: URDF and robot description files. Also includes Gazebo simulation launch files and configuration (previously in `hunter_with_arm_gazebo`).
2. **`hunter_with_arm_robot_description`**: Composite robot description, sensor mount frames, and Gazebo simulation assets for the full platform.
3. **`hunter_with_arm_robot_bringup`**: MoveIt configuration and bringup files for the full platform.

## Container Boundary

The previous architecture was wrong. Building the robot workspace and the ZED SDK in the same image forced CUDA onto the entire robot stack for no gain.

- This repository should build from `lcas.lincoln.ac.uk/ros:humble`.
- `aoc_zed` should build from `lcas.lincoln.ac.uk/ros_cuda:*` and run one container per physical camera.
- The robot container owns fixed camera mount transforms such as `base_link -> front_camera_link`.
- Each `aoc_zed` container owns camera-internal frames and ZED topics under its camera namespace.
- If the ZED cameras are not the localization source, launch them with `publish_tf:=false` and `publish_map_tf:=false` to avoid polluting the TF tree.

---

## Usage

### 1. Visualize the Robot in Rviz

To view the robot model and interact with its joints in Rviz:

```bash
ros2 launch hunter_with_arm_description robot_view.launch.py
```

This launch file starts Rviz and loads the Hunter V2 model.

[Rviz Simulation](https://github.com/user-attachments/assets/1cc10c03-fad7-47b0-8816-74c49d79be31)

---

### 2. Simulate the Robot in Gazebo

To load the Hunter V2 in a Gazebo simulation environment:

```bash
ros2 launch hunter_with_arm_description launch_sim.launch.py
```

[Gazebo Simulation](https://github.com/user-attachments/assets/90757617-af3b-4bc8-bf1f-f08c5ecc1247)

---

### 3. Control the Robot with Teleop

You can control the Hunter V2 using the `teleop_twist_keyboard` package. First, ensure the simulation is running, then execute:

```bash
ros2 run teleop_twist_keyboard teleop_twist_keyboard --ros-args --remap cmd_vel:=/ackermann_like_controller/cmd_vel
```

Use the keyboard inputs to move the robot in the simulation.

---

## Robot Controller Configuration

The main configuration of the robot controller is available [here](https://github.com/LCAS/hunter_robot/blob/main/hunter_with_arm_description/config/ackermann_like_controller.yaml)

---

## Robot Specifications

The primary robot parameters, such as mass, wheel size, and turning angles, are derived from the manufacturer's specifications and the following reference repository:

- [Hunter 2 Base URDF (AgileX Robotics)](https://github.com/agilexrobotics/ugv_gazebo_sim/blob/master/hunter/hunter2_base/urdf/hunter2_base_gazebo.xacro)

---

## License

This project is licensed under the **Apache License**. See the [LICENSE](LICENSE) file for details.

---

## References

For more details on ROS 2 Control and Gazebo integration, see:

- [ros2_controllers](https://github.com/ros-controls/ros2_controllers/tree/master)
- [gazebo_ros2_control](https://github.com/ros-controls/gazebo_ros2_control)
- [Getting Started with ros2_control](https://control.ros.org/humble/doc/getting_started/getting_started.html)
- [ros2controlcli Documentation](https://control.ros.org/master/doc/ros2_control/ros2controlcli/doc/userdoc.html)
- [gazebo_ros2_control User Guide](https://control.ros.org/rolling/doc/gazebo_ros2_control/doc/index.html)
- [Video Tutorial](https://youtu.be/BcjHyhV0kIs?si=dUpg7IF-kHSUgB-w)

---

# Mobile Manipulator Platform ROS 2 Packages

This repository is designed for bringing up a mobile manipulator platform with the following packages: `hunter_with_arm_robot_bringup` and `hunter_with_arm_robot_description` to facilitate bringing up the robot, providing its description, and simulating it in Gazebo, part of the Agri-OpenCore (AOC) project.


--- 

# Josh's Notes

## Testing description of a manipulator
To visualize the robot install this repository to you workspace and execute the following:

```bash
ros2 launch ur_description view_ur.launch.py ur_type:=ur5e
```