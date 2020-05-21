#!/bin/bash
# set -ex

source ./format_version_build.sh format "" "1" "1.0" TAG_NAME
if [ "$TAG_NAME" != "v1.0(1)" ]; then
	echo "wrong result: $TAG_NAME"
	exit 1
fi

source ./format_version_build.sh format "v_VERSION_(_BUILD_)" "1" "1.0" TAG_NAME
if [ "$TAG_NAME" != "v1.0(1)" ]; then
	echo "wrong result: $TAG_NAME"
	exit 1
fi

source ./format_version_build.sh format "build__BUILD_" "1" "" TAG_NAME
if [ "$TAG_NAME" != "build_1" ]; then
	echo "wrong result: $TAG_NAME"
	exit 1
fi

source ./format_version_build.sh format "v_VERSION_" "" "1.0" TAG_NAME
if [ "$TAG_NAME" != "v1.0" ]; then
	echo "wrong result: $TAG_NAME"
	exit 1
fi

echo "test passed"
exit 0
