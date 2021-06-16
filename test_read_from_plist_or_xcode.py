from unittest import TestCase

from read_bundle_version import read_from_plist_or_xcode


class Test(TestCase):
    def test_read_from_plist(self):
        result = read_from_plist_or_xcode(
            plist_key='CFBundleVersion',
            xcode_key=None,
            info_plist_path='./_tmp/test_info_plist/Test/Info.plist',
            xcode_path=None,
            xcworkspace_path=None,
            scheme=None,
            config=None)
        self.assertEqual(result, "1")

    def test_read_from_xcode_build_settings(self):
        result = read_from_plist_or_xcode(
            plist_key='CFBundleVersion',
            xcode_key='MARKETING_VERSION',
            info_plist_path='./_tmp/test_build_settings/Test/Info.plist',
            xcode_path='./_tmp/test_build_settings/Test.xcodeproj',
            xcworkspace_path=None,
            scheme=None,
            config=None)
        self.assertEqual(result, "1.0")

    def test_read_from_xcode_config(self):
        result = read_from_plist_or_xcode(
            plist_key='CFBundleVersion',
            xcode_key='MARKETING_VERSION',
            info_plist_path='./_tmp/test_config/Test/Info.plist',
            xcode_path='./_tmp/test_config/Test.xcodeproj',
            xcworkspace_path=None,
            scheme=None,
            config=None)
        self.assertEqual(result, "1")

    def test_read_from_workspace_config(self):
        result = read_from_plist_or_xcode(
            plist_key='CFBundleVersion',
            xcode_key='MARKETING_VERSION',
            info_plist_path='./_tmp/test_workspace_config/Test/Info.plist',
            xcode_path='./_tmp/test_workspace_config/Test.xcodeproj',
            xcworkspace_path=None,
            scheme=None,
            config=None)
        self.assertEqual(result, "1")
