import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/view_models/signup_view_model.dart';
import 'package:tiktok_clone/features/authentication/widgets/form_button.dart';

class BirthdayScreen extends ConsumerStatefulWidget {
  const BirthdayScreen({super.key});

  @override
  ConsumerState<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends ConsumerState<BirthdayScreen> {
  final TextEditingController _birthdayController = TextEditingController();

  DateTime initialDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    DateTime twelveYearsAgo = DateTime(initialDate.year -
        12); //DateTime() 파라미터로 DateTimeSample.year -12 를 하면 12년 전 DateTimeSample의 날짜를 반환한다.
    _setTextFieldDate(twelveYearsAgo);
  }

  @override
  void dispose() {
    _birthdayController.dispose();
    super.dispose();
  }

  void _onNextTap() {
    //Navigator함수를 통해 다른 화면으로 보낼 수 있다.  push와 pushAndRemoveUntil, Pop이 있는데, Push는 하나의 새로운 화면 스택을 생성해 뒤로갈 수 있고, Pop는 현재 화면을 삭제해서 뒤로 보낸다.
    //PushAndRemoveUntil은 현재까지의 모든 Push화면을 삭제하고 뒤로갈 수 없는 새로운 화면을 띄운다.
    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(
    //       builder: (context) => const InterestsScreen(),
    //     ), (route) {
    //   return false;
    // });
    ref.read(signUpProvider.notifier).signUp(context);
    //   context.pushReplacementNamed(
    //       InterestsScreen.routeName); // 지난 화면들을 다 없애고 새로운 화면만 남겨둔다.
  }

  void _setTextFieldDate(DateTime date) {
    final textDate = date.toString().split(" ").first;
    _birthdayController.value = TextEditingValue(
        text:
            textDate); //Controller.value를 통해 해당 Controller가 컨트롤하는 영역의 Value를 바꿀 수 있다.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sign Up",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size36,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v40,
            const Text(
              "When is your birthday",
              style: TextStyle(
                fontSize: Sizes.size24,
                fontWeight: FontWeight.w700,
              ),
            ),
            Gaps.v8,
            const Text(
              "Your birthday won't be shown publicly.",
              style: TextStyle(
                fontSize: Sizes.size16,
                color: Colors.black54,
              ),
            ),
            Gaps.v16,
            TextField(
              controller:
                  _birthdayController, // 이 텍스트필드는 이 컨트롤러를 통해 제어된다. 하단의 데이트픽커를 통해 Controller.value가 바뀌면 텍스트필드의 값이 바뀐다.
              cursorColor: Theme.of(context).primaryColor,
              decoration: InputDecoration(
                enabled: false,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ),
            Gaps.v16,
            GestureDetector(
              onTap: _onNextTap,
              child: FormButton(
                disabled: ref.watch(signUpProvider).isLoading,
                text: "Next",
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        //하단위젯은 BottomAppBar
        child: SizedBox(
          height: 300,
          child: CupertinoDatePicker(
            //애플디자인의 날짜 선택 위젯.
            onDateTimeChanged: _setTextFieldDate,
            mode: CupertinoDatePickerMode.date, //이 옵션을 통해 구성을 바꿀 수 있다.
            maximumDate: initialDate, //가능한 한계 일자
            initialDateTime: initialDate, //최초 시작 일자
          ),
        ),
      ),
    );
  }
}
