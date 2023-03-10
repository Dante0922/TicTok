import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = false;

  void _onNotificationsChanged(bool? newValue) {
    if (newValue == null) return;
    setState(() {
      _notifications = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Breakpoints.md),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
          ),
          body: ListView(
            children: [
              Switch.adaptive(
                // 플랫폼에 따라 모양이 변경되는 스위치
                value: _notifications,
                onChanged: _onNotificationsChanged,
              ),
              CupertinoSwitch(
                value: _notifications,
                onChanged: _onNotificationsChanged,
              ),
              Switch(
                // 스위치 위젯
                value: _notifications,
                onChanged: _onNotificationsChanged,
              ),
              SwitchListTile.adaptive(
                // 플랫폼에 따라 Tile 형태가 변경되는 위젯
                // 매우매우 유용하다!!
                value: _notifications,
                onChanged: _onNotificationsChanged,
                title: const Text("adaptive"),
                subtitle: const Text("very cool"),
              ),
              SwitchListTile(
                value: _notifications,
                onChanged: _onNotificationsChanged,
                title: const Text("Enable notifications"),
              ),
              Checkbox(
                //체크박스 위젯
                value: _notifications,
                onChanged: _onNotificationsChanged,
              ),
              CheckboxListTile(
                // 체크박스를 만드는 위젯
                value: _notifications,
                onChanged: _onNotificationsChanged,
                title: const Text("Enable notifications"),
                checkColor: Colors.white,
                activeColor: Colors.black,
              ),
              ListTile(
                onTap: () async {
                  final date = await showDatePicker(
                    // 안드로이드 스타일의 달력을 띄워주는 함수. Future로 Date값을 반환해준다.
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1980),
                    lastDate: DateTime(2030),
                  );
                  print(date);
                  final time = await showTimePicker(
                    // 안드로이드 스타일의 날짜를 띄워주는 함수.
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  print(time);
                  final booking = await showDateRangePicker(
                    // Airbnb처럼 시작일-종료일을 선택해야할 떄 유용한 함수
                    context: context,
                    firstDate: DateTime(1980),
                    lastDate: DateTime(2030),
                    builder: (context, child) {
                      return Theme(
                          data: ThemeData(
                              appBarTheme: const AppBarTheme(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black,
                          )),
                          child: child!);
                    },
                  );
                  print(booking);
                },
                title: const Text('What is your birthday?'),
              ),
              // 앱을 출시하기 위해선 오픈소스 라이브러리를 꼭 제공해야 한다.
              // 아래의 showAboutDialog() 나 AboutListTile 위젯은 자동으로 오픈소스 정보를 모아서 제공한다.
              // 굉장히 유용하니 꼭 활용해보자
              const AboutDialog(),
              ListTile(
                onTap: () => showAboutDialog(
                    context: context,
                    applicationVersion: "1.0",
                    applicationLegalese:
                        "All rights reserved. Please dont copy me"),
                title: const Text(
                  'About',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text('About this app...'),
              ),
              ListTile(
                // 로그아웃 알림창
                title: const Text("Log out(iOS)"),
                textColor: Colors.red,
                onTap: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      // 애플 스타일의 확인 창 팝업
                      title: const Text("Are you sure?"),
                      content: const Text("Plx dont go"),
                      actions: [
                        CupertinoDialogAction(
                          //애플 스타일의 Y/N 선택 액션
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("No"),
                        ),
                        CupertinoDialogAction(
                          onPressed: () => Navigator.of(context).pop(),
                          isDefaultAction: true,
                          child: const Text("Yes"),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ListTile(
                // 애플스타일을 약간만 변형하면 안드로이드 스타일의 로그아웃창이 된다.
                title: const Text("Log out(Android)"),
                textColor: Colors.red,
                onTap: () {
                  showDialog(
                    // 조금씩 다름
                    context: context,
                    builder: (context) => AlertDialog(
                      // 조금씩 다름
                      icon: const FaIcon(FontAwesomeIcons.skull),
                      title: const Text("Are you sure?"),
                      content: const Text("Plx dont go"),
                      actions: [
                        IconButton(
                          // 아이콘버튼 활용 가능
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const FaIcon(FontAwesomeIcons.car),
                        ),
                        TextButton(
                          // 텍스트버튼도 활용 가능
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Yes"),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ListTile(
                // 애플스타일을 약간만 변형하면 안드로이드 스타일의 로그아웃창이 된다.
                title: const Text("Log out(iOS / Bottom)"),
                textColor: Colors.red,
                onTap: () {
                  showCupertinoModalPopup(
                    // showCupertinoDialog와 유사하지만, ModalPopup의 경우 팝업 외 부분을 터치하면 팝업이 사라진다.
                    // 선택을 강조할 땐 Dialog를 사용하자.
                    context: context,
                    builder: (context) => CupertinoActionSheet(
                      // 팝업이 하단에 뜨는 위젯. 애플스럽다.
                      title: const Text("Are you sure?"),
                      message: const Text("Please dooooont gooooo"),
                      actions: [
                        CupertinoActionSheetAction(
                          // 선택지가 하단에 붙어 있음.
                          isDefaultAction: true,
                          child: const Text("Not log out"),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        CupertinoActionSheetAction(
                          isDestructiveAction: true,
                          child: const Text("Yes plz."),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          // body: Column(
          //   children: const [
          //     CupertinoActivityIndicator( // 애플 로딩 표시
          //       radius: 40,
          //       animating: true,
          //     ),
          //     CircularProgressIndicator(),  // 안드로이드 대기 표시
          //     CircularProgressIndicator.adaptive() // 플랫폼에 따라 대기표시를 바꿔주는 위젯
          //   ],
          // ),
          //   body: ListWheelScrollView( // 휠 액션이 재밌는 위젯. 활용할 곳이 있을까?
          //     diameterRatio: 10,
          //     offAxisFraction: 1.5,
          //     // useMagnifier: true,
          //     // magnification: 1.5,
          //     itemExtent: 200, // 아이템의 높이를 정해준다.
          //     children: [
          //       for (var x in [1, 2, 1, 2, 3, 4, 5, 1])
          //         FractionallySizedBox(
          //           widthFactor: 1,
          //           child: Container(
          //             color: Colors.teal,
          //             alignment: Alignment.center,
          //             child: const Text(
          //               'Pick me',
          //               style: TextStyle(
          //                 color: Colors.white,
          //                 fontSize: 40,
          //               ),
          //             ),
          //           ),
          //         )
          //     ],
          //   ),
        ),
      ),
    );
  }
}
