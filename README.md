# ELM-Project

- Front-end is developed in Elm language
- Back-end uses Phoenix framework
- Docker-compose configuration
- AWS Infrastructure scheme


## Pull requests (PR)

Pull requests in this project follow two conventions, you will need to use the templates available in the [ISSUE_TEMPLATE](.github/ISSUE_TEMPLATE) folder :

- Adding a new feature should use the [FEATURE_REQUEST](.github/ISSUE_TEMPLATE/feature_request.md) template.
- Reporting a bug should use the [BUG_REPORT](.github/ISSUE_TEMPLATE/bug_report.md)

If your merge request is still work in progress, please add "WIP: " (Work In Progress) in front of the title, therefor you inform the maintainers that your work is not done, and we can't merge it.

The naming of the PR should follow the same rules as the [COMMIT_CONVENTIONS](COMMIT_CONVENTIONS.md)


## Branch naming convention

You branch should have a name that reflects it's purpose.

It should use the same guidelines as [COMMIT_CONVENTIONS](COMMIT_CONVENTIONS.md) (`feat`, `fix`, `build`, `perf`, `docs`), followed by an underscore (`_`) and a very quick summary of the subject in [kebab case][1].

Example: `feat_add-image-tag-database-relation`.

[1]: https://medium.com/better-programming/string-case-styles-camel-pascal-snake-and-kebab-case-981407998841