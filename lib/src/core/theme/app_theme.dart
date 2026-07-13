import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/routing_service/named_routes.dart';
import '../theme/app_colors.dart';
import '../theme/no_transitions_builder.dart';
import '../utils/app_size.dart';

mixin AppTheme on AppSize {
  ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(
          TextTheme(
            labelSmall: TextStyle(
              fontSize: labelSmall, //
              color: AppColors.primaryText,
              fontWeight: FontWeight.w600,
            ),
            bodySmall: TextStyle(
              fontSize: bodySmall,
              color: AppColors.primaryText,
              fontWeight: FontWeight.w400,
            ),
            displaySmall: TextStyle(
              fontSize: displaySmall,
              color: AppColors.primaryText,
              fontWeight: FontWeight.w500,
            ),
            titleSmall: TextStyle(
              fontSize: titleSmall,
              color: AppColors.primaryText,
              fontWeight: FontWeight.w400,
            ),
            titleMedium: TextStyle(
              fontSize: titleMedium,
              color: AppColors.primaryText,
              fontWeight: FontWeight.w400,
            ),
            bodyMedium: TextStyle(
              fontSize: bodyMedium,
              color: AppColors.primaryText,
              fontWeight: FontWeight.w600,
            ),
            bodyLarge: TextStyle(
              fontSize: bodyLarge,
              color: AppColors.primaryText,
              fontWeight: FontWeight.w700,
            ),
            labelMedium: TextStyle(
              fontSize: labelMedium,
              color: AppColors.primaryText,
              fontWeight: FontWeight.w500,
            ),
            labelLarge: TextStyle(
              fontSize: labelLarge,
              color: AppColors.primaryText,
              fontWeight: FontWeight.w500,
            ),
            displayMedium: TextStyle(
              fontSize: displayMedium,
              color: AppColors.primaryText,
              fontWeight: FontWeight.w600,
            ),
            displayLarge: TextStyle(
              fontSize: displayLarge,
              color: AppColors.primaryText,
              fontWeight: FontWeight.w700,
            ),
            titleLarge: TextStyle(
              fontSize: titleLarge,
              color: AppColors.primaryText,
              fontWeight: FontWeight.w600,
            ),
            headlineSmall: TextStyle(
              fontSize: headlineSmall,
              color: AppColors.primaryText,
              fontWeight: FontWeight.w600,
            ),
            headlineMedium: TextStyle(
              fontSize: headlineMedium,
              color: AppColors.primaryText,
              fontWeight: FontWeight.w700,
            ),
            headlineLarge: TextStyle(
              fontSize: headlineLarge,
              color: AppColors.primaryText,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        drawerTheme:
            const DrawerThemeData(backgroundColor: AppColors.drawerGreen),
        scaffoldBackgroundColor: AppColors.signInLightBackground,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          linearMinHeight: 4,
          color: AppColors.backgroundPrimary,
          // linearTrackColor: AppColors.backgroundPrimary,
          circularTrackColor: AppColors.drawerGreen,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryRed),
        dividerColor: AppColors.signInDarkDivider,
        dividerTheme: const DividerThemeData(
          color: AppColors.signInDarkDivider,
          thickness: 1,
          space: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.inputFieldLightFill,
          hintStyle: TextStyle(
            fontSize: labelLarge,
            color: AppColors.signInLightText,
            fontWeight: FontWeight.w400,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.inputFieldLightBorder,
              width: 1.088,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.inputFieldLightBorder,
              width: 1.088,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.primaryRed,
              width: 1.088,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.inputFieldLightBorder,
              width: 1.088,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryRed,
            foregroundColor: AppColors.primaryWhite,
            disabledBackgroundColor: AppColors.inactiveGray,
            disabledForegroundColor: AppColors.inactiveGray,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.signInLightBackground,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: NoTransitionsBuilder(),
            TargetPlatform.iOS: NoTransitionsBuilder(),
            TargetPlatform.windows: NoTransitionsBuilder(),
            TargetPlatform.macOS: NoTransitionsBuilder(),
            TargetPlatform.linux: NoTransitionsBuilder(),
            TargetPlatform.fuchsia: NoTransitionsBuilder(),
          },
        ),
      );

  ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        drawerTheme: const DrawerThemeData(
            // backgroundColor: AppColors.drawerGreen,
            ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.signInDarkBackground,
        ),
        scaffoldBackgroundColor: AppColors.signInDarkBackground,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.backgroundPrimary,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryRed,
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.interTextTheme(
          TextTheme(
            labelSmall: TextStyle(
              fontSize: labelSmall,
              color: AppColors.primaryWhite,
              fontWeight: FontWeight.w600,
            ),
            bodySmall: TextStyle(
              fontSize: bodySmall,
              color: AppColors.primaryWhite,
              fontWeight: FontWeight.w400,
            ),
            displaySmall: TextStyle(
              fontSize: displaySmall,
              color: AppColors.primaryWhite,
              fontWeight: FontWeight.w500,
            ),
            titleSmall: TextStyle(
              fontSize: titleSmall,
              color: AppColors.primaryWhite,
              fontWeight: FontWeight.w400,
            ),
            titleMedium: TextStyle(
              fontSize: titleMedium,
              color: AppColors.primaryWhite,
              fontWeight: FontWeight.w400,
            ),
            bodyMedium: TextStyle(
              fontSize: bodyMedium,
              color: AppColors.primaryWhite,
              fontWeight: FontWeight.w600,
            ),
            bodyLarge: TextStyle(
              fontSize: bodyLarge,
              color: AppColors.primaryWhite,
              fontWeight: FontWeight.w700,
            ),
            labelMedium: TextStyle(
              fontSize: labelMedium,
              color: AppColors.primaryWhite,
              fontWeight: FontWeight.w600,
            ),
            labelLarge: TextStyle(
              fontSize: labelLarge,
              color: AppColors.primaryWhite,
              fontWeight: FontWeight.w600,
            ),
            displayMedium: TextStyle(
              fontSize: displayMedium,
              color: AppColors.primaryWhite,
              fontWeight: FontWeight.w600,
            ),
            displayLarge: TextStyle(
              fontSize: displayLarge,
              color: AppColors.primaryWhite,
              fontWeight: FontWeight.w700,
            ),
            titleLarge: TextStyle(
              fontSize: titleLarge,
              color: AppColors.primaryWhite,
              fontWeight: FontWeight.w600,
            ),
            headlineSmall: TextStyle(
              fontSize: headlineSmall,
              color: AppColors.primaryWhite,
              fontWeight: FontWeight.w600,
            ),
            headlineMedium: TextStyle(
              fontSize: headlineMedium,
              color: AppColors.primaryWhite,
              fontWeight: FontWeight.w700,
            ),
            headlineLarge: TextStyle(
              fontSize: headlineLarge,
              color: AppColors.primaryWhite,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.primaryOrange,
          // linearTrackColor: AppColors.secondaryGold,
          // circularTrackColor: AppColors.secondaryGold,
        ),
        iconTheme: const IconThemeData(color: AppColors.iconColor),
        dividerColor: AppColors.signInDarkDivider,
        dividerTheme: const DividerThemeData(
          color: AppColors.signInDarkDivider,
          thickness: 1,
          space: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.signInDarkSurface,
          hintStyle: TextStyle(
            fontSize: labelLarge,
            color: AppColors.hintGray,
            fontWeight: FontWeight.w400,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.signInDarkBorder,
              width: 1.088,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.signInDarkBorder,
              width: 1.088,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.primaryRed,
              width: 1.088,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.signInDarkBorder,
              width: 1.088,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryRed,
            foregroundColor: AppColors.primaryWhite,
            disabledBackgroundColor: AppColors.inactiveGray,
            disabledForegroundColor: AppColors.inactiveGray,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      );
}

ThemeData get theme => Theme.of(AppRouterGo.context);
