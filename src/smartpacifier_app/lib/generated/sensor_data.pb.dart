///
//  Generated code. Do not modify.
//  source: sensor_data.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class SensorData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SensorData', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Protos'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pacifierId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sensorType')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sensorGroup')
    ..m<$core.String, $core.List<$core.int>>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'dataMap', entryClassName: 'SensorData.DataMapEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OY, packageName: const $pb.PackageName('Protos'))
    ..hasRequiredFields = false
  ;

  SensorData._() : super();
  factory SensorData({
    $core.String? pacifierId,
    $core.String? sensorType,
    $core.String? sensorGroup,
    $core.Map<$core.String, $core.List<$core.int>>? dataMap,
  }) {
    final _result = create();
    if (pacifierId != null) {
      _result.pacifierId = pacifierId;
    }
    if (sensorType != null) {
      _result.sensorType = sensorType;
    }
    if (sensorGroup != null) {
      _result.sensorGroup = sensorGroup;
    }
    if (dataMap != null) {
      _result.dataMap.addAll(dataMap);
    }
    return _result;
  }
  factory SensorData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SensorData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SensorData clone() => SensorData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SensorData copyWith(void Function(SensorData) updates) => super.copyWith((message) => updates(message as SensorData)) as SensorData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SensorData create() => SensorData._();
  SensorData createEmptyInstance() => create();
  static $pb.PbList<SensorData> createRepeated() => $pb.PbList<SensorData>();
  @$core.pragma('dart2js:noInline')
  static SensorData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SensorData>(create);
  static SensorData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pacifierId => $_getSZ(0);
  @$pb.TagNumber(1)
  set pacifierId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPacifierId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPacifierId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sensorType => $_getSZ(1);
  @$pb.TagNumber(2)
  set sensorType($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSensorType() => $_has(1);
  @$pb.TagNumber(2)
  void clearSensorType() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get sensorGroup => $_getSZ(2);
  @$pb.TagNumber(3)
  set sensorGroup($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSensorGroup() => $_has(2);
  @$pb.TagNumber(3)
  void clearSensorGroup() => clearField(3);

  @$pb.TagNumber(4)
  $core.Map<$core.String, $core.List<$core.int>> get dataMap => $_getMap(3);
}

class IMUData_MotionVector extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'IMUData.MotionVector', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Protos'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'x', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'y', $pb.PbFieldType.OF)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'z', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  IMUData_MotionVector._() : super();
  factory IMUData_MotionVector({
    $core.double? x,
    $core.double? y,
    $core.double? z,
  }) {
    final _result = create();
    if (x != null) {
      _result.x = x;
    }
    if (y != null) {
      _result.y = y;
    }
    if (z != null) {
      _result.z = z;
    }
    return _result;
  }
  factory IMUData_MotionVector.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory IMUData_MotionVector.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  IMUData_MotionVector clone() => IMUData_MotionVector()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  IMUData_MotionVector copyWith(void Function(IMUData_MotionVector) updates) => super.copyWith((message) => updates(message as IMUData_MotionVector)) as IMUData_MotionVector; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static IMUData_MotionVector create() => IMUData_MotionVector._();
  IMUData_MotionVector createEmptyInstance() => create();
  static $pb.PbList<IMUData_MotionVector> createRepeated() => $pb.PbList<IMUData_MotionVector>();
  @$core.pragma('dart2js:noInline')
  static IMUData_MotionVector getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IMUData_MotionVector>(create);
  static IMUData_MotionVector? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get x => $_getN(0);
  @$pb.TagNumber(1)
  set x($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasX() => $_has(0);
  @$pb.TagNumber(1)
  void clearX() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get y => $_getN(1);
  @$pb.TagNumber(2)
  set y($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasY() => $_has(1);
  @$pb.TagNumber(2)
  void clearY() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get z => $_getN(2);
  @$pb.TagNumber(3)
  set z($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasZ() => $_has(2);
  @$pb.TagNumber(3)
  void clearZ() => clearField(3);
}

class IMUData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'IMUData', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Protos'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'temperature', $pb.PbFieldType.OF)
    ..aOM<IMUData_MotionVector>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'acc', subBuilder: IMUData_MotionVector.create)
    ..aOM<IMUData_MotionVector>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gyro', subBuilder: IMUData_MotionVector.create)
    ..a<$fixnum.Int64>(100, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timestampMs', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  IMUData._() : super();
  factory IMUData({
    $core.double? temperature,
    IMUData_MotionVector? acc,
    IMUData_MotionVector? gyro,
    $fixnum.Int64? timestampMs,
  }) {
    final _result = create();
    if (temperature != null) {
      _result.temperature = temperature;
    }
    if (acc != null) {
      _result.acc = acc;
    }
    if (gyro != null) {
      _result.gyro = gyro;
    }
    if (timestampMs != null) {
      _result.timestampMs = timestampMs;
    }
    return _result;
  }
  factory IMUData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory IMUData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  IMUData clone() => IMUData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  IMUData copyWith(void Function(IMUData) updates) => super.copyWith((message) => updates(message as IMUData)) as IMUData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static IMUData create() => IMUData._();
  IMUData createEmptyInstance() => create();
  static $pb.PbList<IMUData> createRepeated() => $pb.PbList<IMUData>();
  @$core.pragma('dart2js:noInline')
  static IMUData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IMUData>(create);
  static IMUData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get temperature => $_getN(0);
  @$pb.TagNumber(1)
  set temperature($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTemperature() => $_has(0);
  @$pb.TagNumber(1)
  void clearTemperature() => clearField(1);

  @$pb.TagNumber(2)
  IMUData_MotionVector get acc => $_getN(1);
  @$pb.TagNumber(2)
  set acc(IMUData_MotionVector v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasAcc() => $_has(1);
  @$pb.TagNumber(2)
  void clearAcc() => clearField(2);
  @$pb.TagNumber(2)
  IMUData_MotionVector ensureAcc() => $_ensure(1);

  @$pb.TagNumber(3)
  IMUData_MotionVector get gyro => $_getN(2);
  @$pb.TagNumber(3)
  set gyro(IMUData_MotionVector v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasGyro() => $_has(2);
  @$pb.TagNumber(3)
  void clearGyro() => clearField(3);
  @$pb.TagNumber(3)
  IMUData_MotionVector ensureGyro() => $_ensure(2);

  @$pb.TagNumber(100)
  $fixnum.Int64 get timestampMs => $_getI64(3);
  @$pb.TagNumber(100)
  set timestampMs($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(100)
  $core.bool hasTimestampMs() => $_has(3);
  @$pb.TagNumber(100)
  void clearTimestampMs() => clearField(100);
}

class PPGData_LedData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PPGData.LedData', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Protos'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'led1', $pb.PbFieldType.O3, protoName: 'led_1')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'led2', $pb.PbFieldType.O3, protoName: 'led_2')
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'led3', $pb.PbFieldType.O3, protoName: 'led_3')
    ..hasRequiredFields = false
  ;

  PPGData_LedData._() : super();
  factory PPGData_LedData({
    $core.int? led1,
    $core.int? led2,
    $core.int? led3,
  }) {
    final _result = create();
    if (led1 != null) {
      _result.led1 = led1;
    }
    if (led2 != null) {
      _result.led2 = led2;
    }
    if (led3 != null) {
      _result.led3 = led3;
    }
    return _result;
  }
  factory PPGData_LedData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PPGData_LedData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PPGData_LedData clone() => PPGData_LedData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PPGData_LedData copyWith(void Function(PPGData_LedData) updates) => super.copyWith((message) => updates(message as PPGData_LedData)) as PPGData_LedData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PPGData_LedData create() => PPGData_LedData._();
  PPGData_LedData createEmptyInstance() => create();
  static $pb.PbList<PPGData_LedData> createRepeated() => $pb.PbList<PPGData_LedData>();
  @$core.pragma('dart2js:noInline')
  static PPGData_LedData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PPGData_LedData>(create);
  static PPGData_LedData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get led1 => $_getIZ(0);
  @$pb.TagNumber(1)
  set led1($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLed1() => $_has(0);
  @$pb.TagNumber(1)
  void clearLed1() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get led2 => $_getIZ(1);
  @$pb.TagNumber(2)
  set led2($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLed2() => $_has(1);
  @$pb.TagNumber(2)
  void clearLed2() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get led3 => $_getIZ(2);
  @$pb.TagNumber(3)
  set led3($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLed3() => $_has(2);
  @$pb.TagNumber(3)
  void clearLed3() => clearField(3);
}

class PPGData_TemperatureData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PPGData.TemperatureData', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Protos'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'temperature', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  PPGData_TemperatureData._() : super();
  factory PPGData_TemperatureData({
    $core.double? temperature,
  }) {
    final _result = create();
    if (temperature != null) {
      _result.temperature = temperature;
    }
    return _result;
  }
  factory PPGData_TemperatureData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PPGData_TemperatureData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PPGData_TemperatureData clone() => PPGData_TemperatureData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PPGData_TemperatureData copyWith(void Function(PPGData_TemperatureData) updates) => super.copyWith((message) => updates(message as PPGData_TemperatureData)) as PPGData_TemperatureData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PPGData_TemperatureData create() => PPGData_TemperatureData._();
  PPGData_TemperatureData createEmptyInstance() => create();
  static $pb.PbList<PPGData_TemperatureData> createRepeated() => $pb.PbList<PPGData_TemperatureData>();
  @$core.pragma('dart2js:noInline')
  static PPGData_TemperatureData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PPGData_TemperatureData>(create);
  static PPGData_TemperatureData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get temperature => $_getN(0);
  @$pb.TagNumber(1)
  set temperature($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTemperature() => $_has(0);
  @$pb.TagNumber(1)
  void clearTemperature() => clearField(1);
}

class PPGData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PPGData', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Protos'), createEmptyInstance: create)
    ..aOM<PPGData_LedData>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'led', subBuilder: PPGData_LedData.create)
    ..aOM<PPGData_TemperatureData>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'temperature', subBuilder: PPGData_TemperatureData.create)
    ..a<$fixnum.Int64>(100, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timestampMs', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  PPGData._() : super();
  factory PPGData({
    PPGData_LedData? led,
    PPGData_TemperatureData? temperature,
    $fixnum.Int64? timestampMs,
  }) {
    final _result = create();
    if (led != null) {
      _result.led = led;
    }
    if (temperature != null) {
      _result.temperature = temperature;
    }
    if (timestampMs != null) {
      _result.timestampMs = timestampMs;
    }
    return _result;
  }
  factory PPGData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PPGData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PPGData clone() => PPGData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PPGData copyWith(void Function(PPGData) updates) => super.copyWith((message) => updates(message as PPGData)) as PPGData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PPGData create() => PPGData._();
  PPGData createEmptyInstance() => create();
  static $pb.PbList<PPGData> createRepeated() => $pb.PbList<PPGData>();
  @$core.pragma('dart2js:noInline')
  static PPGData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PPGData>(create);
  static PPGData? _defaultInstance;

  @$pb.TagNumber(1)
  PPGData_LedData get led => $_getN(0);
  @$pb.TagNumber(1)
  set led(PPGData_LedData v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasLed() => $_has(0);
  @$pb.TagNumber(1)
  void clearLed() => clearField(1);
  @$pb.TagNumber(1)
  PPGData_LedData ensureLed() => $_ensure(0);

  @$pb.TagNumber(2)
  PPGData_TemperatureData get temperature => $_getN(1);
  @$pb.TagNumber(2)
  set temperature(PPGData_TemperatureData v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasTemperature() => $_has(1);
  @$pb.TagNumber(2)
  void clearTemperature() => clearField(2);
  @$pb.TagNumber(2)
  PPGData_TemperatureData ensureTemperature() => $_ensure(1);

  @$pb.TagNumber(100)
  $fixnum.Int64 get timestampMs => $_getI64(2);
  @$pb.TagNumber(100)
  set timestampMs($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(100)
  $core.bool hasTimestampMs() => $_has(2);
  @$pb.TagNumber(100)
  void clearTimestampMs() => clearField(100);
}

class AIRFLOWData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AIRFLOWData', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Protos'), createEmptyInstance: create)
    ..a<$core.double>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tempL', $pb.PbFieldType.OF)
    ..a<$core.double>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tempR', $pb.PbFieldType.OF)
    ..a<$core.double>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tempE', $pb.PbFieldType.OF)
    ..a<$fixnum.Int64>(100, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timestampMs', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  AIRFLOWData._() : super();
  factory AIRFLOWData({
    $core.double? tempL,
    $core.double? tempR,
    $core.double? tempE,
    $fixnum.Int64? timestampMs,
  }) {
    final _result = create();
    if (tempL != null) {
      _result.tempL = tempL;
    }
    if (tempR != null) {
      _result.tempR = tempR;
    }
    if (tempE != null) {
      _result.tempE = tempE;
    }
    if (timestampMs != null) {
      _result.timestampMs = timestampMs;
    }
    return _result;
  }
  factory AIRFLOWData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AIRFLOWData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AIRFLOWData clone() => AIRFLOWData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AIRFLOWData copyWith(void Function(AIRFLOWData) updates) => super.copyWith((message) => updates(message as AIRFLOWData)) as AIRFLOWData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AIRFLOWData create() => AIRFLOWData._();
  AIRFLOWData createEmptyInstance() => create();
  static $pb.PbList<AIRFLOWData> createRepeated() => $pb.PbList<AIRFLOWData>();
  @$core.pragma('dart2js:noInline')
  static AIRFLOWData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AIRFLOWData>(create);
  static AIRFLOWData? _defaultInstance;

  @$pb.TagNumber(7)
  $core.double get tempL => $_getN(0);
  @$pb.TagNumber(7)
  set tempL($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(7)
  $core.bool hasTempL() => $_has(0);
  @$pb.TagNumber(7)
  void clearTempL() => clearField(7);

  @$pb.TagNumber(8)
  $core.double get tempR => $_getN(1);
  @$pb.TagNumber(8)
  set tempR($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(8)
  $core.bool hasTempR() => $_has(1);
  @$pb.TagNumber(8)
  void clearTempR() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get tempE => $_getN(2);
  @$pb.TagNumber(9)
  set tempE($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(9)
  $core.bool hasTempE() => $_has(2);
  @$pb.TagNumber(9)
  void clearTempE() => clearField(9);

  @$pb.TagNumber(100)
  $fixnum.Int64 get timestampMs => $_getI64(3);
  @$pb.TagNumber(100)
  set timestampMs($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(100)
  $core.bool hasTimestampMs() => $_has(3);
  @$pb.TagNumber(100)
  void clearTimestampMs() => clearField(100);
}

class TEMPERATUREData_VoltageData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TEMPERATUREData.VoltageData', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Protos'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'voltage10k', $pb.PbFieldType.O3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'voltage1k', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  TEMPERATUREData_VoltageData._() : super();
  factory TEMPERATUREData_VoltageData({
    $core.int? voltage10k,
    $core.int? voltage1k,
  }) {
    final _result = create();
    if (voltage10k != null) {
      _result.voltage10k = voltage10k;
    }
    if (voltage1k != null) {
      _result.voltage1k = voltage1k;
    }
    return _result;
  }
  factory TEMPERATUREData_VoltageData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TEMPERATUREData_VoltageData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TEMPERATUREData_VoltageData clone() => TEMPERATUREData_VoltageData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TEMPERATUREData_VoltageData copyWith(void Function(TEMPERATUREData_VoltageData) updates) => super.copyWith((message) => updates(message as TEMPERATUREData_VoltageData)) as TEMPERATUREData_VoltageData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TEMPERATUREData_VoltageData create() => TEMPERATUREData_VoltageData._();
  TEMPERATUREData_VoltageData createEmptyInstance() => create();
  static $pb.PbList<TEMPERATUREData_VoltageData> createRepeated() => $pb.PbList<TEMPERATUREData_VoltageData>();
  @$core.pragma('dart2js:noInline')
  static TEMPERATUREData_VoltageData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TEMPERATUREData_VoltageData>(create);
  static TEMPERATUREData_VoltageData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get voltage10k => $_getIZ(0);
  @$pb.TagNumber(1)
  set voltage10k($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasVoltage10k() => $_has(0);
  @$pb.TagNumber(1)
  void clearVoltage10k() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get voltage1k => $_getIZ(1);
  @$pb.TagNumber(2)
  set voltage1k($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasVoltage1k() => $_has(1);
  @$pb.TagNumber(2)
  void clearVoltage1k() => clearField(2);
}

class TEMPERATUREData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TEMPERATUREData', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Protos'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(100, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timestampMs', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  TEMPERATUREData._() : super();
  factory TEMPERATUREData({
    $fixnum.Int64? timestampMs,
  }) {
    final _result = create();
    if (timestampMs != null) {
      _result.timestampMs = timestampMs;
    }
    return _result;
  }
  factory TEMPERATUREData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TEMPERATUREData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TEMPERATUREData clone() => TEMPERATUREData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TEMPERATUREData copyWith(void Function(TEMPERATUREData) updates) => super.copyWith((message) => updates(message as TEMPERATUREData)) as TEMPERATUREData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TEMPERATUREData create() => TEMPERATUREData._();
  TEMPERATUREData createEmptyInstance() => create();
  static $pb.PbList<TEMPERATUREData> createRepeated() => $pb.PbList<TEMPERATUREData>();
  @$core.pragma('dart2js:noInline')
  static TEMPERATUREData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TEMPERATUREData>(create);
  static TEMPERATUREData? _defaultInstance;

  @$pb.TagNumber(100)
  $fixnum.Int64 get timestampMs => $_getI64(0);
  @$pb.TagNumber(100)
  set timestampMs($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(100)
  $core.bool hasTimestampMs() => $_has(0);
  @$pb.TagNumber(100)
  void clearTimestampMs() => clearField(100);
}

class PTData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PTData', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Protos'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'temperature', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pressure', $pb.PbFieldType.OF)
    ..a<$fixnum.Int64>(100, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timestampMs', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  PTData._() : super();
  factory PTData({
    $core.double? temperature,
    $core.double? pressure,
    $fixnum.Int64? timestampMs,
  }) {
    final _result = create();
    if (temperature != null) {
      _result.temperature = temperature;
    }
    if (pressure != null) {
      _result.pressure = pressure;
    }
    if (timestampMs != null) {
      _result.timestampMs = timestampMs;
    }
    return _result;
  }
  factory PTData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PTData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PTData clone() => PTData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PTData copyWith(void Function(PTData) updates) => super.copyWith((message) => updates(message as PTData)) as PTData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PTData create() => PTData._();
  PTData createEmptyInstance() => create();
  static $pb.PbList<PTData> createRepeated() => $pb.PbList<PTData>();
  @$core.pragma('dart2js:noInline')
  static PTData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PTData>(create);
  static PTData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get temperature => $_getN(0);
  @$pb.TagNumber(1)
  set temperature($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTemperature() => $_has(0);
  @$pb.TagNumber(1)
  void clearTemperature() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get pressure => $_getN(1);
  @$pb.TagNumber(2)
  set pressure($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPressure() => $_has(1);
  @$pb.TagNumber(2)
  void clearPressure() => clearField(2);

  @$pb.TagNumber(100)
  $fixnum.Int64 get timestampMs => $_getI64(2);
  @$pb.TagNumber(100)
  set timestampMs($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(100)
  $core.bool hasTimestampMs() => $_has(2);
  @$pb.TagNumber(100)
  void clearTimestampMs() => clearField(100);
}

