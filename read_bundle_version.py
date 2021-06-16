import json
import os


def read_plist_value(key, info_plist_path):
    os.system("plutil -convert json {} -e json".format(info_plist_path))

    info_plist_json_path = info_plist_path.replace(".plist", ".json")
    with open(info_plist_json_path, "r") as f:
        data = json.load(f)

    return data[key]


def read_xcode_value(key, xcode_path, xcworkspace_path, scheme, config):
    if xcode_path is not None:
        stream = os.popen("xcodebuild -project {} -showBuildSettings -json".format(xcode_path))
    elif xcworkspace_path is not None:
        commands = [
            "xcodebuild",
            "-workspace {}".format(xcworkspace_path),
            "-scheme {}".format(scheme),
        ]

        if config is not None:
            commands += [
                "-configuration {}".format(config)
            ]

        commands += [
            "-showBuildSettings",
            "-json"
        ]

        command = ' '.join(commands)
        stream = os.popen(command)
    else:
        exit("Path is not provided")

    xcode_dict = json.loads(stream.read())
    xcode_dict = xcode_dict[0]

    return xcode_dict['buildSettings'][key]


def read_from_plist_or_xcode(plist_key, xcode_key, info_plist_path, xcode_path, xcworkspace_path, scheme, config):
    os.system("plutil -convert json {} -e json".format(info_plist_path))

    value = read_plist_value(key=plist_key, info_plist_path=info_plist_path)

    if value.startswith('$('):
        value = read_xcode_value(key=xcode_key,
                                 xcode_path=xcode_path,
                                 xcworkspace_path=xcworkspace_path,
                                 scheme=scheme,
                                 config=config)

    return value

# read_from_plist_or_xcode(
#     plist_key='CFBundleVersion',
#     xcode_key='MARKETING_VERSION',
#     info_plist_path='/Users/denys/Projects/bitrise-step-git-tag-project-version-and-build-number/_tmp'
#                     '/test_info_plist/Test/Info.plist',
#     xcode_path=None,
#     xcworkspace_path=None,
#     scheme=None,
#     config=None)
#
# read_from_plist_or_xcode(
#     plist_key='CFBundleVersion',
#     xcode_key='MARKETING_VERSION',
#     info_plist_path='/Users/denys/Projects/bitrise-step-git-tag-project-version-and-build-number/_tmp'
#                     '/test_build_settings/Test/Info.plist',
#     xcode_path='/Users/denys/Projects/bitrise-step-git-tag-project-version-and-build-number/_tmp'
#                '/test_build_settings/Test.xcodeproj',
#     xcworkspace_path=None,
#     scheme=None,
#     config=None)
#
# read_from_plist_or_xcode(
#     plist_key='CFBundleVersion',
#     xcode_key='MARKETING_VERSION',
#     info_plist_path='/Users/denys/Projects/bitrise-step-git-tag-project-version-and-build-number/_tmp'
#                     '/test_workspace_config/Test/Info.plist',
#     xcode_path=None,
#     xcworkspace_path='/Users/denys/Projects/bitrise-step-git-tag-project-version-and-build-number/_tmp'
#                      '/test_workspace_config/Test.xcworkspace',
#     scheme='Test',
#     config='Config')
