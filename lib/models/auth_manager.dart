import 'package:flutter/material.dart';

class AuthManager extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _userName;
  String? _userEmail;
  String? _userPhone;

  bool get isLoggedIn => _isLoggedIn;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userPhone => _userPhone;

  void login({String? name, String? email, String? phone}) {
    _isLoggedIn = true;
    _userName = name;
    _userEmail = email;
    _userPhone = phone;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _userName = null;
    _userEmail = null;
    _userPhone = null;
    notifyListeners();
  }

  // Método para simular login com dados de exemplo
  void loginWithTestUser() {
    login(
      name: 'João Silva',
      email: 'joao.silva@email.com',
      phone: '(11) 99999-9999',
    );
  }
}
