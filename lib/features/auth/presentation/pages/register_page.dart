// import 'package:chat_app/core/theme.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:chat_app/features/auth/presentation/pages/verify_otp_page.dart';
import 'package:chat_app/features/auth/presentation/widgets/auth_button.dart';
import 'package:chat_app/features/auth/presentation/widgets/auth_input.dart';
import 'package:chat_app/features/auth/presentation/widgets/login_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();



  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();

    _passwordController.dispose();

    super.dispose();
  }

  void _onRegister() {
    BlocProvider.of<AuthBloc>(context).add(
      RegisterEvent(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthInput(
                hint: 'Username',
                icon: Icons.person,
                controller: _usernameController,
              ),
              SizedBox(height: 25),
              AuthInput(
                hint: 'Email',
                icon: Icons.email,
                controller: _emailController,
              ),
              SizedBox(height: 25),
              AuthInput(
                hint: 'Password',
                icon: Icons.password,
                controller: _passwordController,
                isPassword: true,
              ),
              SizedBox(height: 25,),
              
              BlocConsumer<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return Center(child: CircularProgressIndicator());
                  
                  }
                  return AuthButton(text: 'Sign Up', onPressed: _onRegister);
                },
                listener: (context, state) {
                  if (state is AuthWait) {
                    Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => VerifyOtpPage(email: state.email,

                                    ),
                              ),
                            );
                  } else if (state is AuthFail) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.error)),
                    );
                  }
                },
              ),
              SizedBox(height: 25),
              // AuthButton(text: 'Sign Up', onPressed: _onRegister),
              LoginPrompt(
                onTap: (){
                  Navigator.pushNamed(context, '/login');
                },
                title: 'Already have an account? ',
                title2: 'Log in',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
