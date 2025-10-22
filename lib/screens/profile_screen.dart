import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../components/profile_avatar.dart';
import '../components/profile_field.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel user = UserModel(
    name: 'Jorge Santos',
    email: 'jorge@gmail.com',
    phone: '16993368578',
    state: 'SP',
    city: 'Franca',
    birthDate: '22/02/2000',
  );

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Meu Perfil',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ProfileAvatar(size: 100),
                  const SizedBox(width: 40),

                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ProfileField(
                                label: 'Nome:',
                                value: user.name,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ProfileField(
                                label: 'Email:',
                                value: user.email,
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: ProfileField(
                                label: 'Celular:',
                                value: user.phone,
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ProfileField(
                                label: 'Estado:',
                                value: user.state,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: ProfileField(
                                label: 'Cidade:',
                                value: user.city,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ProfileField(
                                label: 'Data de nascimento:',
                                value: user.birthDate,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Editar', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
