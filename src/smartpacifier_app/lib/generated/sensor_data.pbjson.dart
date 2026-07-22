///
//  Generated code. Do not modify.
//  source: sensor_data.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use sensorDataDescriptor instead')
const SensorData$json = const {
  '1': 'SensorData',
  '2': const [
    const {'1': 'pacifier_id', '3': 1, '4': 1, '5': 9, '10': 'pacifierId'},
    const {'1': 'sensor_type', '3': 2, '4': 1, '5': 9, '10': 'sensorType'},
    const {'1': 'sensor_group', '3': 3, '4': 1, '5': 9, '10': 'sensorGroup'},
    const {'1': 'data_map', '3': 4, '4': 3, '5': 11, '6': '.Protos.SensorData.DataMapEntry', '10': 'dataMap'},
  ],
  '3': const [SensorData_DataMapEntry$json],
};

@$core.Deprecated('Use sensorDataDescriptor instead')
const SensorData_DataMapEntry$json = const {
  '1': 'DataMapEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 12, '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `SensorData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sensorDataDescriptor = $convert.base64Decode('CgpTZW5zb3JEYXRhEh8KC3BhY2lmaWVyX2lkGAEgASgJUgpwYWNpZmllcklkEh8KC3NlbnNvcl90eXBlGAIgASgJUgpzZW5zb3JUeXBlEiEKDHNlbnNvcl9ncm91cBgDIAEoCVILc2Vuc29yR3JvdXASOgoIZGF0YV9tYXAYBCADKAsyHy5Qcm90b3MuU2Vuc29yRGF0YS5EYXRhTWFwRW50cnlSB2RhdGFNYXAaOgoMRGF0YU1hcEVudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgMUgV2YWx1ZToCOAE=');
@$core.Deprecated('Use iMUDataDescriptor instead')
const IMUData$json = const {
  '1': 'IMUData',
  '2': const [
    const {'1': 'temperature', '3': 1, '4': 1, '5': 2, '10': 'temperature'},
    const {'1': 'acc', '3': 2, '4': 1, '5': 11, '6': '.Protos.IMUData.MotionVector', '10': 'acc'},
    const {'1': 'gyro', '3': 3, '4': 1, '5': 11, '6': '.Protos.IMUData.MotionVector', '10': 'gyro'},
    const {'1': 'timestamp_ms', '3': 100, '4': 1, '5': 4, '10': 'timestampMs'},
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
final $typed_data.Uint8List iMUDataDescriptor = $convert.base64Decode('CgdJTVVEYXRhEiAKC3RlbXBlcmF0dXJlGAEgASgCUgt0ZW1wZXJhdHVyZRIuCgNhY2MYAiABKAsyHC5Qcm90b3MuSU1VRGF0YS5Nb3Rpb25WZWN0b3JSA2FjYxIwCgRneXJvGAMgASgLMhwuUHJvdG9zLklNVURhdGEuTW90aW9uVmVjdG9yUgRneXJvEiEKDHRpbWVzdGFtcF9tcxhkIAEoBFILdGltZXN0YW1wTXMaOAoMTW90aW9uVmVjdG9yEgwKAXgYASABKAJSAXgSDAoBeRgCIAEoAlIBeRIMCgF6GAMgASgCUgF6');
@$core.Deprecated('Use pPGDataDescriptor instead')
const PPGData$json = const {
  '1': 'PPGData',
  '2': const [
    const {'1': 'led', '3': 1, '4': 1, '5': 11, '6': '.Protos.PPGData.LedData', '10': 'led'},
    const {'1': 'temperature', '3': 2, '4': 1, '5': 11, '6': '.Protos.PPGData.TemperatureData', '10': 'temperature'},
    const {'1': 'sensor_id', '3': 3, '4': 1, '5': 5, '10': 'sensorId'},
    const {'1': 'timestamp_ms', '3': 100, '4': 1, '5': 4, '10': 'timestampMs'},
  ],
  '3': const [PPGData_LedData$json, PPGData_TemperatureData$json],
};

@$core.Deprecated('Use pPGDataDescriptor instead')
const PPGData_LedData$json = const {
  '1': 'LedData',
  '2': const [
    const {'1': 'led_1', '3': 1, '4': 1, '5': 5, '10': 'led1'},
    const {'1': 'led_2', '3': 2, '4': 1, '5': 5, '10': 'led2'},
    const {'1': 'led_3', '3': 3, '4': 1, '5': 5, '10': 'led3'},
  ],
};

@$core.Deprecated('Use pPGDataDescriptor instead')
const PPGData_TemperatureData$json = const {
  '1': 'TemperatureData',
  '2': const [
    const {'1': 'temperature', '3': 1, '4': 1, '5': 2, '10': 'temperature'},
  ],
};

/// Descriptor for `PPGData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pPGDataDescriptor = $convert.base64Decode('CgdQUEdEYXRhEikKA2xlZBgBIAEoCzIXLlByb3Rvcy5QUEdEYXRhLkxlZERhdGFSA2xlZBJBCgt0ZW1wZXJhdHVyZRgCIAEoCzIfLlByb3Rvcy5QUEdEYXRhLlRlbXBlcmF0dXJlRGF0YVILdGVtcGVyYXR1cmUSGwoJc2Vuc29yX2lkGAMgASgFUghzZW5zb3JJZBIhCgx0aW1lc3RhbXBfbXMYZCABKARSC3RpbWVzdGFtcE1zGkgKB0xlZERhdGESEwoFbGVkXzEYASABKAVSBGxlZDESEwoFbGVkXzIYAiABKAVSBGxlZDISEwoFbGVkXzMYAyABKAVSBGxlZDMaMwoPVGVtcGVyYXR1cmVEYXRhEiAKC3RlbXBlcmF0dXJlGAEgASgCUgt0ZW1wZXJhdHVyZQ==');
@$core.Deprecated('Use aIRFLOWDataDescriptor instead')
const AIRFLOWData$json = const {
  '1': 'AIRFLOWData',
  '2': const [
    const {'1': 'temp_l', '3': 7, '4': 1, '5': 2, '10': 'tempL'},
    const {'1': 'temp_r', '3': 8, '4': 1, '5': 2, '10': 'tempR'},
    const {'1': 'temp_e', '3': 9, '4': 1, '5': 2, '10': 'tempE'},
    const {'1': 'timestamp_ms', '3': 100, '4': 1, '5': 4, '10': 'timestampMs'},
  ],
};

/// Descriptor for `AIRFLOWData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List aIRFLOWDataDescriptor = $convert.base64Decode('CgtBSVJGTE9XRGF0YRIVCgZ0ZW1wX2wYByABKAJSBXRlbXBMEhUKBnRlbXBfchgIIAEoAlIFdGVtcFISFQoGdGVtcF9lGAkgASgCUgV0ZW1wRRIhCgx0aW1lc3RhbXBfbXMYZCABKARSC3RpbWVzdGFtcE1z');
@$core.Deprecated('Use tEMPERATUREDataDescriptor instead')
const TEMPERATUREData$json = const {
  '1': 'TEMPERATUREData',
  '2': const [
    const {'1': 'timestamp_ms', '3': 100, '4': 1, '5': 4, '10': 'timestampMs'},
  ],
  '3': const [TEMPERATUREData_VoltageData$json],
};

@$core.Deprecated('Use tEMPERATUREDataDescriptor instead')
const TEMPERATUREData_VoltageData$json = const {
  '1': 'VoltageData',
  '2': const [
    const {'1': 'voltage10k', '3': 1, '4': 1, '5': 5, '10': 'voltage10k'},
    const {'1': 'voltage1k', '3': 2, '4': 1, '5': 5, '10': 'voltage1k'},
  ],
};

/// Descriptor for `TEMPERATUREData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tEMPERATUREDataDescriptor = $convert.base64Decode('Cg9URU1QRVJBVFVSRURhdGESIQoMdGltZXN0YW1wX21zGGQgASgEUgt0aW1lc3RhbXBNcxpLCgtWb2x0YWdlRGF0YRIeCgp2b2x0YWdlMTBrGAEgASgFUgp2b2x0YWdlMTBrEhwKCXZvbHRhZ2UxaxgCIAEoBVIJdm9sdGFnZTFr');
@$core.Deprecated('Use pTDataDescriptor instead')
const PTData$json = const {
  '1': 'PTData',
  '2': const [
    const {'1': 'temperature', '3': 1, '4': 1, '5': 2, '10': 'temperature'},
    const {'1': 'pressure', '3': 2, '4': 1, '5': 2, '10': 'pressure'},
    const {'1': 'timestamp_ms', '3': 100, '4': 1, '5': 4, '10': 'timestampMs'},
  ],
};

/// Descriptor for `PTData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pTDataDescriptor = $convert.base64Decode('CgZQVERhdGESIAoLdGVtcGVyYXR1cmUYASABKAJSC3RlbXBlcmF0dXJlEhoKCHByZXNzdXJlGAIgASgCUghwcmVzc3VyZRIhCgx0aW1lc3RhbXBfbXMYZCABKARSC3RpbWVzdGFtcE1z');
