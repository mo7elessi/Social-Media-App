import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/validation/text_feild_validation.dart';

// ignore: must_be_immutable
class NewPost extends StatelessWidget {
  const NewPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var postController = TextEditingController();

    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, AppStates state) {
      if (state is UploadPostImageSuccessState) {
        toastMessage(message: 'posted');
      }
    }, builder: (context, AppStates state) {
      AppCubit cubit = AppCubit.get(context);
      String imageProfile = cubit.user!.image ?? '';
      return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 35.0,
                      width: 35.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        image: DecorationImage(
                          image: NetworkImage(imageProfile.toString()),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    spaceBetween(size: 6.0, vertical: false),
                    Text(
                      cubit.user!.username.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    ConditionalBuilder(
                      condition: state is! AddNewPostLoading,
                      builder: (BuildContext context) => TextButton(
                        onPressed: () {
                          var date = DateTime.now();
                          var dateFormat =
                          DateFormat().add_yMMMd().format(date);
                          var dateTime = dateFormat;
                          if(cubit.postImage == null){
                            toastMessage(message: "please choose image");
                          }else if(postController.text.isEmpty){
                            toastMessage(message: "please enter description");
                          } else{
                            cubit.addNewPost(
                              id: cubit.user!.id.toString(),
                              username: cubit.user!.username.toString(),
                              userImage: cubit.user!.image.toString(),
                              dateTime: dateTime.toString(),
                              text: postController.text,
                            );
                          }
                        },

                       child:  Text(
                         'POST',
                          style: TextStyle(color:cubit.postImage == null ?Colors.grey: primaryColor,),
                        ),
                      ),
                      fallback: (context) => const SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(strokeWidth: 3,)),
                    ),
                  ],
                ),
                spaceBetween(),
                textInputFieldLong(
                    context: context,
                    max: 100,
                    controller: postController,
                    keyboard: TextInputType.name,
                    hintText: 'What are you mind ?',
                    validator: none,
                    onChange: (value) {
                      cubit.valueOnChange = value;
                      print(value);
                    }),
                spaceBetween(),
                if (cubit.postImage != null)
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        height: 380,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          image: DecorationImage(
                            image: FileImage(cubit.postImage!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          cubit.removePostImage();
                        },
                        icon: const Icon(
                          Icons.close,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                spaceBetween(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: CircleAvatar(
                          backgroundColor:const Color(0xFFEA3535),
                          radius: 30,
                          child: IconButton(
                              onPressed: () {
                                cubit.pickPostImage();
                              },
                              icon: const Icon(
                                Icons.image,
                                size: 30,
                                color: Colors.white,
                              )),
                        )),
                    // spaceBetween(vertical: false),
                    Expanded(
                        child: CircleAvatar(
                          backgroundColor: const Color(0xFF0167CE),
                          radius: 30,
                          child: IconButton(
                              onPressed: () {
                                cubit.uploadToStorage();
                              },
                              icon: const Icon(
                                Icons.video_collection,
                                size: 30,
                                color: Colors.white,
                              )),
                        )),
                    // spaceBetween(vertical: false),
                    Expanded(
                        child: CircleAvatar(
                          backgroundColor: const Color(0xFF059C0D),
                          radius: 30,
                          child: IconButton(
                              onPressed: () {
                                cubit.pickVideo();
                              },
                              icon: const Icon(
                                Icons.camera,
                                size:30,
                                color: Colors.white,
                              )),
                        )),
                  ],
                ),
               // if(state is UploadVideoLoadingState)
              //    const CircularProgressIndicator()
              ],
            ),
          ),
        ),
      );
    });
  }
}
