#!/bin/bash
# set -ex

if [ -z "$bitrise_tag_info_plist_path" ]; then
  echo "bitrise_tag_info_plist_path is empty"
  exit 1
fi

# Copied from https://github.com/kawaiseb/bitrise-step-wetransfer/blob/master/step.sh
THIS_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $THIS_SCRIPT_DIR/read_bundle_version.sh readBundleVersion "$bitrise_tag_info_plist_path" "$bitrise_tag_xcodeproj_path" CFBundleVersion
if [ -z "$CFBundleVersion" ]; then
  echo "CFBundleVersion is empty"
  exit 1
fi

source $THIS_SCRIPT_DIR/read_short_bundle_version.sh readShortBundleVersion "$bitrise_tag_info_plist_path" "$bitrise_tag_xcodeproj_path" CFBundleShortVersionString
if [ -z "$CFBundleShortVersionString" ]; then
  echo "CFBundleShortVersionString is empty"
  exit 1
fi

source $THIS_SCRIPT_DIR/format_version_build.sh format $bitrise_tag_format $CFBundleVersion $CFBundleShortVersionString TAG_NAME
echo "New tag: $TAG_NAME"

git tag "$TAG_NAME" "$GIT_CLONE_COMMIT_HASH"

if [[ $use_lightweight_tag == "yes" ]]; then
  git push origin "$TAG_NAME"
else
  git push --tags
fi

exit 0

#
# --- Exit codes:
# The exit code of your Step is very important. If you return
#  with a 0 exit code `bitrise` will register your Step as "successful".
# Any non zero exit code will be registered as "failed" by `bitrise`.
