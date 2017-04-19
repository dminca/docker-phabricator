FROM wizdevops/alpine
MAINTAINER Daniel Andrei Minca <mandrei17@gmail.com>

RUN set -x \
	&& apk add --update --no-cache \
    git \
  && mkdir /app; cd /app \
  && for repo in libphutil arcanist phabricator; \
    do \
      git clone --branch stable https://github.com/phacility/${repo}.git; \
    done

