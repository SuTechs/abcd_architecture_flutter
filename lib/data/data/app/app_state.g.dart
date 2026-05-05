// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppStateImpl _$$AppStateImplFromJson(Map<String, dynamic> json) =>
    _$AppStateImpl(
      hasBootstrapped: json['hasBootstrapped'] as bool? ?? false,
      themeMode:
          $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.system,
      isOnboardingComplete: json['isOnboardingComplete'] as bool? ?? false,
    );

Map<String, dynamic> _$$AppStateImplToJson(_$AppStateImpl instance) =>
    <String, dynamic>{
      'hasBootstrapped': instance.hasBootstrapped,
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'isOnboardingComplete': instance.isOnboardingComplete,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
