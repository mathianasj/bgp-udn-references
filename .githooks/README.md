# Git Hooks

This directory contains git hooks to enforce project policies.

## Setup

To use these hooks, run:

```bash
git config core.hooksPath .githooks
```

## Hooks

### pre-commit
Prevents accidental commits of generated diagram files (*.svg, *.png, *.pdf).
These files should only be committed by GitHub Actions.
