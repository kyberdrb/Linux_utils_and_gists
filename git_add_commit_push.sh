#!/bin/sh

GIT_REPO_PATH="${1}"
COMMIT_MESSAGE="${2}"
COMMIT_DESCIPTION="${3}"

git -C "${GIT_REPO_PATH}" status
read
EDITOR=cat git -C "${GIT_REPO_PATH}" diff
read
git -C "${GIT_REPO_PATH}" add --all
git -C "${GIT_REPO_PATH}" commit --message "${COMMIT_MESSAGE}" --message "${COMMIT_DESCRIPTION}"
git -C "${GIT_REPO_PATH}" push
