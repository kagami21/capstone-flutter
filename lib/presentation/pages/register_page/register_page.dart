import 'package:flix_movie/presentation/extensions/build_context_extension.dart';
import 'package:flix_movie/presentation/misc/methods.dart';
import 'package:flix_movie/presentation/providers/router/router_provider.dart';
import 'package:flix_movie/presentation/providers/user_data/user_data_provider.dart';
import 'package:flix_movie/presentation/widgets/flix_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController retypePasswordController =
      TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      userDataProvider,
      (previous, next) {
        if (next is AsyncData && next.value != null) {
          ref.read(routerProvider).goNamed('main');
        } else if (next is AsyncError) {
          context.showSnacBar(next.error.toString());
        }
      },
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              verticalSpace(50),
              Image.asset(
                "assets/flix_logo.png",
                width: 150.0,
              ),
              verticalSpace(50),
              const CircleAvatar(
                radius: 50,
                child: Icon(
                  Icons.add_a_photo,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              verticalSpace(24),
              FlixTextField(
                labelText: 'Name',
                controller: nameController,
              ),
              verticalSpace(24),
              FlixTextField(
                labelText: 'Email',
                controller: emailController,
              ),
              verticalSpace(24),
              FlixTextField(
                labelText: 'Password',
                obscureText: true,
                controller: passwordController,
              ),
              verticalSpace(24),
              FlixTextField(
                labelText: 'Retype Password',
                obscureText: true,
                controller: retypePasswordController,
              ),
              verticalSpace(24),
              switch (ref.watch(userDataProvider)) {
                AsyncData(:final value) => value == null
                    ? SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          child: const Text(
                            'Register',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            if (passwordController.text ==
                                retypePasswordController.text) {
                              ref.read(userDataProvider.notifier).register(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  name: nameController.text);
                            } else {
                              context.showSnacBar(
                                  'Please retype your password with the same value');
                            }
                          },
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
                _ => const Center(
                    child: CircularProgressIndicator(),
                  ),
              },
              verticalSpace(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  TextButton(
                    child: const Text(
                      'Login Here',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      ref.read(routerProvider).goNamed('login');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
