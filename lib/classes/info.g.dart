// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyInfo _$MyInfoFromJson(Map<String, dynamic> json) => MyInfo(
      json['name'] as String,
      json['age'] as int,
      (json['weightList'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      $enumDecode(_$LevelEnumMap, json['level']),
    );

Map<String, dynamic> _$MyInfoToJson(MyInfo instance) => <String, dynamic>{
      'name': instance.name,
      'age': instance.age,
      'weightList': instance.weightList,
      'level': _$LevelEnumMap[instance.level]!,
    };

const _$LevelEnumMap = {
  Level.easy: 'easy',
  Level.normal: 'normal',
  Level.hard: 'hard',
  Level.none: 'none',
};
