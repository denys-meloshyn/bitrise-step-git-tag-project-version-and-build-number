#!/bin/bash
# set -ex

read_dom() {
  local IFS=\>
  read -d \< ENTITY CONTENT
}

function readShortBundleVersion() {
	local INFO_PLIST_PATH=$1
	local XCODE_PATH=$2
	local __resul_short_bundle_version=$3

	local short_bundle_version_result=""
	
	source ./read_plist_short_bundle_version.sh readShortBundleVersion "$INFO_PLIST_PATH" short_bundle_version_result
	if [ -z "$short_bundle_version_result" ]; then
		echo "Plist CFBundleShortVersionString is empty"
		exit 1
	fi

	if [[ $short_bundle_version_result == *MARKETING_VERSION* ]]; then
		echo "Exctract version number from xcodeproj"

		if [ -z "$XCODE_PATH" ]; then
			echo "xcodeproj path is empty"
			exit 1
		fi

		local MARKETING_VERSION=""
		local LINES=$(sed -n '/MARKETING_VERSION/=' "$bitrise_tag_xcodeproj_path/project.pbxproj")
  		
		for LINE in $LINES; do
			MARKETING_VERSION=$(sed -n "$LINE"p "$bitrise_tag_xcodeproj_path"/project.pbxproj)
			MARKETING_VERSION="${MARKETING_VERSION#*= }"
			MARKETING_VERSION="${MARKETING_VERSION%;}"
		done

		if [ -z "$MARKETING_VERSION" ]; then
			echo "MARKETING_VERSION is empty"
			exit 1
		fi

		short_bundle_version_result=$MARKETING_VERSION
	fi
	
	eval $__resul_short_bundle_version="'$short_bundle_version_result'"
}

"$@"