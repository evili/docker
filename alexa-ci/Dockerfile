FROM fedora:latest

ENV OS_VERSION=25 \
    GECKO_VERSION=v0.15.0\
    PG_VERSION=9.6 \
    PG_MINOR=3 \
    PG_NODOT=96 \
    ROS_DIR='/srv/ros_catkin_ws' \
    ROS_DISTRO='indigo' \
    ROS_PKGS='catkin rospy std_msgs'

RUN cd /tmp && \
    curl -o pgdg.rpm -L http://yum.postgresql.org/${PG_VERSION}/fedora/fedora-${OS_VERSION}-x86_64/pgdg-fedora${PG_NODOT}-${PG_VERSION}-${PG_MINOR}.noarch.rpm && \
    dnf install -y ./pgdg.rpm && \
    dnf upgrade -y && \
    dnf install -y \
        python3-virtualenv python2-virtualenv \
        tigervnc-server firefox wget openssh-clients \
        gcc gcc-c++ openssh-clients git-core tar cmake make \
        openldap-devel openldap-clients redhat-rpm-config inkscape \
        poppler-utils tar python-rosdep python-empy python-gunicorn \
        python-rosdistro python-rosinstall python-rosinstall_generator \
        python-rospkg python-wstool ros-release boost-devel \
        console-bridge-devel tinyxml-devel \
        postgresql${PG_NODOT}-devel python2-psycopg2 python3-psycopg2

RUN rosdep init && \
    rosdep update && \
    mkdir -pv ${ROS_DIR} && \
    pushd ${ROS_DIR} && \
    rosinstall_generator-2.7 ros_comm --rosdistro ${ROS_DISTRO} --deps --wet-only --tar > indigo-ros_comm-wet.rosinstall && \
    wstool init -j8 src indigo-ros_comm-wet.rosinstall && \
    rosdep install --from-paths src --ignore-src --rosdistro ${ROS_DISTRO} -y && \
    for ros_pkg in ${ROS_PKGS}; do ./src/catkin/bin/catkin_make_isolated --install --only-pkg-with-deps ${ros_pkg} -DCMAKE_BUILD_TYPE=Release;done && \
    popd

ENV PATH /usr/pgsql-${PG_VERSION}/bin:${PATH}
