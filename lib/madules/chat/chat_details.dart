import 'dart:io';

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/colors.dart';

// ignore: must_be_immutable
class ChatDetails extends StatelessWidget {
  UserModel model;

  ChatDetails({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      AppCubit.get(context).getMessages(receiverId: model.id!);
      return BlocConsumer<AppCubit, AppStates>(
          listener: (context, AppStates state) {},
          builder: (context, AppStates state) {
            var messageController = TextEditingController();
            AppCubit cubit = AppCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 18.0,
                      backgroundImage: NetworkImage(model.image.toString()),
                    ),
                    spaceBetween(size: 6, vertical: false),
                    Text(
                      model.username ?? ' ',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (cubit.messages.length == 0) Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'No message yet',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              spaceBetween(),
                              Text(
                                'Enter first message to ${model.username} :)',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ) else ConditionalBuilder(
                            condition: cubit.messages.length > 0,
                            fallback: (context) => const Center(
                                child: CircularProgressIndicator()),
                            builder: (BuildContext context) {
                              return Expanded(
                                flex: 100,
                                child: ListView.separated(
                                    reverse: true,
                                    physics: const BouncingScrollPhysics(),
                                    separatorBuilder: (context, index) =>
                                        spaceBetween(),
                                    itemCount: cubit.messages.length,
                                    itemBuilder: (context, index) {
                                      var message = cubit.messages[index];
                                      if (cubit.user!.id == message.senderId) {
                                        return Align(
                                          alignment:
                                              AlignmentDirectional.centerEnd,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                           mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              InkWell(
                                                onTap: (){
                                                  cubit.deleteMessage(receiverId: model.id!);
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadiusDirectional
                                                            .only(
                                                      topEnd:
                                                          Radius.circular(radius),
                                                      topStart:
                                                          Radius.circular(radius),
                                                      bottomStart:
                                                          Radius.circular(radius),
                                                    ),
                                                  ),
                                                  child: Text(
                                                      message.text.toString(),),
                                                ),
                                              ),
                                              spaceBetween(vertical: false,size: 6),
                                              Align(
                                                alignment:
                                                AlignmentDirectional.bottomEnd,
                                                child: CircleAvatar(
                                                  radius: 10.0,
                                                  backgroundImage: NetworkImage(
                                                      model.image.toString()),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      return Align(
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        child: Stack(
                                          alignment:
                                              AlignmentDirectional.topStart,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                color: primaryColor,
                                                borderRadius:
                                                    BorderRadiusDirectional
                                                        .only(
                                                  topEnd:
                                                      Radius.circular(radius),
                                                  topStart:
                                                      Radius.circular(radius),
                                                  bottomStart:
                                                      Radius.circular(radius),
                                                ),
                                              ),
                                              child: Text(
                                                message.text.toString(),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            CircleAvatar(
                                              radius: 15.0,
                                              backgroundImage: NetworkImage(
                                                  model.image.toString()),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                              );
                            }),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: messageController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter message',
                            ),
                          ),
                        ),
                        spaceBetween(vertical: false, size: 6),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.image,
                            size: 35.0,
                            color: primaryColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (messageController.text == null) {
                            } else {
                              cubit.sendMessage(
                                  receiverId: model.id!,
                                  dateTime: DateTime.now().toString(),
                                  text: messageController.text);
                            }
                          },
                          icon: const Icon(
                            Icons.send,
                            size: 35.0,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
    });
  }
}
