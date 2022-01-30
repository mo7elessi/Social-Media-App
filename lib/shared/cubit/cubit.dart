import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/madules/add_post/add_post.dart';
import 'package:social_app/madules/chat/users.dart';
import 'package:social_app/madules/home/home.dart';
import 'package:social_app/madules/profile/profile.dart';
import 'package:social_app/model/comment_model.dart';
import 'package:social_app/model/message_model.dart';
import 'package:social_app/model/post_model.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/shared/components/constance.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore store = FirebaseFirestore.instance;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  List<Widget> screens = const [];
  List<Widget> buildScreens = [
    const Home(),
    const Home(),
    const NewPost(),
    const Users(),
    const Profile(),
  ];

  int currentIndex = 0;

  List<String> appBarTitle = ['HOME', 'Search', 'New Post', 'Chats', 'Profile'];

  List<BottomNavigationBarItem> navBarsItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: 'Search'),
    BottomNavigationBarItem(icon: Icon(Icons.add_rounded), label: 'Add'),
    BottomNavigationBarItem(icon: Icon(Icons.message_rounded), label: 'Chat'),
    BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
  ];

  void onClickItemNav(int index) {
    if (index == 2) emit(AddNewPostSuccess());
    if (index == 3) getUsers();
    currentIndex = index;
    emit(BottomNavigationState());
  }

  UserModel? user;

// get current user data
  void getProfileData() {
    emit(GetProfileDataLoading());
    store.collection('users').doc(userId).get().then((value) {
      print("current user id: $userId");
      user = UserModel.fromJson(value.data());
      emit(GetProfileDataSuccess(user!));
    }).catchError((onError) {
      emit(GetProfileDataFaild());
      print('error in get user data: ' + onError.toString());
    });
  }

  File? profileImage;
  var picker = ImagePicker();

//pick image to user profile
  Future<void> pickProfileImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      emit(SocialProfileImagePickedErrorState());
    }
  }

  String valueOnChange = '';
  String newText = '';

  void updateUser(
      {String? username,
      String? phone,
      String? bio,
      String? address,
      bool isEmailVerified = false,
      String? image}) {
    emit(UpdateProfileLoading());

    UserModel userModel = UserModel(
      email: user!.email,
      id: user!.id,
      isEmailVerified: isEmailVerified,
      username: username ?? user!.username,
      phone: phone ?? user!.phone,
      address: address ?? user!.address,
      bio: bio ?? user!.bio,
      image: image ?? user!.image,
    );
    store
        .collection('users')
        .doc(user!.id)
        .update(userModel.toMap())
        .then((value) {
      emit(UpdateProfileSuccess());
      getProfileData();
    }).catchError((onError) {
      print('error via update data: ' + onError.toString());
      emit(UpdateProfileError());
    });
  }

  void updateImage() {
    emit(UploadImageLoadingState());
    storage
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      getProfileData();
      value.ref.getDownloadURL().then((value) {
        updateUser(
          username: user!.username,
          phone: user!.phone,
          address: user!.address,
          bio: user!.bio,
          image: value,
        );
        emit(UploadImageSuccessState(value));
      }).catchError((error) {
        emit(UploadImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState());
    });
  }

  File? postImage;
  var pickImagePost = ImagePicker();

  Future<void> pickPostImage() async {
    final pickedFile = await pickImagePost.getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(PostImagePickedSuccessState());
    } else {
      print('No image selected.');
    }
  }

  void addNewPost({
    required String id,
    required String username,
    required String userImage,
    required String dateTime,
    required String text,
  }) {
    emit(AddNewPostLoading());
    storage
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        PostModel post = PostModel(
            id: id,
            username: username,
            userImage: userImage,
            text: text,
            dateTime: dateTime,
            image: value,
            comments: 0,
            likes: 0);
        store.collection("posts").add(post.toMap()).then((value) {
          removePostImage();
          likes = [];
          comments = [];
          getPosts();
        }).catchError((onError) {
          print('error via add post: ' + onError.toString());
          emit(AddNewPostError());
        });
      });

      emit(UploadPostImageSuccessState());
    });
  }

  void addNewPostWithOutImage({
    required String id,
    required String username,
    required String dateTime,
    required String userImage,
    required String text,
  }) {
    emit(AddNewPostLoading());
    PostModel post = PostModel(
        id: id,
        username: username,
        userImage: userImage,
        text: text,
        dateTime: dateTime,
        image: '',
        comments: 0,
        likes: 0);
    store.collection("posts").add(post.toMap()).then((value) {
      emit(UploadPostImageSuccessState());
    }).catchError((onError) {
      print('error via add post: ' + onError.toString());
      emit(AddNewPostError());
    });
  }

  void removePostImage() {
    postImage = null;
    emit(RemovedImageState());
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<String> userLikesId = [];
  List<String> userCommentsId = [];
  List<int> likes = [];
  List<int> comments = [];

  Color colorLikeIcon = Colors.redAccent;
  Color colorUnlikeIcon = Colors.grey;

  void getPosts() {
    emit(GetPostsLoading());
    store
        .collection('posts')
        .orderBy('dateTime', descending: true)
        .get()
        .then((value) {
      posts = [];
      for (var element in value.docs) {
        element.reference.collection("likes").get().then((value) {
          likes.add(value.docs.length);
          for (var element in value.docs) {
            if (element.id == user!.id) {
              userLikesId.add(element.id);
            }
          }
        }).catchError((onError) {});
        element.reference.collection("comments").get().then((value) {
          comments.add(value.docs.length);
          for (var element in value.docs) {
            if (element.id == user!.id) {
              userCommentsId.add(element.id);
            }
          }
        }).catchError((onError) {});
        postsId.add(element.id);
        posts.add(PostModel.fromJson(element.data()));
      }
      emit(GetPostsSuccess());
    }).catchError((onError) {
      emit(GetPostsError());
      print('error via get posts: ' + onError.toString());
    });
  }

  List<UserModel> users = [];

  void getUsers() {
    if (users.length == 0) {
      emit(GetUsersLoadingState());
      store.collection('users').get().then((value) {
        for (var element in value.docs) {
          if (element.data()['id'] != user!.id) {
            users.add(UserModel.fromJson(element.data()));
          }
        }
        emit(GetUsersSuccessState());
      }).catchError((onError) {
        emit(GetUsersErrorState());
        print('error via get users: ' + onError.toString());
      });
    }
  }

//chat
  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
  }) {
    MessageModel model = MessageModel(
      text: text,
      senderId: user!.id,
      receiverId: receiverId,
      dateTime: dateTime,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(
          user!.id,
        )
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SendMessagesSuccessState());
    }).catchError((error) {
      emit(SendMessagesErrorState());
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(
          user!.id,
        )
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SendMessagesSuccessState());
    }).catchError((error) {
      emit(SendMessagesErrorState());
    });
  }

  List<MessageModel> messages = [];

  void getMessages({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.id)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) {
      messages = [];

      for (var element in event.docs) {
        messages.add(MessageModel.fromJson(element.data()));
      }

      emit(GetMessagesSuccessState());
    });
  }

  void deleteChat({required String receiverId}) {
    store
        .collection('users')
        .doc(user!.id)
        .collection('chat')
        .doc(receiverId)
        .delete().then((value) {
          emit(ChatDeletedSuccessState());
    }).catchError((onError){
      print(onError);
      emit(ChatDeletedErrorState());
    });
  }

  void deleteMessage(
      {required String receiverId}) {
     store
        .collection('users')
        .doc(user!.id)
        .collection('chat')
        .doc(receiverId)
        .collection("messages").doc()
        .delete();
  }

  void likePost({required String postId}) {
    store
        .collection("posts")
        .doc(postId)
        .collection("likes")
        .doc(user!.id)
        .set({'like': true}).then((value) {
      emit(PostLikeStateSuccess());
    }).catchError((onError) {
      emit(PostLikeStateError());
    });
  }

  void unlikePost({required String postId}) {
    store
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(user!.id)
        .delete()
        .then((value) {
      userLikesId.remove(postId);
      emit(PostUnLikeStateSuccess());
    }).catchError((error) {
      emit(PostUnLikeStateError());
    });
  }

  List<CommentModel> comment = [];

  void commentPost({required String postId, required String text}) {
    emit(PostCommentStateLoading());
    CommentModel comment = CommentModel(
      userId: user!.id,
      userImage: user!.image,
      userName: user!.username,
      dateTime: '10 PM',
      text: text,
      postId: postId,
    );
    store
        .collection("posts")
        .doc(postId)
        .collection("comments")
        .add(comment.toMap())
        .then((value) {
      emit(PostCommentStateSuccess());
    }).catchError((onError) {
      emit(PostCommentStateError());
    });
  }

  File? video;
  var file = ImagePicker();

  Future<void> pickVideo() async {
    final pickedFile = await file.getVideo(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      video = File(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      print('No video selected.');
      emit(SocialProfileImagePickedErrorState());
    }
  }

  void uploadToStorage() {
    emit(UploadVideoLoadingState());

    storage
        .ref()
        .child('videos/${Uri.file(video!.path).pathSegments.last}')
        .putFile(
            video!, firebase_storage.SettableMetadata(contentType: 'video/mp4'))
        .then(
      (value) {
        value.ref.getDownloadURL().then(
          (value) {
            print(value);
            emit(UploadVideoSuccessState());
          },
        ).catchError((onError) {
          print('error 1: $onError');
        });
      },
    ).catchError((onError) {
      print('error 2: $onError');
    });
  }
}
