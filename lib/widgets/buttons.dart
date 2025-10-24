import 'package:flutter/material.dart';
import '../../constants/colors/main_color.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final dynamic press;
  final Color color, textColor;
  const RoundedButton({
    Key? key,
    required this.text,
    this.press,
    this.color = mainColor,
    this.textColor = Colors.white,
    TextButton? child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0),
      width: size.width * 0.9,
      height: 60,
      child: Container(
        decoration: BoxDecoration(
          color: mainColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: newElevatedButton(),
      ),
    );
  }

  //Used:ElevatedButton as FlatButton is deprecated.
  //Here we have to apply customizations to Button by inheriting the styleFrom

  Widget newElevatedButton() {
    return ElevatedButton(
      onPressed: press,
      style: ElevatedButton.styleFrom(
        backgroundColor: mainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), // <-- Radius
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontFamily: 'Josefin Sans',
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class RoundedSmallButton extends StatelessWidget {
  final String text;
  final dynamic press;
  final Color color, textColor;
  const RoundedSmallButton({
    Key? key,
    required this.text,
    this.press,
    this.color = redColor,
    this.textColor = Colors.white,
    TextButton? child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 0),
      width: size.width * 0.45,
      height: 60,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: newElevatedButton(),
      ),
    );
  }

  //Used:ElevatedButton as FlatButton is deprecated.
  //Here we have to apply customizations to Button by inheriting the styleFrom

  Widget newElevatedButton() {
    return ElevatedButton(
      onPressed: press,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // <-- Radius
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontFamily: 'Josefin Sans',
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class RoundedLargeButton extends StatelessWidget {
  final String text;
  final dynamic press;
  final Color color, textColor;
  const RoundedLargeButton({
    Key? key,
    required this.text,
    this.press,
    this.color = redColor,
    this.textColor = Colors.white,
    TextButton? child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 0),
      width: size.width * 0.9,
      height: 60,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: newElevatedButton(),
      ),
    );
  }

  //Used:ElevatedButton as FlatButton is deprecated.
  //Here we have to apply customizations to Button by inheriting the styleFrom

  Widget newElevatedButton() {
    return ElevatedButton(
      onPressed: press,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        //padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontFamily: 'Josefin Sans',
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class RoundedBorderButton extends StatelessWidget {
  final String text;
  final dynamic press;
  final Color color, textColor;
  const RoundedBorderButton({
    Key? key,
    required this.text,
    this.press,
    required this.color,
    this.textColor = mainColor,
    TextButton? child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: mainColor, width: 1),
        color: generalBackground,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.9,
      height: 60,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: newElevatedButton(),
      ),
    );
  }

  Widget newElevatedButton() {
    return ElevatedButton(
      onPressed: press,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
        textStyle: const TextStyle(
          color: mainColor,
          fontFamily: 'Josefin Sans',
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      child: Text(text, style: const TextStyle(color: mainColor)),
    );
  }
}

class RoundedTwoButton extends StatelessWidget {
  final String text;
  final dynamic press;
  final Color color, textColor;
  const RoundedTwoButton({
    Key? key,
    required this.text,
    this.press,
    required this.color,
    this.textColor = mainColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: mainColor, width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: newElevatedButton(color),
      ),
    );
  }

  //Used:ElevatedButton as FlatButton is deprecated.
  //Here we have to apply customizations to Button by inheriting the styleFrom

  Widget newElevatedButton(color) {
    return ElevatedButton(
      onPressed: press,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        textStyle: TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontFamily: 'Josefin Sans'),
      ),
    );
  }
}
