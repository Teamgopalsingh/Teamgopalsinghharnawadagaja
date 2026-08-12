import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'constants/app_colors.dart';
import 'constants/app_theme.dart';
import 'constants/localization.dart';
import 'services/supabase_service.dart';
import 'services/offline_cache_service.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/complaint_screen.dart';
import 'screens/development_screen.dart';
import 'screens/officer_directory_screen.dart';
import 'screens/election_center_screen.dart';
import 'screens/harnawada_gaja_screen.dart';
import 'screens/schemes_screen.dart';
import 'screens/surya_mandir_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI style for Royal Navy bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.royalNavy,
      statusBarIconBrightness: Brightness.light,
      navigationBarColor: AppColors.royalNavy,
      navigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize Supabase safely
  await SupabaseService().initialize(
    url: 'https://placeholder-supabase-url.supabase.co',
    anonKey: 'placeholder-anon-key',
  );

  // Load language preference
  final savedLang = await OfflineCacheService.getLanguagePreference();
  AppStrings.currentLang = savedLang;

  runApp(const TeamGopalSinghApp());
}

class TeamGopalSinghApp extends StatelessWidget {
  const TeamGopalSinghApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'टीम गोपालसिंह - हरनावदा गजा',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('hi', 'IN'),
        Locale('en', 'US'),
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const MainContainerScreen(),
        '/complaint': (context) => const ComplaintScreen(),
        '/development': (context) => const DevelopmentScreen(),
        '/directory': (context) => const OfficerDirectoryScreen(),
        '/election': (context) => const ElectionCenterScreen(),
        '/harnawada': (context) => const HarnawadaGajaScreen(),
        '/schemes': (context) => const SchemesScreen(),
        '/surya_mandir': (context) => const SuryaMandirScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
