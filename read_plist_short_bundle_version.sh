#!/bin/bash
# set -ex

read_dom() {
  local IFS=\>
  read -d \< ENTITY CONTENT
}

function readShortBundleVersion() {
	local INFO_PLIST_PATH=$1
	local __resultvar=$2

	local result=""
	local CFBundleShortVersionStringKey=false
	
	while read_dom; do
		if [[ $CFBundleShortVersionStringKey == true ]]; then
		    if [ $ENTITY = "string" ]; then
      			result=$CONTENT
      			CFBundleShortVersionStringKey=false
			fi
  		fi
		
		if [[ $CONTENT == "CFBundleShortVersionString" ]]; then
			CFBundleShortVersionStringKey=true
		fi
	done <"$INFO_PLIST_PATH"
	
	eval $__resultvar="'$result'"
}

"$@"
