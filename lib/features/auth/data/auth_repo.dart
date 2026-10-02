import 'package:hunhry_food/core/errors/failure.dart';
import 'package:hunhry_food/core/services/supabase_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepo {
  Future<({Failure? failure, AuthResponse? response})> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await SupabaseServices.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return (failure: null, response: response);
    } on PostgrestException catch (e) {
      return (failure: ServerFailure.fromPostgrest(e), response: null);
    } on AuthException catch (e) {
      return (failure: ServerFailure.fromAuth(e), response: null);
    } catch (e) {
      return (
        failure: const ServerFailure('حدث خطا غير متوقع '),
        response: null,
      );
    }
  }

  Future<({Failure? failure, AuthResponse? response})> register({
    required String email,
    required String password,
    String? name,
    String? phone,
  }) async {
    try {
      final response = await SupabaseServices.client.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      if (response.user != null) {
        await SupabaseServices.client.from('profiles').insert({
          'id': response.user!.id,
          'name': name,
          'phone': phone,
        });
      }
      return (failure: null, response: response);
    } on PostgrestException catch (e) {
      return (failure: ServerFailure.fromPostgrest(e), response: null);
    } on AuthException catch (e) {
      return (failure: ServerFailure.fromAuth(e), response: null);
    } catch (e) {
      return (
        failure: const ServerFailure('حدث خطا غير متوقع '),
        response: null,
      );
    }
  }

  Future<({Failure? failure, Map<String, dynamic>? userData})>
  getUserProfile() async {
    try {
      final currentUser = SupabaseServices.client.auth.currentUser;

      if (currentUser == null) {
        return (
          failure: const ServerFailure('المستخدم غير مسجل دخول'),
          userData: null,
        );
      }

      String email = currentUser.email ?? '';
      String name = currentUser.userMetadata?['name'] ?? '';
      String address = '55Dubai, UAE';

      final profileData = await SupabaseServices.client
          .from('profiles')
          .select('name')
          .eq('id', currentUser.id)
          .maybeSingle();

      if (profileData != null) {
        if (profileData['name'] != null &&
            profileData['name'].toString().isNotEmpty) {
          name = profileData['name'];
        }
        // if (profileData['address'] != null &&
        //     profileData['address'].toString().isNotEmpty) {
        //   address = profileData['address'];
        // }
      }

      return (
        failure: null,
        userData: {'name': name, 'email': email, 'address': address},
      );
    } catch (e) {
      return (
        failure: const ServerFailure('حدث خطأ أثناء جلب البيانات'),
        userData: null,
      );
    }
  }

  Future<({Failure? failure, bool isSuccess})> logout() async {
    try {
      await SupabaseServices.client.auth.signOut();
      return (failure: null, isSuccess: true);
    } on AuthException catch (e) {
      return (failure: ServerFailure.fromAuth(e), isSuccess: false);
    } catch (e) {
      return (
        failure: const ServerFailure('حدث خطأ غير متوقع أثناء تسجيل الخروج'),
        isSuccess: false,
      );
    }
  }
}
