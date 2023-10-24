import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';

part 'info.g.dart';

@JsonSerializable()
class MyInfo {
  MyInfo(this.name, this.age, this.weightList, this.level);

  String name;
  int age;
  List<double> weightList;
  Level level;

  factory MyInfo.empty() {
    return MyInfo('', 0, [], Level.none);
  }

  factory MyInfo.fromJson(Map<String, dynamic> json) => _$MyInfoFromJson(json);

  Map<String, dynamic> toJson() => _$MyInfoToJson(this);

  bool isEmpty() {
    return name.isEmpty;
  }
}
