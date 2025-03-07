import 'package:flutter/material.dart';
import 'package:masterstudy_app/presentation/screens/languages/languages_screen.dart';

class ChangeLanguageWidget extends StatelessWidget {
  const ChangeLanguageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      color: Colors.grey.shade50,
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(LanguagesScreen.routeName),
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // TODO: 20.07.2023 Add translation
              Text(
                'Change language',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_outlined,
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
