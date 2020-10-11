FROM alpine:latest

# Set environment
ENV LANG en_US.UTF-8
ENV TERM xterm

# Install CUPS/AVAHI
RUN apk update --no-cache && apk add --no-cache bash cups cups-libs cups-client cups-filters avahi inotify-tools

RUN mkdir -p /config/cups /config/spool /config/logs /config/cache /config/cups/ssl /config/cups/ppd /config/cloudprint

# Copy config files
COPY /config /config/cups/

### Prepare avahi-daemon configuration ###
RUN sed -i 's/.*enable\-dbus=.*/enable\-dbus\=no/' /etc/avahi/avahi-daemon.conf \
  && sed -i 's/.*enable\-reflector=.*/enable\-reflector\=yes/' /etc/avahi/avahi-daemon.conf \
  && sed -i 's/.*reflect\-ipv=.*/reflect\-ipv\=yes/' /etc/avahi/avahi-daemon.conf

# Patch the default configuration file to only enable encryption if requested
# RUN sed -e '0,/^</s//DefaultEncryption IfRequested\n&/' -i /etc/cups/cupsd.conf

### Start syslogd ###
RUN /sbin/syslogd

### Start automatic printer refresh for avahi ###
#/srv/avahi-refresh.sh

### Start avahi instance ###
RUN /usr/sbin/avahi-daemon --daemonize --syslog

### Start CUPS instance ###
RUN /usr/sbin/cupsd -f -c /etc/cups/cupsd.conf

# Expose volumes
VOLUME /config /etc/cups/ /var/log/cups /var/spool/cups /var/cache/cups

# Expose SMB printer sharing
EXPOSE 137/udp 139/tcp 445/tcp

# Expose IPP printer sharing
EXPOSE 631/tcp

# Expose avahi advertisement
EXPOSE 5353/udp