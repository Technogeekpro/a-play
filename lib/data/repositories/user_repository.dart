import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:a_play/core/config/supabase_config.dart';
import 'package:a_play/data/models/user/user_model.dart';
import 'package:a_play/core/errors/auth_exceptions.dart' as app_auth;
import 'package:flutter/foundation.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(SupabaseConfig.client);
});

class UserRepository {
  final SupabaseClient _client;

  UserRepository(this._client);

  Future<UserModel> getCurrentUser() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw app_auth.AuthException(
          message: 'No user logged in',
          code: 'no_user',
        );
      }

      final response = await _client
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      final user = UserModel.fromJson(response);

      // Fix avatar URL if needed
      if (user.avatarUrl != null) {
        final fixedUrl = _fixAvatarUrl(user.avatarUrl!);
        if (fixedUrl != user.avatarUrl) {
          debugPrint('Fixing malformed avatar URL in database');
          debugPrint('Old URL: ${user.avatarUrl}');
          debugPrint('New URL: $fixedUrl');
          
          // Update the URL in database
          await updateUser(
            userId: user.id,
            avatarUrl: fixedUrl,
          );
          
          // Return updated user
          return user.copyWith(avatarUrl: fixedUrl);
        }
      }

      return user;
    } catch (e) {
      throw app_auth.AuthException(
        message: 'Failed to fetch user data: ${e.toString()}',
        code: 'fetch_error',
      );
    }
  }

  String _fixAvatarUrl(String url) {
    try {
      // Extract the file name from the URL
      final uri = Uri.parse(url);
      final fileName = uri.pathSegments.last;
      
      // Get a fresh public URL using Supabase's method
      return _client.storage.from('profile_images').getPublicUrl(fileName);
    } catch (e) {
      debugPrint('Error fixing avatar URL: $e');
      return url; // Return original URL if fixing fails
    }
  }

  Future<UserModel> updateUser({
    required String userId,
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    try {
      // Fix malformed avatar URL if present
      if (avatarUrl != null) {
        avatarUrl = avatarUrl.replaceAll('/profile_images/profile_images/', '/profile_images/');
      }

      final updates = {
        if (fullName != null) 'full_name': fullName,
        if (phoneNumber != null) 'phone_number': phoneNumber,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _client
          .from('users')
          .update(updates)
          .eq('id', userId)
          .select()
          .single();

      // Also update auth metadata
      await _client.auth.updateUser(
        UserAttributes(
          data: {
            if (fullName != null) 'full_name': fullName,
            if (phoneNumber != null) 'phone_number': phoneNumber,
          },
        ),
      );

      return UserModel.fromJson(response);
    } catch (e) {
      throw app_auth.AuthException(
        message: 'Failed to update user data: ${e.toString()}',
        code: 'update_error',
      );
    }
  }

  Future<String> uploadAvatar(String userId, Uint8List fileBytes, String fileName) async {
    try {
      final extension = fileName.split('.').last;
      final path = '$userId.$extension';

      debugPrint('Uploading avatar to path: $path');

      // Upload the file
      await _client.storage.from('profile_images').uploadBinary(
        path,
        fileBytes,
        fileOptions: FileOptions(
          contentType: 'image/$extension',
          upsert: true,
        ),
      );

      // Get the public URL using Supabase's method
      final imageUrl = _client.storage.from('profile_images').getPublicUrl(path);
      debugPrint('Generated image URL: $imageUrl');

      return imageUrl;
    } catch (e) {
      debugPrint('Error uploading avatar: $e');
      throw app_auth.AuthException(
        message: 'Failed to upload avatar: ${e.toString()}',
        code: 'upload_error',
      );
    }
  }
} 