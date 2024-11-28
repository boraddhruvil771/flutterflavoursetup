import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Optverfication extends StatefulWidget {
  const Optverfication({super.key});

  @override
  State<Optverfication> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<Optverfication> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String? _verificationId;
  bool _isCodeSent = false;

  void _verifyPhoneNumber() async {
    final String phoneNumber = _phoneController.text.trim();

    // Validate phone number format
    if (!RegExp(r'^\+[1-9]\d{1,14}$').hasMatch(phoneNumber)) {
      _showError(
          'Enter a valid phone number in E.164 format (e.g., +15551234567)');
      return;
    }

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-sign in the user when verification is completed
          await _auth.signInWithCredential(credential);
          _showMessage('Phone number verified and user signed in!');
        },
        verificationFailed: (FirebaseAuthException e) {
          _showError(e.message ?? 'Phone verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _isCodeSent = true;
          });
          _showMessage('OTP sent to $phoneNumber');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      _showError('Failed to verify phone number: $e');
    }
  }

  void _verifyOTP() async {
    final String otp = _otpController.text.trim();

    if (_verificationId == null || otp.isEmpty) {
      _showError('Please enter a valid OTP.');
      return;
    }

    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);
      _showMessage('OTP verified and user signed in!');
    } catch (e) {
      _showError('Invalid OTP: $e');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message, style: const TextStyle(color: Colors.white))),
    );
  }

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone Authentication')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: '+15551234567',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            if (_isCodeSent)
              TextField(
                controller: _otpController,
                decoration: const InputDecoration(
                  labelText: 'Enter OTP',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isCodeSent ? _verifyOTP : _verifyPhoneNumber,
              child: Text(_isCodeSent ? 'Verify OTP' : 'Verify Phone'),
            ),
          ],
        ),
      ),
    );
  }
}
