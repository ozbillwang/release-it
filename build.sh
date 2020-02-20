#!/usr/bin/env bash

set -e

LATEST_TAG=$(git ls-remote --tags origin |awk -F \/ '{print $NF}'|grep ^1.0. |sort -Vr|head -1)
if [[ -z "${LATEST_TAG}" ]]
then
    NEXT_TAG="1.0.0"
else
    NEXT_TAG=$(docker run --rm alpine/semver:5.5.0 semver -c -i patch ${LATEST_TAG})
fi
echo ${NEXT_TAG}

if [[ "$TRAVIS_BRANCH" == "master" ]]; then
  # push the tag
  # mkdir /root/.ssh
  # chmod 600 /root/.ssh
  # ssh-keyscan github.com >> /root/.ssh/known_hosts
  echo "Set github Username & Email"
  git config user.name "ci"
  git config user.email "ci"
  echo "Create & Push Tag"
  git tag ${NEXT_TAG}
  git push origin ${NEXT_TAG}
fi
