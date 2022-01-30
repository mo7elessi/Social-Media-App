import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/madules/profile/edit_profile.dart';
import 'package:social_app/model/post_model.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/colors.dart';

// ignore: must_be_immutable
class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String username = '';
    String email = '';
    String? bio ='';
    String imageProfile = '';

    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, AppStates state) {},
        builder: (context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          var user = cubit.user;
          if (user != null) {
            username = user.username ?? '';
            email = user.email ?? '';
            bio = user.bio;
            if(bio == '' || bio == null){
              bio = 'Write about you';

            }
            imageProfile = user.image ?? 'https://www.kindpng.com/picc/m/24-248253_user-profile-default-image-png-clipart-png-download.png';
          }
          return SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 100.0,
                          width: 100.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            image: DecorationImage(
                              image: NetworkImage(imageProfile.toString()),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        spaceBetween(),
                        Text(username,
                            style: Theme.of(context).textTheme.bodyText1),
                        spaceBetween(size: 6),
                        Text(
                          email,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        spaceBetween(size: 24),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '169',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  spaceBetween(size: 6),
                                  Text(
                                    'Posts',
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '150K',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  spaceBetween(size: 6),
                                  Text(
                                    'Flowers',
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '90K',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  spaceBetween(size: 6),
                                  Text(
                                    'Following',
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        spaceBetween(),
                        Row(
                          children: const [
                            Text(
                              'BIO',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 13),
                            ),
                            Spacer(),
                            Icon(
                              Icons.add_rounded,
                              color: Colors.black54,
                              size: 20,
                            ),
                          ],
                        ),
                        spaceBetween(size: 6),

                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            bio!,
                            style: Theme.of(context).textTheme.subtitle2,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        spaceBetween(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              "more information about you",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 12,
                                  decoration: TextDecoration.underline),
                            ),
                          ],
                        ),
                        spaceBetween(size: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                flex: 3,
                                child: primaryButton(
                                    height: 45,
                                    function: () {},
                                    text: 'New Post')),
                            spaceBetween(vertical: false),
                            Expanded(
                                flex: 1,
                                child: secondaryButton(
                                    height: 45,
                                    function: () {
                                      navigatorTo(
                                          context: context,
                                          page: EditProfile());
                                    },
                                    text: 'Edit')),
                          ],
                        ),
                      ],
                    ),
                  ),
                 /* spaceBetween(vertical: false),
                  Expanded(
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        crossAxisCount: 3,
                      ),
                      itemCount: 0,
                      itemBuilder: (context, index) {
                        return const Image(
                          image: AssetImage(""),
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),*/
                ],
              ),
            ),
          );
        });
  }
}
/*
*   'Lorem Ipsum is simply dummy text of the printing and typesetting industry.'
                                  ' Lorem Ipsum has been the industry standard dummy text ever since the 1500s,'
                                  ' when an unknown printer took a galley of type and scrambled it to make a type specimen book.'
                                  ' It has survived not only five centuries,*/
