FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
# install ubuntu packages
RUN apt-get update -q \
 && apt-get install -y \
    git \
    curl \
    locales \
    build-essential \
    autoconf \
    inotify-tools \
    libncurses5-dev \
    libwxgtk3.0-gtk3-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libpng-dev \
    libssh-dev \
    unixodbc-dev \
    m4 \
    xsltproc \
    fop \
    libxml2-utils \
    openjdk-11-jdk \
 && apt-get clean

# install asdf and its plugins
# ASDF will only correctly install plugins into the home directory as of 0.7.5
# so .... Just go with it.
ENV ASDF_ROOT /root/.asdf
ENV PATH "${ASDF_ROOT}/bin:${ASDF_ROOT}/shims:$PATH"

RUN git clone https://github.com/asdf-vm/asdf.git ${ASDF_ROOT} --branch v0.7.5  \
 && asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang \
 && asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir

# set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
# install erlang
ENV ERLANG_VERSION 23.2.1
RUN asdf install erlang ${ERLANG_VERSION} \
 && asdf global erlang ${ERLANG_VERSION}

# install elixir
ENV ELIXIR_VERSION 1.10.4-otp-23
RUN asdf install elixir ${ELIXIR_VERSION} \
 && asdf global elixir ${ELIXIR_VERSION}

# install local Elixir hex and rebar
RUN mix local.hex --force \
 && mix local.rebar --force
