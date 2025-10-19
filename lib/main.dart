import 'package:flutter/material.dart';
import 'package:monexa_app/common/app_theme.dart';
import 'package:monexa_app/common/theme_manager.dart';
import 'package:monexa_app/services/transaction_service.dart';
import 'package:monexa_app/view/login/welcome_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    // CRITICAL FIX: MultiProvider untuk TransactionService dan ThemeManager
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeManager()),
        ChangeNotifierProvider(create: (context) => TransactionService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    
    return MaterialApp(
      title: 'Monexa',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeManager.themeMode,
      home: const WelcomeView(),
    );
  }
}

