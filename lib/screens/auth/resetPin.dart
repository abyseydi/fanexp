import 'package:flutter/material.dart';

const gaindeGreen = Color(0xFF007A33);
const gaindeRed = Color(0xFFE31E24);
const gaindeWhite = Color(0xFFFFFFFF);
const gaindeInk = Color(0xFF0F0F0F);
const gaindeBg = Color(0xFFF6F8FB);
const gaindeLine = Color(0xFFE8ECF3);

class ResetPin extends StatefulWidget {
  final String? phoneNumber;

  const ResetPin({super.key, this.phoneNumber});

  @override
  State<ResetPin> createState() => _ResetPinState();
}

class _ResetPinState extends State<ResetPin> {
  final _formKey = GlobalKey<FormState>();

  final _phoneCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  final _pinConfirmCtrl = TextEditingController();

  bool _sendingCode = false;
  bool _submitting = false;
  bool _codeSent = false;
  bool _obscurePin = true;
  bool _obscurePinConfirm = true;

  @override
  void initState() {
    super.initState();
    if (widget.phoneNumber != null && widget.phoneNumber!.isNotEmpty) {
      _phoneCtrl.text = widget.phoneNumber!;
    }
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _otpCtrl.dispose();
    _pinCtrl.dispose();
    _pinConfirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    if (_phoneCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Merci de renseigner votre numéro de téléphone.'),
        ),
      );
      return;
    }

    setState(() => _sendingCode = true);

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() {
      _sendingCode = false;
      _codeSent = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Un code de vérification a été envoyé au ${_phoneCtrl.text.trim()}',
        ),
      ),
    );
  }

  bool _is4Digits(String value) {
    final regex = RegExp(r'^\d{4}$');
    return regex.hasMatch(value);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_codeSent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Merci de demander d’abord le code SMS.')),
      );
      return;
    }

    setState(() => _submitting = true);

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _submitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Votre code secret a été réinitialisé avec succès ✅'),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final readOnlyPhone = widget.phoneNumber != null;

    return Scaffold(
      backgroundColor: gaindeBg,
      appBar: AppBar(
        backgroundColor: gaindeBg,
        elevation: 0,
        iconTheme: const IconThemeData(color: gaindeInk),
        title: const Text(
          'Réinitialiser le code',
          style: TextStyle(color: gaindeInk, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: gaindeGreen.withOpacity(.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_reset_rounded,
                        color: gaindeGreen,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Vous avez oublié votre code secret ?\n'
                        'Renseignez votre numéro, entrez le code SMS et définissez un nouveau code à 4 chiffres.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                const Text(
                  'Numéro de téléphone',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: gaindeInk,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _phoneCtrl,
                  readOnly: readOnlyPhone,
                  keyboardType: TextInputType.phone,
                  decoration: _inputDecoration(
                    hint: 'Ex : +221 77 000 00 00',
                    prefixIcon: const Icon(
                      Icons.phone_iphone_rounded,
                      size: 20,
                    ),
                  ),
                  validator: (v) {
                    final value = v?.trim() ?? '';
                    if (value.isEmpty) {
                      return 'Merci de renseigner votre numéro.';
                    }
                    if (value.length < 8) {
                      return 'Numéro trop court.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: _sendingCode ? null : _sendCode,
                    icon: _sendingCode
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(
                            Icons.sms_rounded,
                            size: 18,
                            color: gaindeGreen,
                          ),
                    label: Text(
                      _codeSent ? 'Renvoyer le code' : 'Envoyer un code SMS',
                      style: const TextStyle(
                        color: gaindeGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                const Text(
                  'Code SMS reçu',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: gaindeInk,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _otpCtrl,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: _inputDecoration(
                    hint: 'Code à 4–6 chiffres',
                    prefixIcon: const Icon(Icons.sms_rounded, size: 20),
                    counterText: '',
                  ),
                  validator: (v) {
                    final value = v?.trim() ?? '';
                    if (value.isEmpty) {
                      return 'Merci de saisir le code reçu par SMS.';
                    }
                    if (value.length < 4) {
                      return 'Code trop court.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Nouveau code
                const Text(
                  'Nouveau code secret (4 chiffres)',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: gaindeInk,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _pinCtrl,
                  keyboardType: TextInputType.number,
                  obscureText: _obscurePin,
                  maxLength: 4,
                  decoration: _inputDecoration(
                    hint: '••••',
                    prefixIcon: const Icon(
                      Icons.lock_outline_rounded,
                      size: 20,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePin
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() => _obscurePin = !_obscurePin);
                      },
                    ),
                    counterText: '',
                  ),
                  validator: (v) {
                    final value = v?.trim() ?? '';
                    if (value.isEmpty) {
                      return 'Merci de choisir un code.';
                    }
                    if (!_is4Digits(value)) {
                      return 'Le code doit contenir exactement 4 chiffres.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                const Text(
                  'Confirmer le code secret',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: gaindeInk,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _pinConfirmCtrl,
                  keyboardType: TextInputType.number,
                  obscureText: _obscurePinConfirm,
                  maxLength: 4,
                  decoration: _inputDecoration(
                    hint: '••••',
                    prefixIcon: const Icon(
                      Icons.lock_outline_rounded,
                      size: 20,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePinConfirm
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(
                          () => _obscurePinConfirm = !_obscurePinConfirm,
                        );
                      },
                    ),
                    counterText: '',
                  ),
                  validator: (v) {
                    final value = v?.trim() ?? '';
                    if (value.isEmpty) {
                      return 'Merci de confirmer le code.';
                    }
                    if (value != _pinCtrl.text.trim()) {
                      return 'Les deux codes ne correspondent pas.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: gaindeGreen,
                      foregroundColor: gaindeWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _submitting ? null : _submit,
                    child: _submitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                gaindeWhite,
                              ),
                            ),
                          )
                        : const Text(
                            'Valider mon nouveau code',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 12),

                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Retour à la connexion',
                      style: TextStyle(
                        color: gaindeInk,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? counterText,
  }) {
    return InputDecoration(
      hintText: hint,
      counterText: counterText,
      filled: true,
      fillColor: gaindeWhite,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: gaindeLine),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: gaindeLine),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: gaindeGreen.withOpacity(.9), width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: gaindeRed),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: gaindeRed),
      ),
    );
  }
}
