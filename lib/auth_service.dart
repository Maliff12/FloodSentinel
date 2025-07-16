import 'DatabaseService.dart';

class AuthService {
  final DatabaseService _databaseService = DatabaseService();

  // Assume _currentUsername is managed somehow (e.g., from login state)
  String? _currentUsername;

  // Register a community user
  Future<bool> registerCommunity(
    String username,
    String email,
    String password,
    String fullName,
    String phoneNumber, // New Field
    String streetNumber,
    String streetName,
    String district,
    String state,
    String age,
    String gender,
  ) async {
    try {
      int result = await _databaseService.registerUser(
        username,
        email,
        password,
        '', // referenceCode
        '', // departmentName
        fullName,
        phoneNumber, // New Field
        streetNumber,
        streetName,
        district,
        state,
        age,
        gender,
      );
      return result > 0;
    } catch (e) {
      print('Error registering community user: $e');
      return false;
    }
  }

  // Register as an authority user
  Future<bool> registerAsAuthority(
    String username,
    String email,
    String password,
    String referenceCode,
    String fullName,
    String phoneNumber, // New Field
    String streetNumber,
    String streetName,
    String district,
    String state,
    String age,
    String gender,
  ) async {
    try {
      String departmentName = await _databaseService.getDepartmentName(referenceCode);
      if (departmentName.isNotEmpty) {
        int result = await _databaseService.registerUser(
          username,
          email,
          password,
          referenceCode,
          departmentName,
          fullName,
          phoneNumber, // New Field
          streetNumber,
          streetName,
          district,
          state,
          age,
          gender,
        );
        return result > 0;
      } else {
        return false; // Invalid reference code
      }
    } catch (e) {
      print('Error registering authority: $e');
      return false;
    }
  }

  // Login
  Future<String?> login(String username, String password) async {
    try {
      bool isAuthority = await _databaseService.isUserAuthority(username, password);
      if (isAuthority) {
        _currentUsername = username;
        return 'authority';
      } else {
        bool isCommunityUser = await _databaseService.isCommunityUser(username, password);
        if (isCommunityUser) {
          _currentUsername = username;
          return 'community';
        } else {
          return null; // Invalid credentials
        }
      }
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }

  // Reset password
  Future<bool> resetPassword(String email, String newPassword) async {
    try {
      return await _databaseService.updatePasswordByEmail(email, newPassword);
    } catch (e) {
      print('Error resetting password: $e');
      return false;
    }
  }

  // Get user data by username
  Future<Map<String, dynamic>?> getUserData(String username) async {
    try {
      return await _databaseService.getUserData(username);
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  // Update user profile by username
  Future<bool> updateUserProfile(
    String username,
    String email,
    String fullName,
    String phoneNumber, // New Field
    String streetNumber,
    String streetName,
    int age,
    String gender,
    String referenceCode,
    String state,
    String district,
  ) async {
    try {
      return await _databaseService.updateUserProfile(
        username,
        email,
        fullName,
        phoneNumber, // New Field
        streetNumber,
        streetName,
        age,
        gender,
        referenceCode,
        state,
        district,
      );
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
    }
  }

  // Get the current username
  String? getCurrentUsername() {
    return _currentUsername;
  }
}
