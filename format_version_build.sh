#!/bin/bash
#set -ex

function format() {
	local TAG_FORMAT=$1
	local CFBundleVersion=$2
	local CFBundleShortVersionString=$3
	local __resultvar=$4

	local RESULT_TAG_NAME=""

	if [ -z "$TAG_FORMAT" ]; then
  		printf -v RESULT_TAG_NAME "v%s(%s)" "$CFBundleShortVersionString" "$CFBundleVersion"
	else
  		if [[ $TAG_FORMAT == *"_VERSION_"* ]] || [[ $TAG_FORMAT == *"_BUILD_"* ]]; then
  			if [[ $TAG_FORMAT == *"_VERSION_"* ]] && [[ $TAG_FORMAT == *"_BUILD_"* ]]; then
	    		name="${TAG_FORMAT//_VERSION_/$CFBundleShortVersionString}"
	    		name="${name//_BUILD_/$CFBundleVersion}"
	    
    			printf -v RESULT_TAG_NAME "$name"
    		else 
    			if [[ $TAG_FORMAT == *"_VERSION_"* ]]; then
    				name="${TAG_FORMAT//_VERSION_/$CFBundleShortVersionString}"
    			else
    				name="${TAG_FORMAT//_BUILD_/$CFBundleVersion}"
    			fi
    	
    			printf -v RESULT_TAG_NAME "$name"
    		fi
  		else
    		# Support previous integration
    		printf -v RESULT_TAG_NAME "v%s(%s)" "$CFBundleShortVersionString" "$CFBundleVersion"
  		fi
	fi

	eval $__resultvar="'$RESULT_TAG_NAME'"
}

"$@"