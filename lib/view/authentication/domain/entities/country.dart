class CountryModel {
  final String name;
  final String code;
  final String id;
  final String flag;
  CountryModel(
      {required this.id,
      required this.flag,
      required this.name,
      required this.code});

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      name: json['name'],
      code: json['code'],
      id: json['id'],
      flag: json['flag'],
    );
  }
  @override
  String toString() {
    return 'Country{name: $name, code: $code, id: $id, flag: $flag}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountryModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          code == other.code &&
          id == other.id &&
          flag == other.flag;
}
