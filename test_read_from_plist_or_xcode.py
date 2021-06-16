from unittest import TestCase

from read_bundle_version import read_short_bundle_version, format_result


class Test(TestCase):
    def test_read_from_plist(self):
        result = read_short_bundle_version(
            info_plist_path='./_tmp/test_info_plist/Test/Info.plist',
            xcode_path=None,
            xcworkspace_path=None,
            scheme=None,
            config=None)
        self.assertEqual(result, "1.0")

    def test_read_from_xcode_build_settings(self):
        result = read_short_bundle_version(
            info_plist_path='./_tmp/test_build_settings/Test/Info.plist',
            xcode_path='./_tmp/test_build_settings/Test.xcodeproj',
            xcworkspace_path=None,
            scheme=None,
            config=None)
        self.assertEqual(result, "1.0")

    def test_read_from_xcode_config(self):
        result = read_short_bundle_version(
            info_plist_path='./_tmp/test_config/Test/Info.plist',
            xcode_path='./_tmp/test_config/Test.xcodeproj',
            xcworkspace_path=None,
            scheme=None,
            config=None)
        self.assertEqual(result, "1.0")

    def test_read_from_workspace_config(self):
        result = read_short_bundle_version(
            info_plist_path='./_tmp/test_workspace_config/Test/Info.plist',
            xcode_path=None,
            xcworkspace_path='./_tmp/test_workspace_config/Test.xcworkspace',
            scheme='Test',
            config='Config')
        self.assertEqual(result, "1.0")

    def test_no_input_format(self):
        self.assertEqual(format_result(input_format=None, bundle_version='1', short_version='1.0'), 'v1.0(1)')

    def test_legacy_format(self):
        self.assertEqual(format_result(input_format='v%s(%s)', bundle_version='1', short_version='1.0'), 'v1.0(1)')

    def test_both_input_format_parameters_exist(self):
        self.assertEqual(format_result(input_format='v_VERSION_(_BUILD_)', bundle_version='1', short_version='1.0'),
                         'v1.0(1)')

    def test_version_input_format_parameter_exist(self):
        self.assertEqual(format_result(input_format='v_VERSION_', bundle_version='1', short_version='1.0'),
                         'v1.0')

    def test_build_input_format_parameter_exist(self):
        self.assertEqual(format_result(input_format='_BUILD_', bundle_version='1', short_version='1.0'), '1')
