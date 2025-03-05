class UsersSteps {
  final String username;
  final String profilepicture;
  int steps;

  UsersSteps(
      {required this.username,
      required this.profilepicture,
      required this.steps});

  // ignore: empty_constructor_bodies
  factory UsersSteps.fromFirestore(Map<String, dynamic> data) {
    return UsersSteps(
      username: data['username'] ?? 'Unknown',
      profilepicture: data['profilephoto'] ?? '',
      steps: data['steps'] ?? 0,
    );
  }
}
