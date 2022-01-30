import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/madules/user/user_cubit/cubit.dart';
import 'package:social_app/madules/user/user_cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/validation/text_feild_validation.dart';

import 'login.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var usernameController = TextEditingController();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var confirmPasswordController = TextEditingController();
    var formKey = GlobalKey<FormState>();

    String registerSuccess = "Registration completed successfully";
    String registerField = "An error occurred during the registration process";

    return BlocConsumer<UserCubit, UserStates>(listener: (context, state) {
      if (state is RegisterErrorState) {
        toastMessage(message: state.error.toString());
      }
      if (state is RegisterSuccessState) {
        toastMessage(message: registerSuccess);
        navigatorTo(context: context, page: const Login());
      }
    }, builder: (context, state) {
      UserCubit cubit = UserCubit.get(context);
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
              title: const Text('REGISTER'), automaticallyImplyLeading: false),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      textInputField(
                        context: context,
                        controller: usernameController,
                        keyboard: TextInputType.name,
                        hintText: 'Enter Username',
                        prefixIcon: Icons.person_rounded,
                        validator: nameValidator,
                      ),
                      spaceBetween(),
                      textInputField(
                        context: context,
                        controller: emailController,
                        keyboard: TextInputType.emailAddress,
                        prefixIcon: Icons.email_rounded,
                        hintText: 'Enter Email',
                        validator: emailValidator,
                      ),
                      spaceBetween(),
                      textInputField(
                        context: context,
                        controller: passwordController,
                        keyboard: TextInputType.text,
                        hintText: 'Enter Password',
                        prefixIcon: Icons.lock_rounded,
                        suffixIcon: cubit.suffixIcon,
                        suffixIconPressed: () {
                          cubit.changeIconSuffix();
                        },
                        validator: passwordValidator,
                      ),
                      spaceBetween(),
                      textInputField(
                        context: context,
                        controller: confirmPasswordController,
                        keyboard: TextInputType.text,
                        hintText: 'Confirm Password',
                        prefixIcon: Icons.lock_rounded,
                        validator: confirmPasswordValidator,
                      ),
                      spaceBetween(size: 24),
                      ConditionalBuilder(
                        condition: state is! RegisterLoadingState,
                        builder: (context) {
                          return primaryButton(
                            text: 'Register',
                            function: () {
                              if (formKey.currentState!.validate()) {
                                cubit.register(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    username: usernameController.text,
                                    image: 'https://www.kindpng.com/picc/m/24-248253_user-profile-default-image-png-clipart-png-download.png');
                              }
                            },
                          );
                        },
                        fallback: (context) {
                          return const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                            ),
                          );
                        },
                      ),
                      spaceBetween(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Do you have account?'),
                          TextButton(
                              onPressed: () {
                                navigatorTo(
                                    context: context, page: const Login());
                              },
                              child: const Text('Login'))
                        ],
                      ),
                      spaceBetween(size: 100.0),
                      signUpUsing(context: context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
