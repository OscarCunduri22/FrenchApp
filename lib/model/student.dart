class Student {
  String name;
  String group;
  String tutorId;
  String imageUrl;

  Student({
    required this.name,
    required this.group,
    required this.tutorId,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'group': group,
      'tutorId': tutorId,
      'imageUrl': imageUrl,
    };
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      name: json['name'],
      group: json['group'],
      tutorId: json['tutorId'],
      imageUrl: json['imageUrl'],
    );
  }
}
