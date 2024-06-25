class Fruit {
  final String name;

  Fruit({
    required this.name,
  });

  String get draggableImagePath => 'assets/images/auth/fruits/$name.png';
  String get targetImagePath => 'assets/images/auth/fruits/$name-target.png';
  String get correctTargetImagePath =>
      'assets/images/auth/fruits/$name-completed.png';

  factory Fruit.fromJson(Map<String, dynamic> json) {
    return Fruit(
      name: json['name'],
    );
  }
}
