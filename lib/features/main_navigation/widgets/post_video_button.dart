import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../constants/sizes.dart';

class PostVideoButton extends StatefulWidget {
  const PostVideoButton({
    super.key,
    required this.onTapFunction,
    required this.inverted,
  });
  final void Function(BuildContext) onTapFunction;
  final bool inverted;

  @override
  State<PostVideoButton> createState() => _PostVideoButtonState();
}

class _PostVideoButtonState extends State<PostVideoButton> {
  bool _isClicked = false;

  void onLongPressFunction(TapDownDetails context) {
    setState(() {
      _isClicked = !_isClicked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTapFunction(context),
      onTapDown: onLongPressFunction,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            //스택의 자식으로 위치를 따로 지정할 수 있도록 해주는 위젯 right 20 과 같이 처리하려면 기준이 있으여 한다. 여기선 Container가 기준.
            right: 20,
            child: Container(
              height: 30,
              width: 24,
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size8,
              ),
              decoration: BoxDecoration(
                color: _isClicked
                    ? Theme.of(context).primaryColor
                    : const Color(0xFF61D4F0),
                borderRadius: BorderRadius.circular(
                  Sizes.size8,
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            child: Container(
              height: 30,
              width: 24,
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size8,
              ),
              decoration: BoxDecoration(
                color: _isClicked
                    ? const Color(0xFF61D4F0)
                    : Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(
                  Sizes.size8,
                ),
              ),
            ),
          ),
          Container(
            height: 30,
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size12,
            ),
            decoration: BoxDecoration(
              color: widget.inverted ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(
                Sizes.size6,
              ),
            ),
            child: Center(
              child: FaIcon(
                FontAwesomeIcons.plus,
                color: widget.inverted ? Colors.white : Colors.black,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
