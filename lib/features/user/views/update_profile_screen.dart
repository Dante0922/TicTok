import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/features/authentication/widgets/form_button.dart';
import 'package:tiktok_clone/features/user/view_models/users_view_model.dart';

class UpdateProfileScreen extends ConsumerStatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends ConsumerState<UpdateProfileScreen> {
  final TextEditingController _introController = TextEditingController();
  final TextEditingController _homepageController = TextEditingController();
  String _introduction = "";
  String _homepage = "";

  @override
  void initState() {
    _introController.addListener(() {
      setState(() {
        _introduction = _introController.text;
      });
    });
    _homepageController.addListener(() {
      setState(() {
        _homepage = _homepageController.text;
      });
    });
    super.initState();
  }

  void _onSubmit() {
    ref.read(usersProvider.notifier).onIntroUpload(
          _introduction,
          _homepage,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("소개글과 홈페이지를 등록하세요."),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(children: [
        Gaps.v16,
        TextField(
          controller: _introController,
          cursorColor: Theme.of(context).primaryColor,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          decoration: InputDecoration(
            hintText: "Introduction",
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
        Gaps.v40,
        TextField(
          controller: _homepageController,
          cursorColor: Theme.of(context).primaryColor,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          decoration: InputDecoration(
            hintText: "homepage",
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
          child: const FormButton(disabled: false, text: "Next"),
        ),
      ]),
    );
  }
}
