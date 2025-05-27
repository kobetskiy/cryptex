import 'package:auto_route/auto_route.dart';
import 'package:cryptex/core/router/router.dart';
import 'package:cryptex/core/ui/const/app_icons.dart';
import 'package:cryptex/core/ui/const/app_images.dart';
import 'package:cryptex/core/ui/const/form_validator.dart';
import 'package:cryptex/core/ui/theme/theme.dart';
import 'package:cryptex/core/ui/widgets/widgets.dart';
import 'package:cryptex/features/auth/view/bloc/auth_bloc.dart';
import 'package:cryptex/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _signUp() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        SignUp(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          name: _nameController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.router.replace(HomeRoute());
        }
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: [
                  SizedBox(height: 20),
                  Center(child: Image.asset(AppImages.splashLogo)),
                  Divider(
                    color: Theme.of(context).colorScheme.darkTernary,
                    height: 40,
                  ),
                  Text(
                    S.of(context).signUp,
                    style: TextStyle(fontSize: 44, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 15),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.darkTernary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(S.of(context).name),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _nameController,
                            validator: (value) {
                              return FormValidator.validateUserName(
                                context,
                                value,
                              );
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              isCollapsed: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(S.of(context).email),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            validator: (value) {
                              return FormValidator.validateEmail(
                                context,
                                value,
                              );
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              isCollapsed: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(S.of(context).password),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            validator: (value) {
                              return FormValidator.validatePassword(
                                context,
                                value,
                              );
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              isCollapsed: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  PrimaryButton(
                    isExpanded: true,
                    onPressed: state is AuthLoading ? null : _signUp,
                    child:
                        state is AuthLoading
                            ? CircularProgressIndicator.adaptive()
                            : Text(S.of(context).signUp),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.router.replace(LogInRoute()),
                      child: Text(
                        S.of(context).alreadyHaveAnAccountLogIn,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(S.of(context).orContinueWith),
                      ),
                      Expanded(child: Divider(color: Colors.grey)),
                    ],
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor:
                          Theme.of(context).colorScheme.darkSurface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppIcons.google,
                          width: 30,
                          height: 30,
                        ),
                        SizedBox(width: 10),
                        Text('Google'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
