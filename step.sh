#!/bin/bash
# set -ex

read_dom () {
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
	if [[ $CFBundleShortVersionStringKey = true ]]; then 
		if [ $ENTITY = "string" ] ; then
		    CFBundleShortVersionString=$CONTENT
	    	CFBundleShortVersionStringKey=false
		fi
    fi
    
    if [[ $CFBundleVersionKey = true ]]; then 
		if [ $ENTITY = "string" ] ; then
		    CFBundleVersion=$CONTENT
	    	CFBundleVersionKey=false
		fi
    fi

    if [[ $CONTENT = "CFBundleShortVersionString" ]] ; then
    	CFBundleShortVersionStringKey=true
    fi
    
    if [[ $CONTENT = "CFBundleVersion" ]] ; then
    	CFBundleVersionKey=true
    fi
done < $bitrise_tag_info_plist_path

if [ -z "$CFBundleShortVersionString" ]; then
    echo "CFBundleShortVersionString is empty"
    exit 1
fi

if [ -z "$CFBundleVersion" ]; then
    echo "CFBundleVersion is empty"
    exit 1
fi

TAG_NAME=""

if [ -z "$bitrise_tag_format" ]; then
	printf -v TAG_NAME "v%s(%s)" "$CFBundleShortVersionString" "$CFBundleVersion"
else
	printf -v TAG_NAME "$bitrise_tag_format" "$CFBundleShortVersionString" "$CFBundleVersion"
fi
echo $TAG_NAME
git checkout "$BITRISE_GIT_BRANCH"
git tag -a "$TAG_NAME" "$GIT_CLONE_COMMIT_HASH" -m ""
git push --tags

exit 0

#
# --- Export Environment Variables for other Steps:
# You can export Environment Variables for other Steps with
#  envman, which is automatically installed by `bitrise setup`.
# A very simple example:
envman add --key EXAMPLE_STEP_OUTPUT --value 'the value you want to share'
# Envman can handle piped inputs, which is useful if the text you want to
# share is complex and you don't want to deal with proper bash escaping:
#  cat file_with_complex_input | envman add --KEY EXAMPLE_STEP_OUTPUT
# You can find more usage examples on envman's GitHub page
#  at: https://github.com/bitrise-io/envman

#
# --- Exit codes:
# The exit code of your Step is very important. If you return
#  with a 0 exit code `bitrise` will register your Step as "successful".
# Any non zero exit code will be registered as "failed" by `bitrise`.
