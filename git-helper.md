# Git Helper

## Deletes stale remote-tracking branches

Deletes all stale remote-tracking branches under `origin`. These stale branches
have already been removed from the remote repository referenced by `origin`,
but are still locally available in `remotes/origin`.

With `--dry-run` option, report what branches will be pruned, but do not
actually prune them.

```sh
git remote prune origin --dry-run
git remote prune origin
```

## Modify commit message

```sh
git commit --amend --no-edit -m "xxx"
```

## List files in local repository

```sh
git ls-tree --full-tree -r HEAD
git ls-tree --full-tree -r --name-only HEAD
```
