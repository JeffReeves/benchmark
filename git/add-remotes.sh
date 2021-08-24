#!/bin/bash
# purpose: add all remotes for repo
# author: Jeff Reeves

# define repository's stub for the URL
REPO_STUB='benchmark'

# create the repo directory on bridges
ssh git@bridges "mkdir /git/${REPO_STUB}.git && cd /git/${REPO_STUB}.git && git config --global init.defaultBranch main && git init --bare && sed -i 's/master/main/' /git/rpi4-custom-os.git/HEAD"

# add bridges to git remote list
git remote add bridges git@bridges:/git/${REPO_STUB}.git

# add gitlab to git remote list
git remote add gitlab git@gitlab.com:JeffReeves/${REPO_STUB}.git

# add github to git remote list
git remote add github git@github.com:JeffReeves/${REPO_STUB}.git

# update origin to bridges
git remote set-url origin git@bridges:/git/${REPO_STUB}.git

# view all remotes
git remote -v

# open settings for gitlab and github in browser
explorer.exe "https://gitlab.com/JeffReeves/${REPO_STUB}/-/settings/repository"
explorer.exe "https://gitlab.com/JeffReeves/${REPO_STUB}/-/branches"
explorer.exe "https://github.com/JeffReeves/${REPO_STUB}/settings/branches"
explorer.exe "https://github.com/JeffReeves/${REPO_STUB}/branches"
