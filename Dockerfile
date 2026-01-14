FROM python:3.14.2-slim-trixie

RUN apt-get update \
    && apt-get -y install \
    git \
    procps \
    && apt-get clean \
    && rm -Rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man

# container user
RUN useradd -m \
    -s /bin/bash \
    -g users \
    python

# main application storage
RUN mkdir --mode=777 app
VOLUME /app
 
COPY --chmod=755 --chown=python:users util/ /home/python/util

# ----------------------------------------------------
# USER ZONE
USER python:users

WORKDIR /home/python/util

ENTRYPOINT [ "./init.sh" ]
