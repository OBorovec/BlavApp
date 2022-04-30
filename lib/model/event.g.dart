// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      id: json['id'] as String,
      location: json['location'] as String,
      name: Map<String, String>.from(json['name'] as Map),
      desc: (json['desc'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      timestampStart: DateTime.parse(json['timestampStart'] as String),
      timestampEnd: DateTime.parse(json['timestampEnd'] as String),
      routing: Routing.fromJson(json['routing'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'location': instance.location,
      'name': instance.name,
      'desc': instance.desc,
      'timestampStart': instance.timestampStart.toIso8601String(),
      'timestampEnd': instance.timestampEnd.toIso8601String(),
      'routing': instance.routing,
    };

Routing _$RoutingFromJson(Map<String, dynamic> json) => Routing(
      catering: json['catering'] as bool? ?? false,
      cosplay: json['cosplay'] as bool? ?? false,
      degustation: json['degustation'] as bool? ?? false,
      divisions: json['divisions'] as bool? ?? false,
      maps: json['maps'] as bool? ?? false,
      programme: json['programme'] as bool? ?? false,
    );

Map<String, dynamic> _$RoutingToJson(Routing instance) => <String, dynamic>{
      'catering': instance.catering,
      'cosplay': instance.cosplay,
      'degustation': instance.degustation,
      'divisions': instance.divisions,
      'maps': instance.maps,
      'programme': instance.programme,
    };
