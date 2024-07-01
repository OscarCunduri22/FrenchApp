import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frenc_app/widgets/auth/exit_game_box.dart';
import 'package:frenc_app/widgets/auth/exit_user_box.dart';
import 'package:frenc_app/widgets/auth/security_code_box.dart';
import 'package:provider/provider.dart';
import 'package:frenc_app/utils/user_provider.dart';
import 'package:flutter/services.dart';

class DialogManager {
  static void showSecurityCodeDialog(Function onSuccess, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SecurityCodeDialog(onSuccess: onSuccess);
      },
    );
  }

  static void showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ExitConfirmationDialog(
          onExitConfirmed: () {
            Navigator.of(context).pop(true);
            Future.delayed(const Duration(milliseconds: 200), () {
              SystemNavigator.pop();
            });
          },
        );
      },
    );
  }

  static void showExitAndLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ExitAndLogoutDialog(
          onExitConfirmed: () {
            Navigator.of(context).pop(true);
            Future.delayed(const Duration(milliseconds: 200), () {
              SystemNavigator.pop();
            });
          },
          onLogoutAndExitConfirmed: () async {
            final userProvider =
                Provider.of<UserProvider>(context, listen: false);
            await FirebaseAuth.instance.signOut();
            userProvider.clearUser();
            Navigator.of(context).pop();
            Future.delayed(const Duration(milliseconds: 200), () {
              SystemNavigator.pop();
            });
          },
        );
      },
    );
  }
}
