import 'package:supabase_flutter/supabase_flutter.dart';

abstract class Failure {
  final String messages;
  const Failure(this.messages);
}

class ServerFailure extends Failure {
  const ServerFailure(super.messages);

  // 1. معالجة أخطاء قاعدة البيانات (Postgrest)
  factory ServerFailure.fromPostgrest(PostgrestException error) {
    switch (error.code) {
      case '23505': // Duplicate key / Unique constraint
        return const ServerFailure('هذا العنصر أو الحساب موجود بالفعل.');
      case '23503': // Foreign key constraint
        return const ServerFailure('البيانات المرتبطة غير موجودة أو تم حذفها.');
      case '23502': // Not null violation
        return const ServerFailure('يرجى ملء جميع الحقول المطلوبة.');
      case '22P02': // Invalid text representation (like bad UUID)
        return const ServerFailure('صيغة البيانات المدخلة غير صالحة.');
      case '42P01': // Undefined table
        return const ServerFailure('حدث خطأ في النظام، يرجى المحاولة لاحقاً.');
      case 'PGRST116': // Single row not found
        return const ServerFailure('العنصر المطلوب غير موجود.');
      case 'PGRST301': // RLS Policy / Auth failure
        return const ServerFailure(
          'عفواً، ليس لديك الصلاحية الكافية لإجراء هذا التعديل.',
        );
      default:
        if (error.message.contains('JWTErr') || error.message.contains('JWT')) {
          return const ServerFailure(
            'انتهت جلسة الدخول، يرجى إعادة تسجيل الدخول.',
          );
        }
        return ServerFailure(error.message);
    }
  }

  // 2. معالجة أخطاء التوثيق (Auth)
  factory ServerFailure.fromAuth(AuthException error) {
    switch (error.message) {
      case 'Invalid login credentials':
        return const ServerFailure('البريد الإلكتروني أو كلمة السر غير صحيحة.');
      case 'User already registered':
        return const ServerFailure('هذا البريد الإلكتروني مسجل بالفعل.');
      case 'Email not confirmed':
        return const ServerFailure(
          'يرجى تأكيد البريد الإلكتروني الخاص بك أولاً.',
        );
      case 'Password should be at least 6 characters':
        return const ServerFailure(
          'كلمة السر يجب أن تكون من 6 أحرف على الأقل.',
        );
      case 'User not found':
        return const ServerFailure('هذا الحساب غير موجود.');
      default:
        if (error.message.contains('rate limit') || error.statusCode == '429') {
          return const ServerFailure(
            'تم تجاوز عدد المحاولات المسموح بها، يرجى الانتظار قليلاً.',
          );
        }
        return ServerFailure(error.message);
    }
  }

  // 3. معالجة الأخطاء العامة أو انقطاع الإنترنت (General / Dynamic)
  factory ServerFailure.fromGeneric(dynamic error) {
    if (error is PostgrestException) {
      return ServerFailure.fromPostgrest(error);
    } else if (error is AuthException) {
      return ServerFailure.fromAuth(error);
    } else if (error.toString().contains('SocketException') ||
        error.toString().contains('ClientException')) {
      return const ServerFailure(
        'لا يوجد اتصال بالإنترنت، يرجى التحقق من الشبكة.',
      );
    } else {
      return const ServerFailure('حدث خطأ غير متوقع، يرجى المحاولة لاحقاً.');
    }
  }
}
