import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../constants/colors/main_color.dart';

// ignore: must_be_immutable
class NameTextField extends StatefulWidget {
  String nameText;
  var controller = TextEditingController();
  NameTextField(this.nameText, this.controller, {Key? key}) : super(key: key);

  @override
  _NameTextFieldState createState() => _NameTextFieldState();
}

class _NameTextFieldState extends State<NameTextField> {
  final nameValidator = MultiValidator([
    RequiredValidator(errorText: "Champ obligatoire"),
    MinLengthValidator(1, errorText: "Au moins 1 caractère"),
  ]);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: nameValidator,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: widget.controller,
      autofillHints: const [AutofillHints.email],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20.0, // Adjust the vertical padding for height
          horizontal: 15,
        ),
        // border: OutlineInputBorder(),
        fillColor: generalBackground,
        filled: true,
        border: InputBorder.none,
        hintText: widget.nameText,
        hintStyle: TextStyle(fontFamily: 'Josefin Sans', fontSize: 14),
        labelStyle: const TextStyle(
          color: textBlackColor,
          fontFamily: "Josefin Sans",
          fontSize: 12,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
