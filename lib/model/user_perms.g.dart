// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_perms.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPerms _$UserPermsFromJson(Map<String, dynamic> json) => UserPerms(
      roles: json['roles'] == null
          ? const Roles()
          : Roles.fromJson(json['roles'] as Map<String, dynamic>),
      hasAdmin: json['hasAdmin'] as bool? ?? false,
    );

Map<String, dynamic> _$UserPermsToJson(UserPerms instance) => <String, dynamic>{
      'roles': instance.roles,
      'hasAdmin': instance.hasAdmin,
    };

Roles _$RolesFromJson(Map<String, dynamic> json) => Roles(
      org: json['org'] as bool? ?? false,
      vip: json['vip'] as bool? ?? false,
    );

Map<String, dynamic> _$RolesToJson(Roles instance) => <String, dynamic>{
      'org': instance.org,
      'vip': instance.vip,
    };
