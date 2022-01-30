import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_layout.dart';
import 'package:social_app/madules/user/register.dart';
import 'package:social_app/madules/user/user_cubit/cubit.dart';
import 'package:social_app/madules/user/user_cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constance.dart';
import 'package:social_app/shared/local/cache_helper.dart';
import 'package:social_app/shared/validation/text_feild_validation.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    String loginFieldMessage = "error in username or password";

    return BlocConsumer<UserCubit, UserStates>(listener: (context, state) {
      if (state is LoginErrorState) {
        toastMessage(message: loginFieldMessage);
      }
      if (state is LoginSuccessState) {
        CacheHelper.saveData(key: 'id', value: state.id).then((value) {
          navigatorAndFinished(context: context, page: const HomeLayout());
        }).catchError((onError) {
          print(onError.toString());
        });
      }
    }, builder: (context, state) {
      UserCubit cubit = UserCubit.get(context);
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('LOGIN'),
            automaticallyImplyLeading: false,
          ),
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
                        controller: emailController,
                        keyboard: TextInputType.emailAddress,
                        prefixIcon: Icons.email_rounded,
                        hintText: 'Enter Email',
                        validator: none,
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
                        validator: none,
                      ),
                      spaceBetween(size: 24),
                      ConditionalBuilder(
                        condition: state is! LoginLoadingState,
                        builder: (context) {
                          return primaryButton(
                            text: 'Login',
                            function: () {
                              if (formKey.currentState!.validate()) {
                                cubit.login(
                                    email: emailController.text,
                                    password: passwordController.text);
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
                          const Text('Do not you have account?'),
                          TextButton(
                              onPressed: () {
                                navigatorTo(
                                    context: context, page: const Register());
                              },
                              child: const Text('Register'))
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
