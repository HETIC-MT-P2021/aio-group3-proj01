#  Docker Usage

## Services 
The stack uses Docker and Docker-compose to run 4 services:

Elm - Front-end container
Elixir - Back-end container to run mix commands and install the phoenix framework
Postgres - Database system 

## Setup

1. Move your terminal in the root directory of the project.
2. Copy the `.env.dist` to `.env.local and populate the missing variables.
3. Run `docker-compose up --build -d` The flag `-d ` stands for detached if you don't want to have all the docker logs. 
4. Access to the frontend app through `http://localhost:3000`

> Note: If you already build the project once you don't need to add the `--build` flag. You will only need it some build changes are made
