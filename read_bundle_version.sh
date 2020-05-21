#!/bin/bash
# set -ex

read_dom() {
  local IFS=\>
  read -d \< ENTITY CONTENT
}

function readBundleVersion() {
	local INFO_PLIST_PATH=$1
	local XCODE_PATH=$2
	local __resultvar=$3

	local bundle_version_result=""
	
	source ./read_plist_bundle_version.sh readBundleVersion "$INFO_PLIST_PATH" bundle_version_result
	if [ -z "$bundle_version_result" ]; then
  		echo "Plist CFBundleVersion is empty"
  		exit 1
	fi

	if [[ $bundle_version_result == *CURRENT_PROJECT_VERSION* ]]; then
  		echo "Exctract build number from xcodeproj"

  		if [ -z "$XCODE_PATH" ]; then
    		echo "xcodeproj path is empty"
    		exit 1
  		fi

  		local CURRENT_PROJECT_VERSION=""
  		local LINES=$(sed -n '/CURRENT_PROJECT_VERSION/=' "$XCODE_PATH/project.pbxproj")

  		for LINE in $LINES; do
    		CURRENT_PROJECT_VERSION=$(sed -n "$LINE"p "$XCODE_PATH"/project.pbxproj)
    		CURRENT_PROJECT_VERSION="${CURRENT_PROJECT_VERSION#*= }"
    		CURRENT_PROJECT_VERSION="${CURRENT_PROJECT_VERSION%;}"
  		done

  		if [ -z "$CURRENT_PROJECT_VERSION" ]; then
    		echo "CURRENT_PROJECT_VERSION is empty"
    		exit 1
  		fi

  		bundle_version_result=$CURRENT_PROJECT_VERSION
	fi
	
	eval $__resultvar="'$bundle_version_result'"
}

"$@"