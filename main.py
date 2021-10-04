import os

from read_bundle_version import read_bundle_version, read_short_bundle_version, format_result

info_plist_path = os.environ.get('bitrise_tag_info_plist_path', None)
xcode_path = os.environ.get('bitrise_tag_xcodeproj_path', None)
xcworkspace_path = os.environ.get('bitrise_tag_xcworkspace_path', None)
scheme = os.environ.get('bitrise_tag_xcworkspace_scheme', None)
config = os.environ.get('bitrise_tag_xcconfig_name', None)
input_format = os.environ.get('bitrise_tag_format', None)

bundle_version = read_bundle_version(info_plist_path=info_plist_path,
                                     xcode_path=xcode_path,
                                     xcworkspace_path=xcworkspace_path,
                                     scheme=scheme,
                                     config=config)

short_bundle_version = read_short_bundle_version(info_plist_path=info_plist_path,
                                                 xcode_path=xcode_path,
                                                 xcworkspace_path=xcworkspace_path,
                                                 scheme=scheme,
                                                 config=config)

print(format_result(input_format=input_format, bundle_version=bundle_version, short_version=short_bundle_version))
