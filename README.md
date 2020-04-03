# ELM-Project

- Front-end is developed in Elm language
- Back-end uses Phoenix framework
- Docker-compose configuration
- AWS Infrastructure scheme

## Requirements
If you use docker you will only need:
* Docker;
* Docker-Compose;

If not, to run this project, you will need to install the following dependencies on your system:

- [Elm](https://guide.elm-lang.org/install/elm.html)
- [Elixir](https://elixir-lang.org/install.html)
- [Phoenix](https://hexdocs.pm/phoenix/installation.html)
- [PostgreSQL](https://www.postgresql.org/download/macosx/)

## Project setup

Without docker : 

To setup the project refer to both [documentation](#featured-documentation)

With docker : 

Refer to the [DOCKER.md](DOCKER.md) for setup


## Development process

1. Most of the time assign a ticket on the [application board](https://github.com/JackMaarek/Elm-project/projects/2) to you. If it is not the case and you are told to do it yourself, assign the github ticket to you. 
2. When you start working on the ticket, move the concerned ticket to `In Progress`.
3. Create a branch specifically for this ticket with a name that follows the [conventions specified below](#branch-naming-convention).
4. Commit regularly at each significant step with unambiguous commit messages (see [COMMIT_CONVENTIONS](COMMIT_CONVENTIONS.md) file).
5. Create a merge request that follows the [conventions specified below](#pull-requests-pr) to the develop branch.
6. On the [appplication board](https://github.com/JackMaarek/Elm-project/projects/2), move the ticket to the status `In Review`
7. Assign the merge request to a maintainer
8. It may take some back and forth before your pull request is validated
9. Your pull request will then be merged into the develop branch and the concerned ticket will be moved to `Done`

## Pull requests (PR)

Pull requests in this project follow two conventions, you will need to use the templates available in the [ISSUE_TEMPLATE](.github/ISSUE_TEMPLATE) folder :

- Adding a new feature should use the [FEATURE_REQUEST](.github/ISSUE_TEMPLATE/FEATURE_REQUEST.md) template.
- Reporting a bug should use the [BUG_REPORT](.github/ISSUE_TEMPLATE/BUG_REPORT.md) template.

If your merge request is still work in progress, please add "WIP: " (Work In Progress) in front of the title, therefor you inform the maintainers that your work is not done, and we can't merge it.

The naming of the PR should follow the same rules as the [COMMIT_CONVENTIONS](COMMIT_CONVENTIONS.md)


## Branch naming convention

You branch should have a name that reflects it's purpose.

It should use the same guidelines as [COMMIT_CONVENTIONS](COMMIT_CONVENTIONS.md) (`feat`, `fix`, `build`, `perf`, `docs`), followed by an underscore (`_`) and a very quick summary of the subject in [kebab case][1].

Example: `feat_add-image-tag-database-relation`.

## Git hooks
Git hooks are placed in `.git/hooks`. They are installed when you run `npm install`.

## Linter

## Continuous Integration (CI)

## Featured documentation

API documentation : [link](source/backend/README.md)

Front documentation : [link](source/frontend/README.md)

[1]: https://medium.com/better-programming/string-case-styles-camel-pascal-snake-and-kebab-case-981407998841
