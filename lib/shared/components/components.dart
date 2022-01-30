import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:social_app/madules/chat/chat_details.dart';
import 'package:social_app/madules/user/user_cubit/cubit.dart';
import 'package:social_app/model/post_model.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:readmore/readmore.dart';

double radius = 5.0;
double width = double.infinity;

Widget textInputField(
    {required TextEditingController controller,
    required TextInputType keyboard,
    required MultiValidator validator,
    Function? validatorFunc,
    required String hintText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    Function? suffixIconPressed,
    required context,
    Function? onSubmit,
    bool confirmPass = false,
    bool description = false}) {
  return SizedBox(
    width: width,
    child: TextFormField(
      controller: controller,
      keyboardType: keyboard,
      style: Theme.of(context).textTheme.subtitle1,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.subtitle2,
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(suffixIcon),
                onPressed: () => suffixIconPressed!(),
              )
            : null,
        prefixIcon: Icon(prefixIcon),
      ),
      validator: validator,
    ),
  );
}

Widget textInputFieldLong({
  required TextEditingController controller,
  required TextInputType keyboard,
  required MultiValidator validator,
  required String hintText,
  required Function onChange,
  required context,
  Function? onSubmit,
  int min = 50,
  int max = 50,
}) {
  return SizedBox(
    height: 150,
    child: CupertinoTextField(
      maxLines: max,
      minLines: min,
      maxLength: 500,
      decoration: BoxDecoration(
        border: Border.all(color: secondaryColor, width: 0.3),
        borderRadius: BorderRadius.circular(radius),
      ),
      padding: const EdgeInsets.all(10),
      placeholder: hintText,
      placeholderStyle: Theme.of(context).textTheme.subtitle1,
      controller: controller,
      keyboardType: keyboard,
      style: Theme.of(context).textTheme.subtitle1,
      textAlignVertical: TextAlignVertical.top,
      //validator: validator,
      onChanged: (v) => onChange(v),
    ),
  );
}

Widget primaryButton({
  required Function function,
  required String text,
  Color color = primaryColor,
  double height = 55,
}) {
  return Container(
    height: height,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
    ),
    child: MaterialButton(
      minWidth: width,
      onPressed: () => function(),
      child: Center(
        child: Text(text,
            style: const TextStyle(
              color: whiteColor,
              fontSize: 14.0,
            )),
      ),
    ),
  );
}

Widget secondaryButton({
  required Function function,
  required String text,
  Color color = whiteColor,
  double height = 55,
}) {
  return SizedBox(
    height: height,
    width: width,
    child: OutlinedButton(
      child: Text(text,
          style: const TextStyle(
            color: primaryColor,
            fontSize: 14.0,
          )),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius))),
      ),
      onPressed: () => function(),
    ),
  );
}

Widget spaceBetween({double size = 12.0, bool vertical = true}) {
  return vertical
      ? SizedBox(
          height: size,
        )
      : SizedBox(
          width: size,
        );
}

Widget signUpUsing({double radius = 20.0, required BuildContext context}) {
  UserCubit cubit = UserCubit.get(context);
  bool isLogin = false;
  Map userData = {};
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            child: CircleAvatar(
              radius: radius,
              backgroundColor: backgroundColor,
              child:
                  const Image(image: AssetImage('assets/images/facebook.png')),
            ),
            onTap: () async {
              /*   final LoginResult result = await FacebookAuth.instance.login(
                  permissions: [
                    'public_profile',
                    'email'
                  ]); // by default we request the email and the public profile
              //   final LoginResult result =FacebookAuth.i.login();
              if (result.status == LoginStatus.success) {
                final AccessToken accessToken = result.accessToken!;
                FacebookAuth.instance.getUserData().then((value) {
                  isLogin = true;
                  userData = value;
                  if (isLogin) {
                    var name = userData['name'];
                    var email = userData['email'];
                    var image = userData['picture']['data']['url'].toString();
                    print('name: $name\n email: $email');
                    navigatorAndFinished(
                        context: context, page: const HomeLayout());
                  }
                });
              } else {
                print(result.message);
                print(result.status);
              }*/
            },
          ),
          spaceBetween(vertical: false, size: 24),
          GestureDetector(
            child: CircleAvatar(
              radius: radius,
              backgroundColor: backgroundColor,
              child: const Image(image: AssetImage('assets/images/google.png')),
            ),
            onTap: () {
              // cubit.signInWithGoogle();
            },
          ),
          spaceBetween(vertical: false, size: 24),
          CircleAvatar(
            radius: radius,
            backgroundColor: backgroundColor,
            child: const Image(image: AssetImage('assets/images/twitter.png')),
          ),
        ],
      ),
    ],
  );
}

Future<dynamic> navigatorTo(
    {required BuildContext context, required Widget page}) {
  return Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

/*Future<UserCredential> signInWithFacebook() async {
  // Trigger the sign-in flow
  final LoginResult loginResult = await FacebookAuth.instance.login();

  // Create a credential from the access token
  final OAuthCredential facebookAuthCredential =
      FacebookAuthProvider.credential(loginResult.accessToken!.token);

  // Once signed in, return the UserCredential
  return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
}*/

Future<dynamic> navigatorAndFinished(
    {required BuildContext context, required Widget page}) {
  return Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => page),
    (route) {
      return false;
    },
  );
}

void toastMessage({required String message}) {
  Fluttertoast.showToast(
      msg: message,
      timeInSecForIosWeb: 1,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      fontSize: 14.0);
}

Widget postItem({
  required BuildContext context,
  required PostModel model,
  required int index,
}) {
  AppCubit cubit = AppCubit.get(context);
  double heightImagePost = 450;
  var messageController = TextEditingController();
  return Container(
    color: const Color(0xffffffff),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 18.0,
                    backgroundImage: NetworkImage(model.userImage.toString()),
                  ),
                  spaceBetween(size: 6.0, vertical: false),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      spaceBetween(
                        size: 6.0,
                      ),
                      Row(
                        children: [
                          spaceBetween(size: 2.0, vertical: false),
                          Text(
                            model.dateTime.toString(),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              if (model.text != '')
                Column(
                  children: [
                    spaceBetween(),
                    ReadMoreText(
                      model.text,
                      style: TextStyle(
                          height: 1.4,
                          fontSize: model.text.length < 50 ? 14 : 12,
                          color: midTextColor,
                          fontWeight: FontWeight.w500),
                      trimLines: model.image != '' ? 2 : 5,
                      colorClickableText: primaryColor,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'SHOW MORE',
                      trimExpandedText: 'SHOW LESS',
                      moreStyle:
                          const TextStyle(fontSize: 10, color: primaryColor),
                      lessStyle:
                          const TextStyle(fontSize: 10, color: primaryColor),
                    ),
                  ],
                ),
            ],
          ),
        ),
        spaceBetween(size: 6),
        if (model.image != '')
          Container(
            width: width,
            height: heightImagePost,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
            ),
            child: CachedNetworkImage(
              imageUrl: model.image,
              imageBuilder: (context, imageProvider) => Container(
                height: heightImagePost,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => Container(
                color: Colors.white24,
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            children: [
              Text(
                '${cubit.likes[index]} likes',
                // '0 likes',
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
              ),
              spaceBetween(vertical: false),
              Text(
                '${cubit.comments[index]} comments',
                // '0 comments',
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  Icons.favorite_rounded,
                  size: 30,
                  color: cubit.userLikesId.contains(cubit.userLikesId[index])
                      ? cubit.colorLikeIcon
                      : cubit.colorUnlikeIcon,
                ),
                onPressed: () {
                  cubit.userLikesId.contains(cubit.userLikesId[index])
                      ? cubit.unlikePost(postId: cubit.postsId[index])
                      : cubit.likePost(postId: cubit.postsId[index]);
                },
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: TextFormField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter comment',
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              spaceBetween(vertical: false, size: 6),
              if (messageController.text != null)
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    size: 28,
                    color: primaryColor,
                  ),
                  onPressed: () {
                    cubit.commentPost(
                        postId: cubit.postsId[index],
                        text: messageController.text);
                  },
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget header({String? text, context, Widget? icon}) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: const Color(0xfff3f3f3),
    ),
    padding: const EdgeInsets.only(left: 10),
    child: Row(
      children: [
        Text(
          text!.toUpperCase(),
          style: Theme.of(context).textTheme.subtitle2,
        ),
        const Spacer(),
        icon!,
      ],
    ),
  );
}

Widget userItem({required UserModel model, required BuildContext context}) {
  return InkWell(
    onTap: () {
      navigatorTo(context: context, page: ChatDetails(model: model));
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 25.0,
          backgroundImage: NetworkImage(model.image.toString()),
        ),
        spaceBetween(vertical: false),
        Text(
          model.username ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const Spacer(),
        IconButton(onPressed: (){
          toastMessage(message: "message");
          AppCubit.get(context).deleteChat(receiverId: model.id!);
        }, icon: const Icon(Icons.delete))
      ],
    ),
  );
}
