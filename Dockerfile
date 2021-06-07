FROM ubuntu:bionic as builder

ARG DEBIAN_FRONTEND=noninteractive
RUN sed -i "s/# deb-src/deb-src/g" /etc/apt/sources.list \
 && apt-get -yq update \
 && apt-get -yq upgrade
 
ENV BUILD_DEPS="git autoconf libtool pkg-config bash-completion gcc g++ make  libssl-dev libpam0g-dev \
    libjpeg-dev libx11-dev libxfixes-dev libxrandr-dev  flex bison libxml2-dev \
    intltool xsltproc xutils-dev python-libxml2 xutils libfuse-dev \
    libmp3lame-dev nasm libpixman-1-dev xserver-xorg-dev \
    build-essential dpkg-dev pulseaudio libpulse-dev"
RUN apt-get -yq install sudo apt-utils software-properties-common $BUILD_DEPS
    
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
RUN apt-get -yq update \
 && apt-get -yq install locales \
 && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8
ENV LANG ru_RU.UTF8
ENV LC_ALL ru_RU.UTF-8
RUN apt-get -yq install \
    ca-certificates \
    crudini \
    less \
    pulseaudio \
    sudo \
    supervisor \
    uuid-runtime \
    wget \
    curl \
    nano \
    xauth \
    xrdp \
    xorgxrdp \
    xprintidle \
    xautolock \
    xmlstarlet \
 && apt-get -yq install --no-install-recommends \
    openbox \
    slock \
# CHROMIUM
    chromium-browser \
    chromium-browser-l10n \
# MICROSOFT EDGE
# && curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
# && install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/ \
# && sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-beta.list' \
# && rm microsoft.gpg \
# && apt-get -yq update \
# && apt-get -yq install microsoft-edge-beta \
# WIN FONT
# && echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections \
# && apt-get install -y --no-install-recommends fontconfig ttf-mscorefonts-installer \
# && fc-cache -f -v \
 && apt-get -yq remove xscreensaver \
 && apt-get -yq autoremove \
 && apt-get -yq autoclean \
 && rm -rf /var/cache/apt /var/lib/apt/lists \
 && mkdir -p /var/lib/xrdp-pulseaudio-installer \
 && mkdir -p /extensions
COPY --from=builder /tmp/so/module-xrdp-source.so /var/lib/xrdp-pulseaudio-installer
COPY --from=builder /tmp/so/module-xrdp-sink.so /var/lib/xrdp-pulseaudio-installer
ADD bin /usr/bin
ADD etc /etc

RUN mkdir /var/run/dbus \
 && cp /etc/X11/xrdp/xorg.conf /etc/X11 \
 && sed -i "s/console/anybody/g" /etc/X11/Xwrapper.config \
 && sed -i "s/xrdp\/xorg/xorg/g" /etc/xrdp/sesman.ini \
 && sed -i "s|MaxSessions=.*|MaxSessions=10|" /etc/xrdp/sesman.ini \
 && sed -i "s|KillDisconnected=.*|KillDisconnected=true|" /etc/xrdp/sesman.ini \
 && sed -i "s|DisconnectedTimeLimit=.*|DisconnectedTimeLimit=$IDLETIME|" /etc/xrdp/sesman.ini \ 
 && sed -i "s|ls_top_window_bg_color=.*|ls_top_window_bg_color=000000|" /etc/xrdp/xrdp.ini \
 && sed -i "s|ls_width=.*|ls_width=350|" /etc/xrdp/xrdp.ini \
 && sed -i "s|ls_height=.*|ls_height=160|" /etc/xrdp/xrdp.ini \
 && sed -i "s|ls_bg_color=.*|ls_bg_color=dedede|" /etc/xrdp/xrdp.ini \
 && sed -i "s|ls_logo_filename=.*|ls_logo_filename=\"/logo.bmp\"|" /etc/xrdp/xrdp.ini \
 && sed -i "s|ls_logo_x_pos=.*|ls_logo_x_pos=-10|" /etc/xrdp/xrdp.ini \
 && sed -i "s|ls_logo_y_pos=.*|ls_logo_y_pos=-10|" /etc/xrdp/xrdp.ini \
 && sed -i "s|ls_label_x_pos=.*|ls_label_x_pos=30|" /etc/xrdp/xrdp.ini \
 && sed -i "s|ls_label_width=.*|ls_label_width=60|" /etc/xrdp/xrdp.ini \
 && sed -i "s|ls_input_x_pos=.*|ls_input_x_pos=110|" /etc/xrdp/xrdp.ini \
 && sed -i "s|ls_input_width=.*|ls_input_width=210|" /etc/xrdp/xrdp.ini \
 && sed -i "s|ls_input_y_pos=.*|ls_input_y_pos=30|" /etc/xrdp/xrdp.ini \ 
 && sed -i "s|ls_btn_ok_x_pos=.*|ls_btn_ok_x_pos=142|" /etc/xrdp/xrdp.ini \
 && sed -i "s|ls_btn_ok_y_pos=.*|ls_btn_ok_y_pos=120|" /etc/xrdp/xrdp.ini \
 && sed -i "s|ls_btn_ok_width=.*|ls_btn_ok_width=85|" /etc/xrdp/xrdp.ini \
 && sed -i "s|ls_btn_ok_height=.*|ls_btn_ok_height=30|" /etc/xrdp/xrdp.ini \ 
 && sed -i "s|ls_btn_cancel_x_pos=.*|ls_btn_cancel_x_pos=237|" /etc/xrdp/xrdp.ini \
 && sed -i "s|ls_btn_cancel_y_pos=.*|ls_btn_cancel_y_pos=120|" /etc/xrdp/xrdp.ini \
 && sed -i "s|ls_btn_cancel_width=.*|ls_btn_cancel_width=85|" /etc/xrdp/xrdp.ini \
 && sed -i "s|ls_btn_cancel_height=.*|ls_btn_cancel_height=30|" /etc/xrdp/xrdp.ini \ 
 && rm -rf /etc/xrdp/rsakeys.ini /etc/xrdp/*.pem \
 && locale-gen ru_RU.UTF-8 \
 && echo "pulseaudio -D --enable-memfd=True" > /etc/skel/.Xsession \
 && xmlstarlet ed -L -u "/_:openbox_config/_:theme/_:keepBorder" -v "no" /etc/xdg/openbox/rc.xml \
 && xmlstarlet ed -L -u "/_:openbox_config/_:desktops/_:number" -v "1" /etc/xdg/openbox/rc.xml \
 && xmlstarlet ed -L -s "/_:openbox_config/_:applications" -t elem -n application -v "" \
                     -i //application -t attr -n name -v "chromium-browser" \
                     -s //application -t elem -n decor -v "no" \
                     -s //application -t elem -n fullscreen -v "yes" /etc/xdg/openbox/rc.xml \
 && xmlstarlet ed -L -d "/_:openbox_config/_:mouse/*" /etc/xdg/openbox/rc.xml \
 && xmlstarlet ed -L -d "/_:openbox_config/_:keyboard/*" /etc/xdg/openbox/rc.xml \
 && xmlstarlet ed -L -s "/_:openbox_config/_:keyboard" -t elem -n keybind -v "" \
                     -i //keybind -t attr -n key -v "C-o" \
                     -s //keybind -t elem -n action -v "" \
                     -i //action -t attr -n name -v "Execute" \
                     -s //action -t elem -n command -v "echo 0" /etc/xdg/openbox/rc.xml \
 && xmlstarlet ed -L -s "/_:openbox_config/_:keyboard" -t elem -n keybind -v "" \
                     -i //keybind -t attr -n key -v "C-s" \
                     -s //keybind -t elem -n action -v "" \
                     -i //action -t attr -n name -v "Execute" \
                     -s //action -t elem -n command -v "echo 0" /etc/xdg/openbox/rc.xml \
# && xmlstarlet ed -L -s "/_:openbox_config/_:keyboard" -t elem -n keybind -v "" \
#                     -i //keybind -t attr -n key -v "A-S-<key>" \
#                     -s //keybind -t elem -n action -v "" \
#                     -i //action -t attr -n name -v "Execute" \
#                     -s //action -t elem -n command -v "setxkbmap en" /etc/xdg/openbox/rc.xml \
# && xmlstarlet ed -L -s "/_:openbox_config/_:keyboard" -t elem -n keybind -v "" \
#                     -i //keybind -t attr -n key -v "A-S-<key>" \
#                     -s //keybind -t elem -n action -v "" \
#                     -i //action -t attr -n name -v "Execute" \
#                     -s //action -t elem -n command -v "setxkbmap ru" /etc/xdg/openbox/rc.xml \
 && bash -c 'cat <<EOT >> /etc/xrdp/xrdp_keyboard.ini

[layouts_map_ru]
rdp_layout_us=ru,us
rdp_layout_ru=ru,us

[rdp_keyboard_ru]
keyboard_type=4
keyboard_type=7
keyboard_subtype=1
options=grp:ctrl_shift_toggle,grp:alt_shift_toggle,grp:win_space_toggle
rdp_layouts=default_rdp_layouts
layouts_map=layouts_map_ru
EOT' \
 && echo "openbox-session" > /etc/skel/.Xsession

ENV KIOSKURL="localhost"
VOLUME ["/home"]
EXPOSE 3389 9001
ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]
CMD ["supervisord", "--configuration=/etc/supervisor/supervisord.conf"]
