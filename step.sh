#!/bin/bash
# set -ex

read_dom() {
  local IFS=\>
  read -d \< ENTITY CONTENT
}

CFBundleVersion=""
CFBundleVersionKey=false

CFBundleShortVersionString=""
CFBundleShortVersionStringKey=false

if [ -z "$bitrise_tag_info_plist_path" ]; then
  echo "bitrise_tag_info_plist_path is empty"
  exit 1
fi

while read_dom; do
  if [[ $CFBundleShortVersionStringKey == true ]]; then
    if [ $ENTITY = "string" ]; then
      CFBundleShortVersionString=$CONTENT
      CFBundleShortVersionStringKey=false
    fi
  fi

  if [[ $CFBundleVersionKey == true ]]; then
    if [ $ENTITY = "string" ]; then
      CFBundleVersion=$CONTENT
      CFBundleVersionKey=false
    fi
  fi

  if [[ $CONTENT == "CFBundleShortVersionString" ]]; then
    CFBundleShortVersionStringKey=true
  fi

  if [[ $CONTENT == "CFBundleVersion" ]]; then
    CFBundleVersionKey=true
  fi
done <$bitrise_tag_info_plist_path

if [ -z "$CFBundleShortVersionString" ]; then
  echo "CFBundleShortVersionString is empty"
  exit 1
fi

if [ -z "$CFBundleVersion" ]; then
  echo "CFBundleVersion is empty"
  exit 1
fi

if [[ $CFBundleShortVersionString == *MARKETING_VERSION* ]]; then
  echo "Exctract version number from xcodeproj"

  if [ -z "$bitrise_tag_xcodeproj_path" ]; then
    echo "bitrise_tag_xcodeproj_path is empty"
    exit 1
  fi

  MARKETING_VERSION=""
  LINES=$(sed -n '/MARKETING_VERSION/=' "$bitrise_tag_xcodeproj_path/project.pbxproj")
  for LINE in $LINES; do
    MARKETING_VERSION=$(sed -n "$LINE"p "$bitrise_tag_xcodeproj_path"/project.pbxproj)
    MARKETING_VERSION="${MARKETING_VERSION#*= }"
    MARKETING_VERSION="${MARKETING_VERSION%;}"
  done

  if [ -z "$MARKETING_VERSION" ]; then
    echo "MARKETING_VERSION is empty"
    exit 1
  fi

  CFBundleShortVersionString=$MARKETING_VERSION
fi

TAG_NAME=""

if [ -z "$bitrise_tag_format" ]; then
  printf -v TAG_NAME "v%s(%s)" "$CFBundleShortVersionString" "$CFBundleVersion"
else
  if [[ $bitrise_tag_format == *"_VERSION_"* ]]; then
    name="${bitrise_tag_format//_VERSION_/$CFBundleShortVersionString}"
    name="${name//_BUILD_/$CFBundleVersion}"
    printf -v TAG_NAME "$name"
  else
    # Support previous integration
    printf -v TAG_NAME "v%s(%s)" "$CFBundleShortVersionString" "$CFBundleVersion"
  fi
fi
echo "New tag: $TAG_NAME"

git checkout "$BITRISE_GIT_BRANCH"
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
