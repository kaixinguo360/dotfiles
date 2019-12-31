#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install ros"
    exit 0
fi

# Check Dependencies
has rosdep && [ "$1" != "-f" ] && echo 'ros installed' && exit 0
need curl

# Wiki: http://wiki.ros.org/kinetic/Installation/Ubuntu

# 1.1 Configure your Ubuntu repositories (Tsinghua University Mirror)
$sudo sh -c '. /etc/lsb-release && echo "deb http://mirrors.tuna.tsinghua.edu.cn/ros/ubuntu/ `lsb_release -cs` main" > /etc/apt/sources.list.d/ros-latest.list' || exit

# 1.2 Setup your sources.list
$sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 || exit

# 1.3 Set up your keys
curl -sSL 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' | $sudo apt-key add - || exit

# 1.4 Installation
$sudo apt-get update -y || exit

# Desktop-Full Install: (Recommended) : ROS, rqt, rviz, robot-generic libraries, 2D/3D simulators, navigation and 2D/3D perception
$sudo apt-get install -y ros-kinetic-desktop-full || exit

# 1.5 Dependencies for building packages
$sudo apt install -y python-rosinstall python-rosinstall-generator python-wstool build-essential || exit

# 1.6 Initialize rosdep
$sudo rosdep init
rosdep update

# 1.7 Environment setup
echo -e '\n ## Install finish! ##\n'
echo 'please add `source /opt/ros/kinetic/setup.bash` to ~/.bashrc'
echo 'or run it in this shell to setup ros environment temporarily'

