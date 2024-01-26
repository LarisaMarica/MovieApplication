class AppUser {
  final String email;
  final String username;
  final String name;
  final String surname;

  AppUser(
      {required this.email,
      required this.username,
      required this.name,
      required this.surname});

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      email: json['email'] as String,
      username: json['username'] as String,
      name: json['name'] as String,
      surname: json['surname'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'name': name,
      'surname': surname,
    };
  }

  AppUser copyWith({
    String? uid,
    String? email,
    String? username,
    String? name,
    String? surname,
  }) {
    return AppUser(
      email: email ?? this.email,
      username: username ?? this.username,
      name: name ?? this.name,
      surname: surname ?? this.surname,
    );
  }
}
