import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/madules/user/user_cubit/states.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/local/cache_helper.dart';

import '../login.dart';

class UserCubit extends Cubit<UserStates> {
  UserCubit() : super(UserInitialState());

  static UserCubit get(context) => BlocProvider.of(context);

  //firebase
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore store = FirebaseFirestore.instance;

  bool? success;
  String userEmail = '';
  IconData suffixIcon = Icons.visibility_off_rounded;

  bool isPassword = true;

  void changeIconSuffix() {
    isPassword = !isPassword;
    suffixIcon =
        isPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded;
    emit(RegisterChangeVisibilityPassword());
  }

  void register({
    required String username,
    required String email,
    required String password,
    String? image,
  }) {
    emit(RegisterLoadingState());
    auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      createUser(
          id: value.user!.uid, username: username, email: email, image: image);
      emit(RegisterSuccessState());
    }).catchError((onError) {
      emit(RegisterErrorState(onError.toString()));
    });
  }

  void createUser({
    required String id,
    required String username,
    required String email,
    String? image,
  }) {
    UserModel user = UserModel(
        id: id,
        username: username,
        email: email,
        isEmailVerified: false,
        image: image);
    store.collection('users').doc(id).set(user.toMap()).then((value) {
      emit(CreateUserSuccessState());
    }).catchError((onError) {
      emit(CreateUserErrorState(onError.toString()));
    });
  }

  void login({required String email, required String password}) {
    emit(LoginLoadingState());
    auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      emit(LoginSuccessState(value.user!.uid));
    }).catchError((onError) {
      emit(LoginErrorState(onError.toString()));
    });
  }

  void resetPassword({required String email}) {
    emit(ResetPasswordLoadingState());
    FirebaseAuth.instance.sendPasswordResetEmail(
      email: email,
    ).then((value) {
      emit(ResetPasswordSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(ResetPasswordErrorState());
    });
  }

  void verifyPasswordResetCode() {}

  void logout(context) {
    CacheHelper.clearData(key: 'id').then((value) {
      if (value) {
        navigatorAndFinished(context: context, page: const Login());
      }
    });
  }
}
