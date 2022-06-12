import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class UserProfile {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String? profilePicture;
  @HiveField(3)
  final String? coverPic;
  @HiveField(4)
  final String phoneNumber;
  @HiveField(5)
  final String? email;
  @HiveField(6)
  final String? description;

  UserProfile(
      {required this.id,
      required this.name,
      this.profilePicture,
      this.coverPic,
      required this.phoneNumber,
      this.email,
      this.description});
}
