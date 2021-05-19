FROM ubuntu:bionic as builder

ARG DEBIAN_FRONTEND=noninteractive
RUN sed -i "s/# deb-src/deb-src/g" /etc/apt/sources.list \
 && apt-get -y update \
 && apt-get -yy upgrade
 
ENV BUILD_DEPS="git autoconf libtool pkg-config gcc g++ make  libssl-dev libpam0g-dev \
    libjpeg-dev libx11-dev libxfixes-dev libxrandr-dev  flex bison libxml2-dev \
    intltool xsltproc xutils-dev python-libxml2 xutils libfuse-dev \
    libmp3lame-dev nasm libpixman-1-dev xserver-xorg-dev \
    build-essential dpkg-dev pulseaudio libpulse-dev"
RUN apt-get -yy install sudo apt-utils software-properties-common $BUILD_DEPS
    
WORKDIR /tmp
RUN git clone --recursive https://github.com/neutrinolabs/xrdp.git \
 && git clone --recursive https://github.com/neutrinolabs/pulseaudio-module-xrdp.git \
 && apt-get build-dep -yy pulseaudio \
 && apt-get source pulseaudio
WORKDIR /tmp/pulseaudio-11.1
RUN ./configure
WORKDIR /tmp/xrdp
RUN ./bootstrap \
 && ./configure --enable-fuse --enable-mp3lame --enable-pixman \
 && make \
 && make install
WORKDIR /tmp/pulseaudio-module-xrdp
RUN ./bootstrap \
 && ./configure PULSE_DIR=/tmp/pulseaudio-11.1 \
 && make
RUN mkdir -p /tmp/so \
 && cp src/.libs/*.so /tmp/so

FROM ubuntu:bionic
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update \
 && apt-get -yy install locales \
 && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8
ENV LANG ru_RU.UTF8
RUN apt-get -y install --no-install-recommends \
    openbox \
    slock \
    chromium-browser \
    ca-certificates \
    crudini \
    less \
    pulseaudio \
    sudo \
    supervisor \
    uuid-runtime \
    wget \
    xauth \
    xrdp \
    xorgxrdp \
    xprintidle \
    xserver-xorg-legacy \
 && apt-get -y remove xscreensaver \
 && apt-get -y autoremove \
 && apt-get -y autoclean \
 && rm -rf /var/cache/apt /var/lib/apt/lists \
 && mkdir -p /var/lib/xrdp-pulseaudio-installer
COPY --from=builder /tmp/so/module-xrdp-source.so /var/lib/xrdp-pulseaudio-installer
COPY --from=builder /tmp/so/module-xrdp-sink.so /var/lib/xrdp-pulseaudio-installer
ADD bin /usr/bin
ADD etc /etc
# ADD autostart /etc/xdg/autostart

RUN mkdir /var/run/dbus \
 && cp /etc/X11/xrdp/xorg.conf /etc/X11 \
 && sed -i "s/console/anybody/g" /etc/X11/Xwrapper.config \
 && sed -i "s/xrdp\/xorg/xorg/g" /etc/xrdp/sesman.ini \
 && rm -rf /etc/xrdp/rsakeys.ini /etc/xrdp/*.pem \
 && locale-gen ru_RU.UTF-8 \
 && echo "pulseaudio -D --enable-memfd=True" > /etc/skel/.Xsession \
 && echo "openbox-session" > /etc/skel/.Xsession
 
VOLUME ["/home"]
EXPOSE 3389 9001
ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]
CMD ["supervisord"]
