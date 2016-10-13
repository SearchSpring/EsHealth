FROM ruby:2.1.10-alpine

RUN apk add --no-cache \ 
      bash \
      git \
      make \
      gcc \
      alpine-sdk \
      ruby-dev && \
    mkdir /tmp/dtemplate

COPY . /tmp/eshealth/

SHELL ["/bin/bash", "-c"]
RUN \
    cd /tmp/dtemplate/ && \
    bundle install && \
    rake spec && \
    rake install && \
    rake clobber

WORKDIR /data

ENTRYPOINT ["eshealth"]

CMD ["--path=/data","--version=1.0"]