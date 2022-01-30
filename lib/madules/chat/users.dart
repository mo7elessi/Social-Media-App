import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class Users extends StatelessWidget {
  const Users({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, AppStates state) {},
        builder: (context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ConditionalBuilder(
                builder: (context) {
                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    separatorBuilder: (context, index) => spaceBetween(size: 24),
                    itemCount: cubit.users.length,
                    itemBuilder: (context, index) {
                      return userItem(model:cubit.users[index], context: context );
                    },
                  );
                },
                // ignore: prefer_is_empty
                condition: cubit.users.length > 0,
                fallback: (context) =>
                const Center(child: CircularProgressIndicator()),
            ),
          );
        });
  }
}
