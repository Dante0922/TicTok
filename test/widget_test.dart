import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiktok_clone/features/authentication/widgets/form_button.dart';

void main() {
  group("Form Button Tests", () {
    testWidgets("Enabled State", (WidgetTester tester) async {
      await tester.pumpWidget(
        const Directionality(
          // FormButton 등은 Directionality가 필요하다! 부모의 크기 등에 의존적.
          textDirection: TextDirection.ltr,
          child: FormButton(disabled: false, text: "test"),
        ),
      );
      expect(find.text("test"), findsOneWidget);
      expect(
          tester
              .firstWidget<AnimatedDefaultTextStyle>(
                  find.byType(AnimatedDefaultTextStyle))
              .style
              .color,
          Colors.white);
    });
    testWidgets("Disabled State", (WidgetTester tester) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(),
          child: Directionality(
            // FormButton 등은 Directionality가 필요하다! 부모의 크기 등에 의존적.
            textDirection: TextDirection.ltr,
            child: FormButton(disabled: true, text: "test"),
          ),
        ),
      );
      expect(find.text("test"), findsOneWidget);
      expect(
          tester
              .firstWidget<AnimatedDefaultTextStyle>(
                  find.byType(AnimatedDefaultTextStyle))
              .style
              .color,
          Colors.grey.shade400);
    });

    testWidgets("Dislbed state DarkMode", (WidgetTester tester) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(
            platformBrightness: Brightness.dark, // 테스트를 위해 강제한다.
          ),
          child: Directionality(
            // FormButton 등은 Directionality가 필요하다! 부모의 크기 등에 의존적.
            textDirection: TextDirection.ltr,
            child: FormButton(disabled: true, text: "test"),
          ),
        ),
      );
      expect(
          (tester
                  .firstWidget<AnimatedContainer>(
                      find.byType(AnimatedContainer))
                  .decoration as BoxDecoration)
              .color,
          Colors.grey.shade800);
    });

    testWidgets("Dislbed state LightMode", (WidgetTester tester) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(
            platformBrightness: Brightness.light, // 테스트를 위해 강제한다.
          ),
          child: Directionality(
            // FormButton 등은 Directionality가 필요하다! 부모의 크기 등에 의존적.
            textDirection: TextDirection.ltr,
            child: FormButton(disabled: true, text: "test"),
          ),
        ),
      );
      expect(
          (tester
                  .firstWidget<AnimatedContainer>(
                      find.byType(AnimatedContainer))
                  .decoration as BoxDecoration)
              .color,
          Colors.grey.shade300);
    });
  });
}
