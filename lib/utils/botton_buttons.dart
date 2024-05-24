import 'package:flutter/material.dart';

class BottomButtons extends StatelessWidget {
  final PageController pageController;

  const BottomButtons({Key? key, required this.pageController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        ElevatedButton(
          onPressed: () {
            pageController.previousPage(
                duration: Duration(milliseconds: 500), curve: Curves.easeIn);
          },
          child: Container(
            height: 50,
            width: 50,
            child: Icon(
              Icons.arrow_back,
              color: const Color(0xFF016171),
            ),
          ),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
              shadowColor: const Color(0xFF016171),
              foregroundColor: const Color(0xFF016171),
              shape: CircleBorder(
                side: BorderSide(color: const Color(0xFF016171)!),
              )),
        ),
        ElevatedButton(
          onPressed: () {
            pageController.nextPage(
                duration: Duration(milliseconds: 500), curve: Curves.easeIn);
          },
          child: Container(
            height: 50,
            width: 50,
            child: Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF15E2F),
              elevation: 0,
              shadowColor: Colors.transparent,
              foregroundColor: const Color(0xFFF15E2F),
              shape: const CircleBorder()),
        )
      ]),
    );
  }
}
