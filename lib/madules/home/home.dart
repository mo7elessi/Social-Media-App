import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, AppStates state) {},
        builder: (context, AppStates state){
          AppCubit cubit = AppCubit.get(context);
            return ConditionalBuilder(
              condition: cubit.posts.length > 0 && cubit.user != null,
              builder: (context) {
                return ListView.separated(
                  separatorBuilder: (context, index) => spaceBetween(),
                  itemCount: cubit.posts.length,
                  itemBuilder: (context, index) {
                    return postItem(
                        context: context,
                        model: cubit.posts[index],
                        index: index);
                  },
                );
              },
              // ignore: prefer_is_empty
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
            );
          }
        );
  }
}
