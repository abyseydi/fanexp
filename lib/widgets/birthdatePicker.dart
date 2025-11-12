import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BirthdayPickerField extends StatefulWidget {
  const BirthdayPickerField({
    super.key,
    required this.birthdayController,
    required this.birthdayValidator,
    this.gaindeWhite = const Color(0xFFFFFFFF),
    this.gaindeGreen = const Color(0xFF007A33),
  });

  final TextEditingController birthdayController;
  final String? Function(String?) birthdayValidator;
  final Color gaindeWhite;
  final Color gaindeGreen;

  @override
  State<BirthdayPickerField> createState() => _BirthdayPickerFieldState();
}

class _BirthdayPickerFieldState extends State<BirthdayPickerField> {
  DateTime? birthdayDate;

  @override
  void initState() {
    super.initState();
    // Valeur par défaut : aujourd’hui si le champ est vide
    if (widget.birthdayController.text.trim().isEmpty) {
      final now = DateTime.now();
      widget.birthdayController.text = DateFormat('dd/MM/yyyy').format(now);
      birthdayDate = DateTime(now.year, now.month, now.day);
    }
  }

  bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.35),
                blurRadius: 24,
                spreadRadius: 1,
              ),
            ],
          ),
          // height: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                textAlignVertical: TextAlignVertical.center,
                controller: widget.birthdayController,
                validator: widget.birthdayValidator,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor: widget.gaindeWhite,
                  filled: true,
                  border: InputBorder.none,
                  hintText: 'JJ/MM/AAAA',
                  hintStyle: const TextStyle(fontFamily: 'Josefin Sans'),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
                onTap: () async {
                  final now = DateTime.now();
                  final initial = birthdayDate ?? now;

                  final pickedDate = await showDatePicker(
                    context: context,
                    // Initialement sur la date courante (ou la précédente saisie)
                    initialDate: initial.isAfter(now) ? now : initial,
                    firstDate: DateTime(1900, 1, 1),
                    // Interdit toute date ultérieure au jour courant
                    lastDate: DateTime(now.year, now.month, now.day),
                    selectableDayPredicate: (day) {
                      final today = DateTime(now.year, now.month, now.day);
                      // Autoriser uniquement <= aujourd’hui
                      return !day.isAfter(today);
                    },
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: ColorScheme.light(
                            primary: widget
                                .gaindeGreen, // couleur des boutons/accents
                            onSurface: Colors.black, // couleur du texte
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (pickedDate != null) {
                    // Normaliser à minuit pour éviter les surprises
                    final normalized = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                    );
                    setState(() {
                      birthdayDate = normalized;
                      widget.birthdayController.text = DateFormat(
                        'dd/MM/yyyy',
                      ).format(normalized);
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
