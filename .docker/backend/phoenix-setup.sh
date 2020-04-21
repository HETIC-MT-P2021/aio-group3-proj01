#!/usr/bin/env bash

mix deps.get # install project depencies
mix ecto.create
mix ecto.migrate
exec mix phx.server