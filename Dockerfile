FROM ruby:alpine3.20

ARG WORKDIR

ARG RUNTIME_PACKAGES="nodejs tzdata postgresql-dev postgresql git libxml2-dev libxslt-dev libc6-compat"
ARG DEV_PACKAGES="build-base curl-dev"

ENV HOME=/${WORKDIR} \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo

WORKDIR ${HOME}

COPY Gemfile* ./

RUN apk update && \
    apk upgrade && \
    apk add --no-cache ${RUNTIME_PACKAGES} && \
    apk add --virtual build-dependencies --no-cache ${DEV_PACKAGES} && \
    bundle config build.nokogiri --use-system-libraries && \
    bundle install -j4 && \
    apk del build-dependencies

COPY . ./
