import 'package:joshua_r_hughes/src/core/utils/app_exports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // final fcmToken = await FirebaseMessaging.instance.getToken();
  // appPrint("FCM Token: $fcmToken");
  await dotenv.load(fileName: ".env").then((value) async {
    setupLocator();
    await locator<NotificationService>().requestPermission();
    await locator<NotificationService>().init();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]).then((value) {
      runApp(ProviderScope(child: JoshuaRHughes()));
    });
  });
}

class JoshuaRHughes extends ConsumerWidget with AppSize, AppTheme {
  const JoshuaRHughes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: MediaQuery.sizeOf(context).width < 600.0
          ? const Size(440, 956)
          : Size(
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height,
            ),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        final appThemeController = ref.watch(appThemeControllerProvider);
        return MaterialApp.router(
          routerConfig: AppRouterGo.appRouter,
          title: AppStrings.nextNLine,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: appThemeController.themeMode,
          // themeMode: ThemeMode.light,
          builder: (context, child) {
            final mediaQueryData = MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.noScaling);
            return MediaQuery(
              data: mediaQueryData,
              child: SafeArea(
                top: false,
                left: false,
                right: false,
                bottom: Platform.isAndroid ? true : false,
                child: child!,
              ),
            );
          },
        );
      },
    );
  }
}
