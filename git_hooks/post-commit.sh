#!/bin/bash

# Extract commit type and description.
commit_type=$(git log -1 --pretty=%B | cut -d ":" -f 1)
commit_desc=$(git log -1 --pretty=%B | cut -d ":" -f 2-)

entry=""

case "$commit_type" in
  feat)
    entry="\n- New Feature:${commit_desc}"
    ;;
  fix)
    entry="\n- Bug Fixes:${commit_desc}"
    ;;
  perf)
    entry="\n- Improvements:${commit_desc}"
    ;;
  docs)
    entry="\n- Documentation:${commit_desc}"
    ;;
  *)
    entry="\n- Other:${commit_desc}"
    ;;
esac

# Skip the entry for non-user impacting commits.
if [[ "$commit_type" =~ ^(chore|style|refactor|test|build)$ ]]; then
  exit 0
fi

# check if RELEASE.md exists and create if not
[ -e RELEASE.md ] || touch RELEASE.md

# insert at the top of the RELEASE.md file
printf '%s\n' "1i" "${entry}\n" "." w | ed -s RELEASE.md

# Amend the commit to include changes to RELEASE.md.
git add RELEASE.md
GIT_COMMITTER_DATE="$(git log -1 --pretty=%cD)" git commit --amend --no-edit --date "$(git log -1 --pretty=%cD)"
