import 'package:equatable/equatable.dart';

class Param extends Equatable {
  final String name;
  final String unit;
  final String value;
  Param({this.name, this.unit, this.value});

  @override
  List<Object> get props => [name, unit, value];

  factory Param.fromJson(Map<String, dynamic> json) {
    return Param(
      name: json['name'],
      unit: json['unit'],
      value: json['value'],
    );
  }
}

class Params extends Equatable {
  final List<Param> params;
  Params(this.params);
  @override
  List<Object> get props => params;

  Params.fromJson(List<dynamic> json): params = json.map((jsonItem) => Param.fromJson(jsonItem)).toList();
}