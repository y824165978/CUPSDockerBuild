# syntax=docker/dockerfile:1

# Use the stable-slim Debian base image
FROM debian:stable-slim

# Set the working directory inside the container
WORKDIR /workspaces/cups

# Update package list and upgrade existing packages
# RUN apt-get update -y && apt-get upgrade --fix-missing -y
RUN apt-get update --fix-missing -y && apt-get upgrade --fix-missing -y

# Install required dependencies for CUPS
RUN apt-get install -y autoconf build-essential \
    avahi-daemon libavahi-client-dev \
    libssl-dev libkrb5-dev libnss-mdns libpam-dev \
    libsystemd-dev libusb-1.0-0-dev zlib1g-dev \
    openssl sudo

# Copy the current directory contents into the container's working directory
COPY . /root/cups
WORKDIR /root/cups
RUN LDFLAGS='-Wl,-rpath=${libdir}' ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var && make clean && make && make install

# Expose port 631 for CUPS web interface
EXPOSE 631

# Add a new user 'admin' with password 'admin'
RUN useradd -m --create-home --password $(echo 'admin' | openssl passwd -1 -stdin) -f 0 admin

# Create a new group 'lpadmin'
RUN groupadd lpadmin

# Add the user 'admin' to the 'lpadmin' group
RUN usermod -aG lpadmin admin

# Grant sudo privileges to the user 'admin'
RUN echo 'admin ALL=(ALL:ALL) ALL' >> /etc/sudoers

# Start the CUPS daemon for remote access
RUN /usr/sbin/cupsd \
    && while [ ! -f /var/run/cups/cupsd.pid ]; do sleep 1; done \
    && cupsctl --remote-admin --remote-any --share-printers \
    && kill $(cat /var/run/cups/cupsd.pid)

# Baked-in config file changes
RUN sed -i 's/SystemGroup sys root/SystemGroup lpadmin/' /etc/cups/cups-files.conf && \
    sed -i 's/Port 631/Port 631\nServerAlias */' /etc/cups/cupsd.conf && \
    sed -i 's/DefaultAuthType Basic/DefaultAuthType Basic\nDefaultEncryption IfRequested/' /etc/cups/cupsd.conf

# volumes
RUN cp -rp /etc/cups /etc/cups-bak
VOLUME ["/etc/cups"]
VOLUME ["/var/log/cups"]

ADD entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/sbin/cupsd", "-f"]
