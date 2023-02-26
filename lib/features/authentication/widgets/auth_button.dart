import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final FaIcon icon;
  final void Function(BuildContext) onTapFunction;

  const AuthButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onTapFunction,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapFunction(context),
      child: FractionallySizedBox(
        //상위 부모의 사이즈에 맞춰 SizedBox가 생성되는 위젯.
        widthFactor: 1, //부모의 사이즈의 0~1비율에 맞춰 사이즈를 정하는 팩터.
        child: Container(
          padding: const EdgeInsets.all(
            Sizes.size14,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
              width: Sizes.size1,
            ),
          ),
          child: Stack(
            //Stack은 말 그대로 하위 자식들을 겹겹이 쌓는 위젯.
            alignment: Alignment.center,
            children: [
              Align(
                //자식 위젯을 원하는 방향으로 정리하고 싶을 때 쓰는 위젯. 아이콘을 왼쪽으로 붙임.
                alignment: Alignment.centerLeft,
                child: icon,
              ),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: Sizes.size16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
