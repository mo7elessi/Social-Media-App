//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_layout.dart';
import 'package:social_app/madules/user/user_cubit/cubit.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constance.dart';
import 'package:social_app/shared/cubit/bloc_observe.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/local/cache_helper.dart';
import 'package:social_app/shared/styles/themes.dart';
import 'madules/user/login.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('on background message');
  print(message.data.toString());

  toastMessage(message: 'on background message');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var token = await FirebaseMessaging.instance.getToken();
  FirebaseMessaging.onMessage.listen((event) {
    print(event.data.toString());
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event.data.toString());
  });
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();

  userId = CacheHelper.getData(key: 'id');
  Widget page;
  if (userId != null) {
    page = const HomeLayout();
  } else {
    page = const Login();
  }

  runApp(MyApp(
    id: userId,
    startScreen: page,
  ));
}

class MyApp extends StatelessWidget {
  final String id;
  final Widget startScreen;

  // ignore: use_key_in_widget_constructors
  const MyApp({required this.id, required this.startScreen});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => AppCubit()
              ..getProfileData()
              ..getPosts()),
        BlocProvider(create: (context) => UserCubit()),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, Object? state) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Social App',
          theme: themeLight,
          home: startScreen,
        ),
      ),
    );
  }
}
