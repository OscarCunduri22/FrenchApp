// linking_vocals_game.dart
import 'package:flutter/material.dart';

class LinkingVocalsGame extends StatelessWidget {
  const LinkingVocalsGame({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Center(
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 40, 
                left: 150,
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset('assets/images/lower_case_a.png', fit: BoxFit.contain),),
                  ),
                Positioned(
                top: 30, 
                left: 350,
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset('assets/images/lower_case_b.png', fit: BoxFit.contain),),
                  ),
                Positioned(
                top: 40, 
                right: 150,
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset('assets/images/lower_case_c.png', fit: BoxFit.contain),),
                  ),
                Positioned(
                bottom: 50, 
                left: 130,
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset('assets/images/upper_case_A.png', fit: BoxFit.contain),),
                  ),
                Positioned(
                bottom: 40, 
                left: 350,
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset('assets/images/upper_case_B.png', fit: BoxFit.contain),),
                  ),
                Positioned(
                bottom: 50, 
                right: 130,
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset('assets/images/upper_case_C.png', fit: BoxFit.contain),),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

