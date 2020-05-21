#!/bin/bash
# set -ex

read_dom() {
  local IFS=\>
  read -d \< ENTITY CONTENT
}

function readBundleVersion() {
	local INFO_PLIST_PATH=$1
	local __resultvar=$2
	
	local plist_result=""
	local CFBundleVersionKey=false
	
	while read_dom; do  		
		if [[ $CFBundleVersionKey == true ]]; then
			if [ $ENTITY = "string" ]; then
				plist_result=$CONTENT
				CFBundleVersionKey=false
			fi
		fi
		
		if [[ $CONTENT == "CFBundleVersion" ]]; then
			CFBundleVersionKey=true
		fi
	done <"$INFO_PLIST_PATH"
	
	eval $__resultvar="'$plist_result'"
}

"$@"