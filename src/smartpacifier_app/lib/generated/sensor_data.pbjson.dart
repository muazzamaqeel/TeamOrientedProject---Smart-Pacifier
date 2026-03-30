///
//  Generated code. Do not modify.
//  source: sensor_data.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use iMUDataDescriptor instead')
const IMUData$json = const {
  '1': 'IMUData',
  '2': const [
    const {'1': 'temperature', '3': 1, '4': 1, '5': 2, '10': 'temperature'},
    const {'1': 'acc', '3': 2, '4': 1, '5': 11, '6': '.Protos.IMUData.MotionVector', '10': 'acc'},
    const {'1': 'gyro', '3': 3, '4': 1, '5': 11, '6': '.Protos.IMUData.MotionVector', '10': 'gyro'},
  ],
  '3': const [IMUData_MotionVector$json],
};

@$core.Deprecated('Use iMUDataDescriptor instead')
const IMUData_MotionVector$json = const {
  '1': 'MotionVector',
  '2': const [
    const {'1': 'x', '3': 1, '4': 1, '5': 2, '10': 'x'},
    const {'1': 'y', '3': 2, '4': 1, '5': 2, '10': 'y'},
    const {'1': 'z', '3': 3, '4': 1, '5': 2, '10': 'z'},
  ],
};

/// Descriptor for `IMUData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iMUDataDescriptor = $convert.base64Decode('CgdJTVVEYXRhEiAKC3RlbXBlcmF0dXJlGAEgASgCUgt0ZW1wZXJhdHVyZRIuCgNhY2MYAiABKAsyHC5Qcm90b3MuSU1VRGF0YS5Nb3Rpb25WZWN0b3JSA2FjYxIwCgRneXJvGAMgASgLMhwuUHJvdG9zLklNVURhdGEuTW90aW9uVmVjdG9yUgRneXJvGjgKDE1vdGlvblZlY3RvchIMCgF4GAEgASgCUgF4EgwKAXkYAiABKAJSAXkSDAoBehgDIAEoAlIBeg==');
@$core.Deprecated('Use pPGDataDescriptor instead')
const PPGData$json = const {
  '1': 'PPGData',
  '2': const [
    const {'1': 'sensor_id', '3': 1, '4': 1, '5': 5, '10': 'sensorId'},
    const {'1': 'led_1', '3': 2, '4': 1, '5': 5, '10': 'led1'},
    const {'1': 'led_2', '3': 3, '4': 1, '5': 5, '10': 'led2'},
    const {'1': 'led_3', '3': 4, '4': 1, '5': 5, '10': 'led3'},
    const {'1': 'temperature', '3': 5, '4': 1, '5': 2, '10': 'temperature'},
  ],
};

/// Descriptor for `PPGData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pPGDataDescriptor = $convert.base64Decode('CgdQUEdEYXRhEhsKCXNlbnNvcl9pZBgBIAEoBVIIc2Vuc29ySWQSEwoFbGVkXzEYAiABKAVSBGxlZDESEwoFbGVkXzIYAyABKAVSBGxlZDISEwoFbGVkXzMYBCABKAVSBGxlZDMSIAoLdGVtcGVyYXR1cmUYBSABKAJSC3RlbXBlcmF0dXJl');
@$core.Deprecated('Use aIRFLOWDataDescriptor instead')
const AIRFLOWData$json = const {
  '1': 'AIRFLOWData',
  '2': const [
    const {'1': 'voltage10k_l', '3': 1, '4': 1, '5': 5, '10': 'voltage10kL'},
    const {'1': 'voltage10k_r', '3': 2, '4': 1, '5': 5, '10': 'voltage10kR'},
    const {'1': 'voltage10k_e', '3': 3, '4': 1, '5': 5, '10': 'voltage10kE'},
    const {'1': 'raw_l', '3': 4, '4': 1, '5': 13, '10': 'rawL'},
    const {'1': 'raw_r', '3': 5, '4': 1, '5': 13, '10': 'rawR'},
    const {'1': 'raw_e', '3': 6, '4': 1, '5': 13, '10': 'rawE'},
    const {'1': 'temp_l', '3': 7, '4': 1, '5': 2, '10': 'tempL'},
    const {'1': 'temp_r', '3': 8, '4': 1, '5': 2, '10': 'tempR'},
    const {'1': 'temp_e', '3': 9, '4': 1, '5': 2, '10': 'tempE'},
  ],
};

/// Descriptor for `AIRFLOWData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List aIRFLOWDataDescriptor = $convert.base64Decode('CgtBSVJGTE9XRGF0YRIhCgx2b2x0YWdlMTBrX2wYASABKAVSC3ZvbHRhZ2UxMGtMEiEKDHZvbHRhZ2UxMGtfchgCIAEoBVILdm9sdGFnZTEwa1ISIQoMdm9sdGFnZTEwa19lGAMgASgFUgt2b2x0YWdlMTBrRRITCgVyYXdfbBgEIAEoDVIEcmF3TBITCgVyYXdfchgFIAEoDVIEcmF3UhITCgVyYXdfZRgGIAEoDVIEcmF3RRIVCgZ0ZW1wX2wYByABKAJSBXRlbXBMEhUKBnRlbXBfchgIIAEoAlIFdGVtcFISFQoGdGVtcF9lGAkgASgCUgV0ZW1wRQ==');
@$core.Deprecated('Use pTDataDescriptor instead')
const PTData$json = const {
  '1': 'PTData',
  '2': const [
    const {'1': 'temperature', '3': 1, '4': 1, '5': 2, '10': 'temperature'},
    const {'1': 'pressure', '3': 2, '4': 1, '5': 2, '10': 'pressure'},
  ],
};

/// Descriptor for `PTData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pTDataDescriptor = $convert.base64Decode('CgZQVERhdGESIAoLdGVtcGVyYXR1cmUYASABKAJSC3RlbXBlcmF0dXJlEhoKCHByZXNzdXJlGAIgASgCUghwcmVzc3VyZQ==');
