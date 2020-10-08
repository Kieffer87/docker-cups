  
FROM alpine:latest
MAINTAINER Kieffer87 <ToddMKieffer@gmail.com>

# Set correct environment variables
ENV HOME="/root" LC_ALL="C.UTF-8" LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" TERM="xterm"

# Install CUPS/AVAHI
RUN apk update --no-cache && apk add --no-cache cups cups-libs cups-client cups-filters avahi inotify-tools

# Copy configuration files
# COPY root /

# Prepare CUPS container
# RUN chmod 755 /srv/run.sh

# Expose SMB printer sharing
# EXPOSE 137/udp 139/tcp 445/tcp

# Expose IPP printer sharing
# EXPOSE 631/tcp

# Expose avahi advertisement
# EXPOSE 5353/udp

# Start CUPS instance
# Doesn't Work
# run ["/usr/sbin/cupsd -f"]