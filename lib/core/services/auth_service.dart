import 'package:flutter/material.dart';
import '../../constants/cached_constants/cached_constants.dart';
import '../../network/local/cache_helper.dart';

/// Centralized authentication service for managing user authentication state
class AuthService {
  static AuthService? _instance;
  static AuthService get instance => _instance ??= AuthService._();

  AuthService._();

  /// Check if user is authenticated
  bool get isAuthenticated => userID != null && token != null;

  /// Check if user is admin
  bool get isAdminUser => isAdmin ?? false;

  /// Get current user ID
  String? get currentUserID => userID;

  /// Get current user token
  String? get currentToken => token;

  /// Get current user name
  String? get currentUserName => name;

  /// Get current user email
  String? get currentUserEmail => userEmail;

  /// Get current user image
  String? get currentUserImage => image;

  /// Initialize authentication service
  /// This should be called during app startup
  Future<void> initializeAuth() async {
    try {
      // Load cached authentication data
      userID = cacheHelper.getData('userID');
      token = cacheHelper.getData('token');
      isAdmin = cacheHelper.getData('isAdmin') ?? false;
      name = cacheHelper.getData('name');
      image = cacheHelper.getData('image');
      userEmail = cacheHelper.getData('email');
      username = cacheHelper.getData('username');
      phone = cacheHelper.getData('phone');

      // TODO: Add token validation against server if needed
      // await _validateToken();
    } catch (e) {
      debugPrint('Error initializing auth: $e');
      // Clear potentially corrupted data
      await logout();
    }
  }

  /// Save authentication data after successful login
  Future<void> saveAuthData({
    required String userId,
    required String userToken,
    required String userName,
    String? userEmailParam,
    String? userImage,
    String? usernameParam,
    String? phoneParam,
    bool isAdminUser = false,
  }) async {
    try {
      await cacheHelper.SaveData(key: 'userID', value: userId);
      await cacheHelper.SaveData(key: 'token', value: userToken);
      await cacheHelper.SaveData(key: 'name', value: userName);
      await cacheHelper.SaveData(key: 'isAdmin', value: isAdminUser);

      if (userEmailParam != null) {
        await cacheHelper.SaveData(key: 'email', value: userEmailParam);
      }
      if (userImage != null) {
        await cacheHelper.SaveData(key: 'image', value: userImage);
      }
      if (usernameParam != null) {
        await cacheHelper.SaveData(key: 'username', value: usernameParam);
      }
      if (phoneParam != null) {
        await cacheHelper.SaveData(key: 'phone', value: phoneParam);
      }

      // Update global variables
      userID = userId;
      token = userToken;
      name = userName;
      isAdmin = isAdminUser;
      userEmail = userEmailParam;
      image = userImage;
      username = usernameParam;
      phone = phoneParam;
    } catch (e) {
      debugPrint('Error saving auth data: $e');
      rethrow;
    }
  }

  /// Logout user and clear all authentication data
  Future<void> logout() async {
    try {
      // Clear cached data
      await cacheHelper.removeData('userID');
      await cacheHelper.removeData('token');
      await cacheHelper.removeData('name');
      await cacheHelper.removeData('isAdmin');
      await cacheHelper.removeData('email');
      await cacheHelper.removeData('image');
      await cacheHelper.removeData('username');
      await cacheHelper.removeData('phone');

      // Clear global variables
      userID = null;
      token = null;
      name = null;
      isAdmin = false;
      userEmail = null;
      image = null;
      username = null;
      phone = null;
    } catch (e) {
      debugPrint('Error during logout: $e');
      rethrow;
    }
  }

  /// Update user profile data
  Future<void> updateProfileData({
    String? userName,
    String? userEmailParam,
    String? userImage,
    String? usernameParam,
    String? phoneParam,
  }) async {
    try {
      if (userName != null) {
        await cacheHelper.SaveData(key: 'name', value: userName);
        name = userName;
      }
      if (userEmailParam != null) {
        await cacheHelper.SaveData(key: 'email', value: userEmailParam);
        userEmail = userEmailParam;
      }
      if (userImage != null) {
        await cacheHelper.SaveData(key: 'image', value: userImage);
        image = userImage;
      }
      if (usernameParam != null) {
        await cacheHelper.SaveData(key: 'username', value: usernameParam);
        username = usernameParam;
      }
      if (phoneParam != null) {
        await cacheHelper.SaveData(key: 'phone', value: phoneParam);
        phone = phoneParam;
      }
    } catch (e) {
      debugPrint('Error updating profile data: $e');
      rethrow;
    }
  }

  /// Check if a route requires authentication
  bool requiresAuthentication(String? routeName) {
    const protectedRoutes = [
      '/ReusetMeat',
      '/AddOpinionPage',
      '/UserRequests',
      '/Profile',
      '/UpdateProfile',
    ];
    return protectedRoutes.contains(routeName);
  }

  /// Check if a route requires admin privileges
  bool requiresAdmin(String? routeName) {
    const adminRoutes = [
      '/AddBannerPage',
      '/AllRequests',
      '/AddAdmin',
      '/AddMember',
      '/admin-dashboard',
    ];
    return adminRoutes.contains(routeName);
  }
}
