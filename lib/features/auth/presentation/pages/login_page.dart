// import 'package:chat_app/core/theme.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:chat_app/features/auth/presentation/widgets/auth_button.dart';
import 'package:chat_app/features/auth/presentation/widgets/auth_input.dart';
import 'package:chat_app/features/auth/presentation/widgets/login_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  void dispose() {
    _emailController.dispose();

    _passwordController.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  void _onLogin() {
    BlocProvider.of<AuthBloc>(context).add(
      LoginEvent(
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

              SizedBox(height: 25),
              BlocConsumer<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return AuthButton(text: 'Log In', onPressed: _onLogin);
                },
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    print("Success");
                    Navigator.pushNamed(context, '/conversationPage');
                  } else if (state is AuthFail) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.error)));
                  }
                },
              ),

              // _buildRegisterButton(),
              SizedBox(height: 25),
              LoginPrompt(
                onTap: () {
                  Navigator.pushNamed(context, '/register');
                },
                title: "Don't have an account? ",
                title2: "Create a new one",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
