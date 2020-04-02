FROM elixir:latest

RUN apt-get update && \
  ## install inotify-tool for phoenix hot reload
  apt-get install -y inotify-tools && \
  # Install postgres client
  apt-get install -y postgresql-client && \
  # Clear apt cache
   rm -rf /var/lib/apt/lists/*

RUN mkdir /backend
COPY . /backend
WORKDIR /backend/api_app

# Install hex package manager
# By using --force, we don’t need to type “Y” to confirm the installation
RUN mix local.hex --force && \
    mix local.rebar --force && \
# Install project dependencies
    mix deps.get

# Compile the project
RUN mix do compile
