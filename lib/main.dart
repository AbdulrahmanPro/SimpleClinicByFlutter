import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider_mvvm/view/splash_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRUD App with MVVM & Riverpod',
      theme: AppTheme.lightTheme,
      home: const Center(child: SplashScreen()),
    );
  }
}

class AppTheme {
  // 🎨 ألوان التطبيق
  static const Color primaryColor = Color(0xFF4CAF50); // لون أخضر هادئ
  static const Color secondaryColor = Color(0xFF388E3C); // لون أخضر غامق
  static const Color backgroundColor = Color(0xFFF1F8E9); // خلفية فاتحة
  static const Color cardBackgroundColor = Color(0xFFFFFFFF); // خلفية البطاقات
  static const Color textColor = Color(0xFF212121); // لون النص الأساسي
  static const Color tileHoverColor = Color(0xFFE8F5E9); // لون تمرير
  static const Color accentColor = Color(0xFFFFA000); // لون مميز (برتقالي)
  static const Color errorColor = Color(0xFFD32F2F); // لون الخطأ

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true, // استخدام Material 3 للحصول على تجربة حديثة

    // الألوان الأساسية
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,

    // تخصيص مخطط الألوان
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: cardBackgroundColor,
      background: backgroundColor,
      error: errorColor,
    ),

    // تخصيص شريط التطبيق (AppBar)
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
      centerTitle: true,
      titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),

    // تخصيص زر الإضافة العائم (FAB)
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),

    // تخصيص النصوص
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 18, color: textColor),
      bodyMedium: TextStyle(fontSize: 16, color: textColor),
      bodySmall: TextStyle(fontSize: 14, color: textColor),
      titleLarge: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
    ),

    // تخصيص الأزرار
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),

    // تخصيص إدخال البيانات (TextField)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: secondaryColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      labelStyle: const TextStyle(color: secondaryColor),
      prefixIconColor: secondaryColor,
    ),

    // 🔹 تحسين تصميم ListTile
    listTileTheme: ListTileThemeData(
      tileColor: Colors.green.withOpacity(0.2), // 💦 تأثير الضغط
      selectedTileColor: Color(0xFF80CBC4), // 🟢 تأثير الضغط بلون أغمق قليلاً
      textColor: Color(0xFF212121), // ⚫ لون النص الأساسي (أسود داكن)
      iconColor: primaryColor, // 🟢 أيقونات بالأخضر الغامق
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // 🔲 جعل الزوايا مستديرة
      ),
    ),

    // تخصيص القوائم المنسدلة (Dropdown Menu)
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(cardBackgroundColor),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        )),
      ),
      textStyle: const TextStyle(color: textColor),
    ),

    // 🔹 تخصيص SnackBar
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: primaryColor,
      contentTextStyle: TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
  );
}
