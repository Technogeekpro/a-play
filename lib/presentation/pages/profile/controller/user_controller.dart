import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:a_play_world/data/models/user/user_model.dart';
import 'package:a_play_world/data/repositories/user_repository.dart';

final userControllerProvider = StateNotifierProvider<UserController, AsyncValue<UserModel?>>((ref) {
  return UserController(ref.read(userRepositoryProvider));
});

class UserController extends StateNotifier<AsyncValue<UserModel?>> {
  final UserRepository _repository;

  UserController(this._repository) : super(const AsyncValue.loading()) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final user = await _repository.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e) {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> refreshUser() async {
    try {
      state = const AsyncValue.loading();
      final user = await _repository.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateProfile({
    required String userId,
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    try {
      state = const AsyncValue.loading();
      final updatedUser = await _repository.updateUser(
        userId: userId,
        fullName: fullName,
        phoneNumber: phoneNumber,
        avatarUrl: avatarUrl,
      );
      state = AsyncValue.data(updatedUser);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<String> uploadAvatar(String userId, Uint8List fileBytes, String fileName) async {
    try {
      return await _repository.uploadAvatar(userId, fileBytes, fileName);
    } catch (e) {
      rethrow;
    }
  }
} 