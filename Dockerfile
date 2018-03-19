FROM centos:7.4.1708

RUN yum -y update && yum clean all && yum install -y libXrender && yum install -y libXext && yum install -y fontconfig && yum install -y freetype && yum install -y libaio && yum install -y zip && yum install -y unzip  && yum install -y tigervnc-server && yum install -y xterm

# twm dependency packages
RUN yum -y install xorg-x11-font-utils.x86_64 && yum install -y xorg-x11-fonts-100dpi.noarch && yum install -y xorg-x11-fonts-75dpi.noarch && yum install -y xorg-x11-fonts-Type1.noarch && yum install -y dbus-x11.x86_64
