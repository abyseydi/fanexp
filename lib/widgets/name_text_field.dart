import 'package:fanexp/constants/colors/main_color.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

const _aiGreen = Color(0xFF00C853);

final _radius = BorderRadius.circular(16);

class AiTextField extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final IconData? icon;
  final String? label;
  final List<FieldValidator<String>> validators;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Iterable<String>? autofillHints;
  final bool enabled;

  const AiTextField({
    required this.hint,
    required this.controller,
    this.icon,
    this.label,
    this.validators = const [],
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.autofillHints,
    this.enabled = true,
    super.key,
  });

  @override
  State<AiTextField> createState() => _AiTextFieldState();
}

class _AiTextFieldState extends State<AiTextField> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = _focusNode.hasFocus;
    final cs = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        borderRadius: _radius,
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: gaindeGreen.withOpacity(.25),
                  blurRadius: 22,
                  spreadRadius: 1,
                  offset: const Offset(0, 6),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: TextFormField(
        focusNode: _focusNode,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        autofillHints: widget.autofillHints,
        enabled: widget.enabled,
        validator: MultiValidator(<FieldValidator<String>>[
          ...widget.validators,
        ]).call,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(color: Colors.grey),
          labelText: widget.label,
          prefixIcon: widget.icon != null
              ? Icon(widget.icon, color: Colors.black87)
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: _radius,
            borderSide: BorderSide(color: cs.outline.withOpacity(.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: _radius,
            borderSide: BorderSide(color: cs.outline.withOpacity(.25)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: gaindeGreen, width: 1.6),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: _radius,
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 1,
            ),
          ),
          errorStyle: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}

class AiPasswordField extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final String? label;
  final List<FieldValidator<String>> validators;
  final TextInputAction textInputAction;
  final Iterable<String>? autofillHints;

  const AiPasswordField({
    required this.hint,
    required this.controller,
    this.label,
    this.validators = const [],
    this.textInputAction = TextInputAction.done,
    this.autofillHints = const [AutofillHints.password],
    super.key,
  });

  @override
  State<AiPasswordField> createState() => _AiPasswordFieldState();
}

class _AiPasswordFieldState extends State<AiPasswordField> {
  final _focusNode = FocusNode();
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = _focusNode.hasFocus;
    final cs = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        borderRadius: _radius,
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: _aiGreen.withOpacity(.25),
                  blurRadius: 22,
                  spreadRadius: 1,
                  offset: const Offset(0, 6),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: TextFormField(
        focusNode: _focusNode,
        controller: widget.controller,
        obscureText: _obscure,
        textInputAction: widget.textInputAction,
        autofillHints: widget.autofillHints,
        validator: MultiValidator(<FieldValidator<String>>[
          ...widget.validators,
        ]).call,
        decoration: InputDecoration(
          hintText: widget.hint,
          labelText: widget.label,
          prefixIcon: const Icon(
            Icons.lock_outline_rounded,
            color: Colors.black87,
          ),
          suffixIcon: IconButton(
            onPressed: () => setState(() => _obscure = !_obscure),
            icon: Icon(
              _obscure
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: _radius,
            borderSide: BorderSide(color: cs.outline.withOpacity(.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: _radius,
            borderSide: BorderSide(color: cs.outline.withOpacity(.25)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: _aiGreen, width: 1.6),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: _radius,
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 1,
            ),
          ),
          errorStyle: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
