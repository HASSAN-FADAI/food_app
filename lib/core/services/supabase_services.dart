import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseServices {
  static SupabaseClient get client => Supabase.instance.client;
  //معرف المستخدم
  static String? get currentUserId => client.auth.currentUser?.id;

  static bool get isAuthenticated => client.auth.currentUser != null;
}
