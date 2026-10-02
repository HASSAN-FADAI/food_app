import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hunhry_food/features/auth/cubit/auth_cubit.dart';
import 'package:hunhry_food/features/auth/view/login_view.dart';
import 'package:hunhry_food/features/auth/view/signup_view.dart';
import 'package:hunhry_food/features/cart/cubit/cart_cubit.dart';
import 'package:hunhry_food/features/home/cubit/home_cubit.dart';
import 'package:hunhry_food/features/home/views/home_view.dart';
import 'package:hunhry_food/features/home/views/product_details_view.dart';
import 'package:hunhry_food/features/oreders/cubit/orders_cubit.dart';
import 'package:hunhry_food/root.dart';
import 'package:hunhry_food/splash.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  try {
    await dotenv.load();
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      publishableKey: dotenv.env['SUPABASE_ANONE_KEY']!,
    );
  } on Exception catch (e) {
    print(e);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => OrdersCubit()),
      ],
      child: MaterialApp(
        title: 'Hungry',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          splashColor: Colors.transparent,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: SplashView(),
      ),
    );
  }
}
