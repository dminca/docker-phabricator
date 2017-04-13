#
# Docker image for the phabricator database
#

FROM debian:jessie
MAINTAINER Yvonnick Esnault <yvonnick@esnau.lt>

ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true \
    PHABRICATOR_VERSION=5aca529980
ENV BASE_URL=https://raw.githubusercontent.com/phacility/phabricator/${PHABRICATOR_VERSION}/resources/sql/

RUN set -x \
  && apt-get update -yqq \
  && apt-get install -y \
      curl \
      mysql-server \
  && sed -ie "s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf \
  && mkdir -vp /opt/phabricator/resources/sql/
WORKDIR /opt/phabricator/resources/sql/
RUN set -x \
  && curl -L -o stopwords.txt ${BASE_URL}/stopwords.txt \
  && curl -L -o quickstart.sql ${BASE_URL}/quickstart.sql \
  # Render template `quickstart.sql`. Reproduced from
  # src/infrastructure/storage/management/PhabricatorStorageManagementAPI.php
  && sed -ie 's/{$CHARSET}/utf8mb4/g' quickstart.sql \
  && sed -ie 's/{$CHARSET_SORT}/utf8mb4/g' quickstart.sql \
  && sed -ie 's/{$CHARSET_FULLTEXT}/utf8mb4/g' quickstart.sql \
  && sed -ie 's/{$COLLATE_TEXT}/utf8mb4_bin/g' quickstart.sql \
  && sed -ie 's/{$COLLATE_SORT}/utf8mb4_unicode_ci/g' quickstart.sql \
  && sed -ie 's/{$COLLATE_FULLTEXT}/utf8mb4_unicode_ci/g' quickstart.sql \
  && sed -ie 's/{$NAMESPACE}/default/g' quickstart.sql

ADD my-phabricator.cnf /etc/mysql/conf.d/my-phabricator.cnf

WORKDIR /opt/mysql

RUN set -x \
  && echo "init mysql admin user" \
  && mysql_install_db \
  && mysqld_safe & \
  # TODO: replace sleep with polling
  && sleep 10s \
  && echo "GRANT ALL ON *.* TO admin@'%' IDENTIFIED BY 'admin' WITH GRANT OPTION; FLUSH PRIVILEGES" | mysql \
  && cat /opt/phabricator/resources/sql/quickstart.sql | mysql \
  # TODO: create a default admin account
  # TODO: address setup issues described in /config/issue/
  && pkill -f mysqld

VOLUME  ["/var/lib/mysql"]
CMD mysqld_safe
