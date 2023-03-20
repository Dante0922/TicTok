import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiktok_clone/constants/sizes.dart';

import "package:flutter_localizations/flutter_localizations.dart";
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/router.dart';

void main() async {
  //Flutter엔진과 framework를 묶는 접착제
  WidgetsFlutterBinding.ensureInitialized();

  // Orientation을 portraitUp으로 고정한다.
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  // 상단 시간, 와이파이, 배터리 등의 색상을 dart/white로 바꾼다.
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark,
  );

  runApp(const TicTokApp());
}

class TicTokApp extends StatelessWidget {
  const TicTokApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // S.load(const Locale("en")); // 앱의 언어 설정을 원하는 값으로 변경한다.
    return MaterialApp.router(
      routerConfig:
          router, // Go_Router를 사용하기 위해 MaterialApp.router + routeConfig를 설정해주자.
      debugShowCheckedModeBanner: false,
      title: 'TicTok Clone',
      themeMode: ThemeMode.system, // 시스템의 화이트/다크 모드에 따라 앱의 모드 변경
      localizationsDelegates: const [
        S.delegate, // intl 임포트
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [
        // 지원할 언어 목록
        Locale("en"),
        Locale("ko"),
      ],
      //localizationsDelegates: AppLocalizations.localizationsDelegates,
      //  const [
      //   // widget 중 이미 텍스트를 가지고 있는 위젯이 있다.
      //   // 플러터는 이 위젯들의 번역을 이미 가지고 있다.
      //   // 아래 Global 들이 그 번역
      //   AppLocalizations.delegate, // 직접 지정한 번역 정보를 호출하는 값.

      // ],
      // supportedLocales: AppLocalizations.supportedLocales,

      theme: ThemeData(
        useMaterial3: true, // Material3는 아직 개발이 완료되진 않았다.
        //이렇게 true 처리하면 Material3가 적용된다.
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        // bottomAppBarTheme: BottomAppBarTheme(
        // 모든 바텀앱바의 띰을 설정할 수 있음.
        //   color: Colors.grey.shade50,
        // ),
        // textTheme: TextTheme(
        //   // metarial 사이트에서 원하는 textTheme를 한번에 불러올 수 있다.
        //   // 노마드 틱톡강의 15.2 참고
        //   displayLarge: GoogleFonts.openSans(
        //       fontSize: 94, fontWeight: FontWeight.w300, letterSpacing: -1.5),
        //   displayMedium: GoogleFonts.openSans(
        //       fontSize: 59, fontWeight: FontWeight.w300, letterSpacing: -0.5),
        //   displaySmall:
        //       GoogleFonts.openSans(fontSize: 47, fontWeight: FontWeight.w400),
        //   headlineMedium: GoogleFonts.openSans(
        //       fontSize: 33, fontWeight: FontWeight.w400, letterSpacing: 0.25),
        //   headlineSmall:
        //       GoogleFonts.openSans(fontSize: 24, fontWeight: FontWeight.w400),
        //   titleLarge: GoogleFonts.openSans(
        //       fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
        //   titleMedium: GoogleFonts.openSans(
        //       fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
        //   titleSmall: GoogleFonts.openSans(
        //       fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
        //   bodyLarge: GoogleFonts.roboto(
        //       fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
        //   bodyMedium: GoogleFonts.roboto(
        //       fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
        //   labelLarge: GoogleFonts.roboto(
        //       fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
        //   bodySmall: GoogleFonts.roboto(
        //       fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
        //   labelSmall: GoogleFonts.roboto(
        //       fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
        // ),
        // 구글폰트에 가서 원하는 폰트명을 GoogleFonts.폰트명TextTheme()을 통해
        // 한번에 적용할 수 있다.
        // textTheme: GoogleFonts.itimTextTheme(),
        textTheme: Typography
            .blackMountainView, // font와 색상은 제공하지만 weight, height, space, size 등은 지정 안 함.
        primaryColor: const Color(0xFFE9435A),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(
              0xFFE9435A), //쿠퍼티노서치 같은 위젯은 기본 커서컬러가 안 바뀌지만, main.dart에서 이런 방식으로 기본 색상을 지정해줄 순 있다.
        ),
        tabBarTheme: TabBarTheme(
          unselectedLabelColor: Colors.grey.shade500, // 선택안 된 바의 색상
          labelColor: Colors.black, // 선택된 바의 색상),
          indicatorColor: Colors.black, // 선택됐을 때 하단 표시구분의 색상
        ),
        splashColor:
            Colors.transparent, //버튼을 눌렀을 때 퍼지는 Splash효과를 막고 싶다면 이 옵션을 지정해주면 된다.
        // highlightColor: Colors.transparent,  꾹 눌렀을 때 나타나는 색상변화를 없애고 싶다면 이 옵션을 설정.
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.black,
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: Sizes.size16 + Sizes.size2,
            fontWeight: FontWeight.w600,
          ),
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: Colors.black,
        ),
      ),
      darkTheme: ThemeData(
          useMaterial3: true,
          // Theme을 설정하듯 dark모드 theme도 설정할 수 있다.
          brightness: Brightness.dark, // 기본 글씨체를 지정하는 옵션
          // 구글폰트.Theme에 Dark모드의 brightness를 적용해줄 수도 있다.
          // 단, 많은 폰트가 있지만 모든 폰트가 있는 것은 아니다.
          // textTheme: GoogleFonts.itimTextTheme(
          //     ThemeData(brightness: Brightness.dark).textTheme),
          tabBarTheme: TabBarTheme(
            indicatorColor: Colors.white,
            labelColor: Colors.white, // 선택된 바의 색상),
            unselectedLabelColor: Colors.grey.shade700,
          ),
          appBarTheme: AppBarTheme(
            actionsIconTheme: IconThemeData(
              color: Colors.grey.shade100,
            ),
            iconTheme: IconThemeData(
              color: Colors.grey.shade100,
            ),
            surfaceTintColor: Colors.grey.shade900,
            backgroundColor: Colors.grey.shade900,
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: Sizes.size16 + Sizes.size2,
              fontWeight: FontWeight.w600,
            ),
          ),
          textTheme:
              Typography.whiteMountainView, // font와 색상은 제공하지만 size는 지정 안 함.
          scaffoldBackgroundColor: Colors.black,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xFFE9435A),
          ),
          primaryColor: const Color(0xFFE9435A),
          bottomAppBarTheme: BottomAppBarTheme(
            color: Colors.grey.shade900,
          )),
      //home: const SignUpScreen(),
      // initialRoute: SignUpScreen.routeName,
      // routes: {
      //   // 실수를 방지하기 위해 static 변수를 정의해서 사용
      //   SignUpScreen.routeName: (context) => const SignUpScreen(),
      //   UsernameScreen.routeName: (context) => const UsernameScreen(),
      //   LoginScreen.routeName: (context) => const LoginScreen(),
      //   EmailScreen.routeName: (context) => const EmailScreen(),
      // },
    );
  }
}

class LayoutBuilderCodeLab extends StatelessWidget {
  const LayoutBuilderCodeLab({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width / 2,
        child: LayoutBuilder(
          // LayoutBuilder는 부모의 크기를 반환해준다.
          // MediaQuery와 혼동하지 말 것!!
          builder: (context, constraints) => Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            color: Colors.teal,
            child: Center(
              child: Text("${size.width} / ${constraints.maxWidth}"),
            ),
          ),
        ),
      ),
    );
  }
}
