#
# Docker image for running https://github.com/phacility/phabricator
#

FROM debian:jessie
MAINTAINER Yvonnick Esnault <yvonnick@esnau.lt>

ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true \
    PHABRICATOR_COMMIT=79f2e81f38 \
    ARCANIST_COMMIT=c304c4e045 \
    LIBPHUTIL_COMMIT=55f554b618

RUN set -x \
  && apt-get update -yqq \
  && apt-get install -y \
    git \
    apache2 \
    curl \
    libapache2-mod-php5 \
    libmysqlclient18 \
    mercurial \
    mysql-client \
    php-apc \
    php5 \
    php5-apcu \
    php5-cli \
    php5-curl \
    php5-gd \
    php5-json \
    php5-ldap \
    php5-mysql \
    python-pygments \
    sendmail \
    subversion \
    tar \
    sudo \
  && apt-get clean -y \
  && rm -rfv /var/lib/apt/lists/*

WORKDIR /opt
RUN set -x \
  && mkdir -v phabricator arcanist libphutil \
  && curl -L https://github.com/phacility/phabricator/archive/${PHABRICATOR_COMMIT}.tar.gz | tar xzf - --strip-components 1 -C phabricator \
  && curl -L https://github.com/phacility/arcanist/archive/${ARCANIST_COMMIT}.tar.gz | tar xzf - --strip-components 1 -C arcanist \
  && curl -L https://github.com/phacility/libphutil/archive/${LIBPHUTIL_COMMIT}.tar.gz | tar xzf - --strip-components 1 -C libphutil \

  # Setup apache
  && a2enmod rewrite
ADD phabricator.conf /etc/apache2/sites-available/phabricator.conf
RUN ln -s /etc/apache2/sites-available/phabricator.conf \
        /etc/apache2/sites-enabled/phabricator.conf && \
    rm -f /etc/apache2/sites-enabled/000-default.conf

  # Setup phabricator
RUN mkdir -p /opt/phabricator/conf/local /var/repo
ADD local.json /opt/phabricator/conf/local/local.json
RUN sed -e 's/post_max_size =.*/post_max_size = 32M/' \
          -e 's/upload_max_filesize =.*/upload_max_filesize = 32M/' \
          -e 's/;opcache.validate_timestamps=.*/opcache.validate_timestamps=0/' \
          -i /etc/php5/apache2/php.ini \
  && ln -s /usr/lib/git-core/git-http-backend /opt/phabricator/support/bin \
  && /opt/phabricator/bin/config set phd.user "root" \
  && echo "www-data ALL=(ALL) SETENV: NOPASSWD: /opt/phabricator/support/bin/git-http-backend" >> /etc/sudoers

EXPOSE  80
ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["start-server"]
