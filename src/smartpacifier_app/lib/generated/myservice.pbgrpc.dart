///
//  Generated code. Do not modify.
//  source: myservice.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'sensor_data.pb.dart' as $0;
import 'google/protobuf/empty.pb.dart' as $1;
export 'myservice.pb.dart';

class MyServiceClient extends $grpc.Client {
  static final _$publishIMU = $grpc.ClientMethod<$0.IMUData, $1.Empty>(
      '/myservice.MyService/PublishIMU',
      ($0.IMUData value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$publishPT = $grpc.ClientMethod<$0.PTData, $1.Empty>(
      '/myservice.MyService/PublishPT',
      ($0.PTData value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$publishAirflow = $grpc.ClientMethod<$0.AIRFLOWData, $1.Empty>(
      '/myservice.MyService/PublishAirflow',
      ($0.AIRFLOWData value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));

  MyServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$1.Empty> publishIMU($async.Stream<$0.IMUData> request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$publishIMU, request, options: options).single;
  }

  $grpc.ResponseFuture<$1.Empty> publishPT($async.Stream<$0.PTData> request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$publishPT, request, options: options).single;
  }

  $grpc.ResponseFuture<$1.Empty> publishAirflow(
      $async.Stream<$0.AIRFLOWData> request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$publishAirflow, request, options: options)
        .single;
  }
}

abstract class MyServiceBase extends $grpc.Service {
  $core.String get $name => 'myservice.MyService';

  MyServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.IMUData, $1.Empty>(
        'PublishIMU',
        publishIMU,
        true,
        false,
        ($core.List<$core.int> value) => $0.IMUData.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PTData, $1.Empty>(
        'PublishPT',
        publishPT,
        true,
        false,
        ($core.List<$core.int> value) => $0.PTData.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AIRFLOWData, $1.Empty>(
        'PublishAirflow',
        publishAirflow,
        true,
        false,
        ($core.List<$core.int> value) => $0.AIRFLOWData.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
  }

  $async.Future<$1.Empty> publishIMU(
      $grpc.ServiceCall call, $async.Stream<$0.IMUData> request);
  $async.Future<$1.Empty> publishPT(
      $grpc.ServiceCall call, $async.Stream<$0.PTData> request);
  $async.Future<$1.Empty> publishAirflow(
      $grpc.ServiceCall call, $async.Stream<$0.AIRFLOWData> request);
}
