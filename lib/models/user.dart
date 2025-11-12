/// User model representing app user information
/// Stores ID card data (name, school, birthday, year level)
class AppUser {
  final String id;
  final String name;
  final String school;
  final String birthday; // Format: MM-DD-YYYY
  final String yearLevel;

  const AppUser({
    required this.id,
    required this.name,
    required this.school,
    required this.birthday,
    required this.yearLevel,
  });
}


