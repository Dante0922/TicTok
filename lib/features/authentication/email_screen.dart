import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/password_screen.dart';

import 'widgets/form_button.dart';

class EmailScreenArgs {
  final String username;

  EmailScreenArgs({required this.username});
}

class EmailScreen extends StatefulWidget {
  static String routeName = "/email";

  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final TextEditingController _emailController =
      TextEditingController(); //Controller 선언

  String _email = "";

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      //컨트롤러의 값이 바뀔 때마다 setState를 작동
      setState(() {
        _email = _emailController.text; //_email 값을 컨트롤러.text로 변경.
      });
    });
  }

  @override
  void dispose() {
    _emailController
        .dispose(); //컨트롤런느 dispose하지 않으면 계속 값을 갖고 있기 때문에 메모리를 위해 꼭 해줘야 함.
    super.dispose();
  }

  String? _isEmailValid() {
    if (_email.isEmpty) return null;
    final regExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"); //정규식? 이메일 양식이 맞는지 판단해준다.
    if (!regExp.hasMatch(_email)) {
      //정규식.hasMatch를 통해 _email의 양식이 정규식에 부합하는지 체크.
      return "Email not vaild";
    }

    return null;
  }

  void _onSubmit() {
    if (_email.isEmpty || _isEmailValid() != null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PasswordScreen(),
      ),
    );
  }

  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as EmailScreenArgs;
    print(args.username);
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
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
              Text(
                "What is your email? ${args.username}",
                style: const TextStyle(
                  fontSize: Sizes.size24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v16,
              TextField(
                controller: _emailController,
                cursorColor: Theme.of(context).primaryColor,
                keyboardType: TextInputType.emailAddress,
                onEditingComplete:
                    _onSubmit, //이 함수를 지정함으로써 키보드의 완료를 눌렀을 때 _onSubmit 함수가 발동할 수 있도록 해준다.
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: "Email",
                  errorText: _isEmailValid(),
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
                onTap: _onSubmit,
                child: FormButton(
                    disabled: _email.isEmpty || _isEmailValid() != null,
                    text: "Next"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
