#!/bin/bash
# set -ex

source ./read_bundle_version.sh readBundleVersion "./_tmp/Info.plist" "./_tmp/Test.xcodeproj" CFBundleVersion
if [ "$CFBundleVersion" != "1" ]; then
	echo "wrong result: $CFBundleVersion"
	exit 1
fi

source ./read_bundle_version.sh readBundleVersion "./_tmp/Info space name.plist" "./_tmp/Test.xcodeproj" CFBundleVersion
if [ "$CFBundleVersion" != "2" ]; then
	echo "wrong result: $CFBundleVersion"
	exit 1
fi

source ./read_bundle_version.sh readBundleVersion "./_tmp/Info_xcode_11.plist" "./_tmp/Test.xcodeproj" CFBundleVersion
if [ "$CFBundleVersion" != "2" ]; then
	echo "wrong result: $CFBundleVersion"
	exit 1
fi

echo "test passed"
exit 0
