import 'package:flutter/material.dart';

class PhoneCallPage extends StatefulWidget {
  const PhoneCallPage({super.key});

  @override
  State<PhoneCallPage> createState() => _PhoneCallPageState();
}

class _PhoneCallPageState extends State<PhoneCallPage>
    with SingleTickerProviderStateMixin {
  List<String> phoneListWhenNotHidden = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "*",
    "0",
    "#"
  ];
  late List<String> numbers;
  late List phoneListWhenHidden;
  late List phoneList;
  bool isKeyboardPressed = false;
  late AnimationController _controller;
  late Animation<Color?> _dualpadColorAnimation;
  late Animation<double> _growSizeAnimation;
  late Animation<double> _containerOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _dualpadColorAnimation =
        ColorTween(begin: Colors.black, end: Colors.lightGreen)
            .animate(_controller);
    _growSizeAnimation =
        Tween<double>(begin: 3.0, end: 8.0).animate(_controller);
    _containerOpacityAnimation =
        Tween<double>(begin: 0.85, end: 1).animate(_controller);
    numbers = phoneListWhenNotHidden.sublist(0, 9);
    phoneListWhenHidden = [
      ...numbers,
      Icon(
        Icons.add,
        size: 36,
      ),
      Icon(
        Icons.video_call,
        size: 36,
      ),
      Icon(
        Icons.bluetooth,
        size: 36,
      )
    ];
    phoneList = phoneListWhenHidden;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.greenAccent,
                      Colors.blueAccent,
                      Colors.cyanAccent
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    stops: [0, 0.30, 0.90])),
          ),
          Opacity(
            opacity: _containerOpacityAnimation.value,
            child: SizedBox.expand(
                child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      "Calling...",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Spacer(),
                    ClipPath(
                      clipper: PhoneClipper(growSize: _growSizeAnimation.value),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Column(
                          children: [
                            GridView.count(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              crossAxisCount: 3,
                              children: List.generate(12, (index) {
                                if (phoneList[index] is String) {
                                  return Center(
                                      child: Text(
                                    phoneList[index],
                                    style: TextStyle(fontSize: 28),
                                  ));
                                } else {
                                  return phoneList[index];
                                }
                              }),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.volume_up,
                                  size: 36,
                                ),
                                Icon(
                                  Icons.mic_off,
                                  size: 36,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (!isKeyboardPressed) {
                                        _controller.forward();
                                      } else {
                                        _controller.reverse();
                                      }
                                      isKeyboardPressed = !isKeyboardPressed;
                                    });
                                  },
                                  child: Icon(Icons.dialpad,
                                      size: 36,
                                      color: _dualpadColorAnimation.value),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            ClipOval(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(color: Colors.red),
                                child: Icon(
                                  Icons.phone,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )),
          )
        ],
      ),
    ));
  }
}

class PhoneClipper extends CustomClipper<Path> {
  final double growSize;

  PhoneClipper({required this.growSize});
  @override
  Path getClip(Size size) {
    Path path = Path();
    Offset center = Offset(size.width / 2, size.height * 4 / 5);
    final Rect rect = Rect.fromCenter(
        center: center, width: size.width, height: size.height * growSize / 5);
    final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(15));
    path.addRRect(rrect);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
