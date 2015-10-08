# Pull base image.
FROM teamrock/apache2:production

#
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y php5-imagick php5-gd php5-intl php5-mcrypt php5-apcu php5-curl php5-mysql

# Add our virtual-host.conf
ADD ./virtual-host.conf /etc/apache2/sites-enabled/0-virtual-host.conf

# Add our initialisation script
ADD ./run.sh /tmp/run.sh

# Commands we need in order to say BOOM
ENTRYPOINT [ "/bin/bash", "/tmp/run.sh" ]