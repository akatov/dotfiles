# Templates

## Purpose

These serve three purposes:

### Dynamic Reusability

The obvious use-case for templates - generating dynamic content.

### Smaller files

When a single config file becomes to big to manage, its source state can be broken down into smaller chunks as templates.

### Organistaion by Purpose

Basically combining the above two purposes - organise files by domain first directories (e.g. programming Clojure), then defining things that can be re-used across configurations for different programs (e.g. keybindings for Emacs and VS Code).

## Conventions

Files starting with `_` are **dynamic** templates and are thus likely used by more than one other template.
All other files are simply included and may include other templates.
