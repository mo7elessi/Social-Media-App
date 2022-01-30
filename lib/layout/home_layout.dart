import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/madules/user/user_cubit/cubit.dart';
import 'package:social_app/shared/components/constance.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {},
        builder: (BuildContext context, AppStates state) {
          int homeIndex = 0;
          int searchIndex = 1;
          int addIndex = 2;
          int chatIndex = 3;
          int profileIndex = 4;
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            body: cubit.buildScreens[cubit.currentIndex],
            appBar: AppBar(
              title: Text(cubit.appBarTitle[cubit.currentIndex].toUpperCase()),
              actions: [
                if (cubit.currentIndex == homeIndex)
                  IconButton(
                    icon: const Icon(Icons.notifications_rounded),
                    onPressed: () {},
                  ),
                if (cubit.currentIndex == profileIndex)
                  IconButton(
                    icon: const Icon(Icons.settings_rounded),
                    onPressed: () {
                      UserCubit.get(context).logout(context);
                    },
                  ),
               // if (cubit.currentIndex == addIndex)

              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              items: cubit.navBarsItems,
              onTap: (index) {
                cubit.onClickItemNav(index);
              },
            ),
          );
        });
  }
}
