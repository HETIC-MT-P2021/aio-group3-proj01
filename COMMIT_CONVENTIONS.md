# Commit Convention

`Tag` should not be confused with git tag.
`Message` should not be confused with git commit message.

The `Tag` is one of the following:

`Build:`-Changes that affect the build system or external dependencies (docker, npm, make…)
`CI:`-Changes concerning the integration or configuration files and scripts (Travis, Ansible, BrowserStack ...)
`Feat:`-Added new functionality
`Fix:`-Bug fix
`Perf:`-Performance improvement
`Refactor:`-Modifications which brings neither new functionality nor performance improvement
`Style:`-Changes that brings no functional or semantic alteration (indentation, formatting, adding space, renaming of a variable ...)
`Upgrade:`-Dependency upgrade 
`Docs:`-Writing or updating documentation
`Test:`-Adding or modifying tests

The `message` summaries description of the change in one sentence.

Examples

```none
Feat: Added two types of persistance method for picture management.
Perf: (databaseName) add caching for better performance.
CI: Added linter tests
```
