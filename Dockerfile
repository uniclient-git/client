FROM centos:7.4.1708

RUN yum -y update && yum clean all && yum install -y libXrender && yum install -y libXext && yum install -y fontconfig && yum install -y freetype && yum install -y libaio && yum install -y zip && yum install -y unzip  && yum install -y tigervnc-server && yum install -y xterm

# twm dependency packages
RUN yum -y install xorg-x11-font-utils.x86_64 && yum install -y xorg-x11-fonts-100dpi.noarch && yum install -y xorg-x11-fonts-75dpi.noarch && yum install -y xorg-x11-fonts-Type1.noarch && yum install -y dbus-x11.x86_64


#Uniserve binaries copying into docker image
ADD /Uniserve /Uniserve

#Oracle instant client include files copying into docker image
ADD /usr/include /usr/include

# oracle instant client libs copying into docker image
ADD /usr/lib /usr/lib

# Copy VNC configuration files
RUN mkdir /root/.vnc
ADD /VNC_Files /root/.vnc
RUN chmod 700 /root/.vnc/passwd
RUN chmod 700 /root/.vnc/xstartup_backup
RUN chmod 700 /root/.vnc/xstartup

# Copy twm package folders and files
ADD /twm/etc/X11/ /etc/X11
ADD /twm/usr/bin /usr/bin
ADD /twm/usr/share /usr/share

#creating symbolic link for sqlplus instant tool
RUN ln -s /usr/lib/oracle/11.2/client64/bin/sqlplus /usr/bin/sqlplus

#creating symbolic link for sqlplus instant tool
RUN ln -s /usr/lib/oracle/11.2/client64/lib/libclntsh.so /usr/lib/oracle/11.2/client64/lib/libclntsh.so.11.1
RUN ln -s /usr/lib/oracle/11.2/client64/lib/libclntsh.so /usr/lib/oracle/11.2/client64/lib/libclntsh.so.12.1
RUN ln -s /usr/include /usr/lib/oracle/11.2/client64/include

# setting library paths of Uniserve and oracle instant client
env LD_LIBRARY_PATH=/Uniserve/lib/:/Uniserve/bin:/Uniserve/bin/sqldrivers:/usr/lib/oracle/11.2/client64/lib

#setting executable paths of Uniserve and oracle instant client
env PATH=$PATH:/usr/lib/oracle/11.2/client64/bin:/Uniserve/bin

#setting Uniserve path
env RSDIR=/Uniserve

# setting environment variables for oracle instant client
env ORACLE_HOME=/usr/lib/oracle/11.2/client64 
env TNS_ADMIN=/usr/lib/oracle/11.2/client64/network/admin

#QT X11 rendering
env QT_X11_NO_MITSHM=1

COPY ./Trolltech.conf /etc/xdg/Trolltech.conf
COPY ./iECCM.conf /root/.config/Intense/iECCM.conf
COPY ./.fonts /root/.fonts
COPY ./autoscript.sh /Uniserve/autoscript.sh

RUN chmod 0777 /etc/xdg/Trolltech.conf
RUN chmod 0777 /root/.config/Intense/iECCM.conf
RUN chmod 0777 /root/.fonts
RUN chmod 0777 /Uniserve/autoscript.sh
RUN chmod 0777 /usr/lib/oracle/11.2/client64/bin/sqlplus

#Giving 777 permissions to Client Executables
RUN chmod 777 /Uniserve/bin/MPWorker
RUN chmod 777 /Uniserve/bin/RSProcessClient 
RUN chmod 777 /Uniserve/bin/RSPrintClient 
RUN chmod 777 /Uniserve/bin/RSMailClient 
RUN chmod 777 /Uniserve/bin/RSDBEClient 
RUN chmod 777 /Uniserve/bin/RSDCMClient 
RUN chmod 777 /Uniserve/bin/RSFSpyClient 
RUN chmod 777 /Uniserve/bin/RSDBWizard 
RUN chmod 777 /Uniserve/bin/RSMC
RUN chmod 777 /Uniserve/bin/UniServe
RUN chmod 777 /Uniserve/bin/RSServerConfig


CMD ./Uniserve/autoscript.sh && /bin/bash
