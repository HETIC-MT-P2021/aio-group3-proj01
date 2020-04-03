FROM elixir:latest

LABEL maintainer="Edouin Vautier, Jason Gauvin, Jack Maarek <https://github.com/HETIC-MT-P2021/aio-group3-proj01>"


RUN mix local.hex --force &&\
    mix local.rebar --force &&\
    mix archive.install hex phx_new 1.4.16 --force

RUN apt-get update && \
  ## install inotify-tool for phoenix hot reload
  apt-get install -y inotify-tools && \
  # Install postgres client
  apt-get install -y postgresql-client && \
  # Clear apt cache
   rm -rf /var/lib/apt/lists/*

WORKDIR /backend

EXPOSE 4000