// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_tokens.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthTokensImpl _$$AuthTokensImplFromJson(Map<String, dynamic> json) =>
    _$AuthTokensImpl(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      refreshTokenExpiresAt: json['refreshTokenExpiresAt'] == null
          ? null
          : DateTime.parse(json['refreshTokenExpiresAt'] as String),
      tokenType: json['tokenType'] as String? ?? 'Bearer',
    );

Map<String, dynamic> _$$AuthTokensImplToJson(_$AuthTokensImpl instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'expiresAt': instance.expiresAt.toIso8601String(),
      'refreshTokenExpiresAt':
          instance.refreshTokenExpiresAt?.toIso8601String(),
      'tokenType': instance.tokenType,
    };
