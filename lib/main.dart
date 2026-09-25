import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'menu.dart';
import 'screens/home_screen.dart';
import 'screens/route_screen.dart';
import 'screens/alerts_screen.dart';
import 'screens/profile_screen.dart';

// Global Theme Switcher State
ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('si'),
        Locale('ta'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Driver App',

          // Easy Localization Setup
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,

          // 1. Light Theme Setup
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1E3A8A),
              brightness: Brightness.light,
              surface: Colors.white,
            ),
            cardColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1E3A8A),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
          ),

          // 2. Dark Theme Setup
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF121212),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1E3A8A),
              brightness: Brightness.dark,
              surface: const Color(0xFF1E1E1E),
            ),
            cardColor: const Color(0xFF1E1E1E),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1F1F1F),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
          ),

          themeMode: currentMode,
          home: const MainNavigationScreen(),
        );
      },
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  List<String> get _titles => [
        'Driver Dashboard'.tr(),
        'Route'.tr(),
        'Alerts'.tr(),
        'Profile'.tr(),
      ];

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(onNavigate: _onTabSelected),
      const RouteScreen(),
      const AlertsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => _onTabSelected(2),
          ),
        ],
      ),
      drawer: Menu(onSelectTab: _onTabSelected),
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'Home'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.map),
            label: 'Map'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.notifications),
            label: 'Alerts'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: 'Profile'.tr(),
          ),
        ],
      ),
    );
  }
}