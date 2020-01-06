https://github.com/go-gitea/gitea/issues/new


- Gitea version (or commit ref): `1.8.3+1-ge94a84248`
- Git version: `2.11.0`
- Operating system: Debian 9
- Database (use `[x]`):
  - [ ] PostgreSQL
  - [ ] MySQL
  - [ ] MSSQL
  - [x] SQLite
- Can you reproduce the bug at https://try.gitea.io:
  - [ ] Yes (provide example URL)
  - [ ] No
  - [x] Not relevant
- Log gist: n/a

## Description
While attempting to perform a `gitea dump`, I discovered several things that seem bug-adjacent.

---
In no particular order:
- non-absolute path(s) for the `--config` option fails:
```
gitea@host:~/run$ gitea dump --config custom/conf/app.ini --tempdir /var/tmp/gitea
2019/07/15 06:26:45 [W] Custom config '/usr/local/bin/custom/custom/conf/app.ini' not found, ignore this if you're running first time
2019/07/15 06:26:45 [...s/setting/setting.go:725 NewContext()] [E] failed to create '/usr/local/bin/custom/custom/conf/app.ini': mkdir /usr/local/bin/custom: permission denied
gitea@host:~/run$
```

- silent output when running the command fails:
```

```

---

## Screenshots
n/a - see body of report





# code

## Get the service start command
giteaStart=$(cat /etc/systemd/system/gitea.service | grep xecStart | cut -d'=' -f2)
gitea


Because [gogs]() just moves too slowly, and nothing else (so far) gives me the freedom and ease of deployment that I'd like.

# Appendices
https://golang.org/doc/install/source

Autobuild for the Gitea repository hosting software.
https://docs.gitea.io/en-us/install-from-source/#build
https://gitea.com/gitea/gitea_mirror.git

https://docs.gitea.io/en-us/backup-and-restore/

Dealing with directory permissions
find $(realpath ~/) -type d -exec chmod 770 {} \;
https://stackoverflow.com/questions/3740152/how-do-i-change-permissions-for-a-folder-and-all-of-its-subfolders-and-files-in
