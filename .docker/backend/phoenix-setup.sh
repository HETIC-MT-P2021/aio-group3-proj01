#!/usr/bin/env bash

mix deps.get # install project depencies
mix ecto.migrate  # migrate your database if Ecto is used
exec mix phx.server