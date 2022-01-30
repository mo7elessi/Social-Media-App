
import 'package:social_app/model/user_model.dart';

abstract class AppStates {}

class AppInitialState extends AppStates {}

class BottomNavigationState extends AppStates {}

class AppChangeModeState extends AppStates {}

class GetProfileDataSuccess extends AppStates {
  final UserModel user;

  GetProfileDataSuccess(this.user);
}

class GetProfileDataLoading extends AppStates {}

class GetProfileDataFaild extends AppStates {}

class SocialProfileImagePickedSuccessState extends AppStates {}

class SocialProfileImagePickedErrorState extends AppStates {}

class SocialUserUpdateLoadingState extends AppStates {}

class SocialUploadProfileImageErrorState extends AppStates {}

class UploadImageErrorState extends AppStates {}

class UploadImageLoadingState extends AppStates {}

class UploadImageSuccessState extends AppStates {
  String imageUri;

  UploadImageSuccessState(this.imageUri);
}

class UpdateProfileLoading extends AppStates {}

class UpdateProfileSuccess extends AppStates {}

class UpdateProfileError extends AppStates {}

class UpdateProfileImageLoading extends AppStates {}

class UpdateProfileImageSuccess extends AppStates {}

class UpdateProfileImageError extends AppStates {}

class PostImagePickedSuccessState extends AppStates {}

class AddNewPostLoading extends AppStates {}

class AddNewPostSuccess extends AppStates {}

class AddNewPostError extends AppStates {}

class UploadPostImageSuccessState extends AppStates {}

class RemovedImageState extends AppStates {}

class GetPostsSuccess extends AppStates {}

class GetPostsLoading extends AppStates {}

class GetPostsError extends AppStates {}

class PostLikeStateSuccess extends AppStates {}

class PostLikeStateLoading extends AppStates {}

class PostLikeStateError extends AppStates {}

class PostUnLikeStateSuccess extends AppStates {}

class PostUnLikeStateLoading extends AppStates {}

class PostUnLikeStateError extends AppStates {}

class PostCommentStateSuccess extends AppStates {}

class PostCommentStateLoading extends AppStates {}

class PostCommentStateError extends AppStates {}

class GetUsersSuccessState extends AppStates {}

class GetUsersLoadingState extends AppStates {}

class GetUsersErrorState extends AppStates {}

class GetMessagesSuccessState extends AppStates {}

class GetMessagesLoadingState extends AppStates {}

class GetMessagesErrorState extends AppStates {}

class SendMessagesSuccessState extends AppStates {}

class SendMessagesLoadingState extends AppStates {}

class SendMessagesErrorState extends AppStates {}

class UploadVideoSuccessState extends AppStates {}

class UploadVideoLoadingState extends AppStates {}

class UploadVideoErrorState extends AppStates {}

class ChatDeletedSuccessState extends AppStates {}

class ChatDeletedLoadingState extends AppStates {}

class ChatDeletedErrorState extends AppStates {}
