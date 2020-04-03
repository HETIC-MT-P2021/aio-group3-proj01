# Commit Convention

The `Tag` should be in the list above

The `Scope` should define the context of the affected changes.

The `Message` should not be confused with git commit message.

The `Tag` is one of the following:

- `Build:`-Changes that affect the build system or external dependencies (docker, npm, make…)

- `CI:`-Changes concerning the integration or configuration files and scripts (Travis, Ansible, BrowserStack ...)

- `Feat:`-Added new functionality

- `Fix:`-Bug fix

- `Perf:`-Performance improvement

- `Refactor:`-Modifications which brings neither new functionality nor performance improvement

- `Style:`-Changes that brings no functional or semantic alteration (indentation, formatting, adding space, renaming of a variable ...)

- `Upgrade:`-Internal dependency upgrade 

- `Docs:`-Writing or updating documentation

- `Test:`-Adding or modifying tests

- The `scope` should define the context of the affected changes.

- The `message` summaries description of the change in one sentence.

Examples:

```
Feat (frontend): Added /category route to access images by category.
Fix (database): Added migration to correct category structure.
CI (backend): Added linter tests
```
