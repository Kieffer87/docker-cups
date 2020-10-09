FROM alpine:latest

# Set correct environment variables
ENV HOME="/root" LC_ALL="C.UTF-8" LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" TERM="xterm"

# Install CUPS/AVAHI
RUN apk update --no-cache && apk add --no-cache bash cups cups-libs cups-client cups-filters avahi inotify-tools

# Configure the service's to be reachable
RUN /usr/sbin/cupsd \
  && while [ ! -f /var/run/cups/cupsd.pid ]; do sleep 1; done \
  && cupsctl --remote-admin --remote-any --share-printers \
  && kill $(cat /var/run/cups/cupsd.pid)

# Patch the default configuration file to only enable encryption if requested
RUN sed -e '0,/^</s//DefaultEncryption IfRequested\n&/' -i /etc/cups/cupsd.conf

# Expose SMB printer sharing
# EXPOSE 137/udp 139/tcp 445/tcp

# Expose IPP printer sharing
EXPOSE 631/tcp

# Expose avahi advertisement
# EXPOSE 5353/udp

# Start CUPS instance
# CMD ["/usr/sbin/cupsd", "-f"]