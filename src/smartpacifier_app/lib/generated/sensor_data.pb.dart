///
//  Generated code. Do not modify.
//  source: sensor_data.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

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
    ..hasRequiredFields = false
  ;

  IMUData._() : super();
  factory IMUData({
    $core.double? temperature,
    IMUData_MotionVector? acc,
    IMUData_MotionVector? gyro,
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
}

class PPGData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PPGData', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Protos'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sensorId', $pb.PbFieldType.O3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'led1', $pb.PbFieldType.O3, protoName: 'led_1')
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'led2', $pb.PbFieldType.O3, protoName: 'led_2')
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'led3', $pb.PbFieldType.O3, protoName: 'led_3')
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'temperature', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  PPGData._() : super();
  factory PPGData({
    $core.int? sensorId,
    $core.int? led1,
    $core.int? led2,
    $core.int? led3,
    $core.double? temperature,
  }) {
    final _result = create();
    if (sensorId != null) {
      _result.sensorId = sensorId;
    }
    if (led1 != null) {
      _result.led1 = led1;
    }
    if (led2 != null) {
      _result.led2 = led2;
    }
    if (led3 != null) {
      _result.led3 = led3;
    }
    if (temperature != null) {
      _result.temperature = temperature;
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
  $core.int get sensorId => $_getIZ(0);
  @$pb.TagNumber(1)
  set sensorId($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSensorId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSensorId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get led1 => $_getIZ(1);
  @$pb.TagNumber(2)
  set led1($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLed1() => $_has(1);
  @$pb.TagNumber(2)
  void clearLed1() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get led2 => $_getIZ(2);
  @$pb.TagNumber(3)
  set led2($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLed2() => $_has(2);
  @$pb.TagNumber(3)
  void clearLed2() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get led3 => $_getIZ(3);
  @$pb.TagNumber(4)
  set led3($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasLed3() => $_has(3);
  @$pb.TagNumber(4)
  void clearLed3() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get temperature => $_getN(4);
  @$pb.TagNumber(5)
  set temperature($core.double v) { $_setFloat(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTemperature() => $_has(4);
  @$pb.TagNumber(5)
  void clearTemperature() => clearField(5);
}

class AIRFLOWData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AIRFLOWData', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Protos'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'voltage10kL', $pb.PbFieldType.O3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'voltage10kR', $pb.PbFieldType.O3)
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'voltage10kE', $pb.PbFieldType.O3)
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rawL', $pb.PbFieldType.OU3)
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rawR', $pb.PbFieldType.OU3)
    ..a<$core.int>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rawE', $pb.PbFieldType.OU3)
    ..a<$core.double>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tempL', $pb.PbFieldType.OF)
    ..a<$core.double>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tempR', $pb.PbFieldType.OF)
    ..a<$core.double>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tempE', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  AIRFLOWData._() : super();
  factory AIRFLOWData({
    $core.int? voltage10kL,
    $core.int? voltage10kR,
    $core.int? voltage10kE,
    $core.int? rawL,
    $core.int? rawR,
    $core.int? rawE,
    $core.double? tempL,
    $core.double? tempR,
    $core.double? tempE,
  }) {
    final _result = create();
    if (voltage10kL != null) {
      _result.voltage10kL = voltage10kL;
    }
    if (voltage10kR != null) {
      _result.voltage10kR = voltage10kR;
    }
    if (voltage10kE != null) {
      _result.voltage10kE = voltage10kE;
    }
    if (rawL != null) {
      _result.rawL = rawL;
    }
    if (rawR != null) {
      _result.rawR = rawR;
    }
    if (rawE != null) {
      _result.rawE = rawE;
    }
    if (tempL != null) {
      _result.tempL = tempL;
    }
    if (tempR != null) {
      _result.tempR = tempR;
    }
    if (tempE != null) {
      _result.tempE = tempE;
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

  @$pb.TagNumber(1)
  $core.int get voltage10kL => $_getIZ(0);
  @$pb.TagNumber(1)
  set voltage10kL($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasVoltage10kL() => $_has(0);
  @$pb.TagNumber(1)
  void clearVoltage10kL() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get voltage10kR => $_getIZ(1);
  @$pb.TagNumber(2)
  set voltage10kR($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasVoltage10kR() => $_has(1);
  @$pb.TagNumber(2)
  void clearVoltage10kR() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get voltage10kE => $_getIZ(2);
  @$pb.TagNumber(3)
  set voltage10kE($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasVoltage10kE() => $_has(2);
  @$pb.TagNumber(3)
  void clearVoltage10kE() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get rawL => $_getIZ(3);
  @$pb.TagNumber(4)
  set rawL($core.int v) { $_setUnsignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasRawL() => $_has(3);
  @$pb.TagNumber(4)
  void clearRawL() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get rawR => $_getIZ(4);
  @$pb.TagNumber(5)
  set rawR($core.int v) { $_setUnsignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasRawR() => $_has(4);
  @$pb.TagNumber(5)
  void clearRawR() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get rawE => $_getIZ(5);
  @$pb.TagNumber(6)
  set rawE($core.int v) { $_setUnsignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasRawE() => $_has(5);
  @$pb.TagNumber(6)
  void clearRawE() => clearField(6);

  @$pb.TagNumber(7)
  $core.double get tempL => $_getN(6);
  @$pb.TagNumber(7)
  set tempL($core.double v) { $_setFloat(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasTempL() => $_has(6);
  @$pb.TagNumber(7)
  void clearTempL() => clearField(7);

  @$pb.TagNumber(8)
  $core.double get tempR => $_getN(7);
  @$pb.TagNumber(8)
  set tempR($core.double v) { $_setFloat(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasTempR() => $_has(7);
  @$pb.TagNumber(8)
  void clearTempR() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get tempE => $_getN(8);
  @$pb.TagNumber(9)
  set tempE($core.double v) { $_setFloat(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasTempE() => $_has(8);
  @$pb.TagNumber(9)
  void clearTempE() => clearField(9);
}

class PTData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PTData', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Protos'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'temperature', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pressure', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  PTData._() : super();
  factory PTData({
    $core.double? temperature,
    $core.double? pressure,
  }) {
    final _result = create();
    if (temperature != null) {
      _result.temperature = temperature;
    }
    if (pressure != null) {
      _result.pressure = pressure;
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
}

