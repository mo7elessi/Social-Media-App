import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/validation/text_feild_validation.dart';

// ignore: must_be_immutable
class EditProfile extends StatelessWidget {
  EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bioController = TextEditingController();
    var addressController = TextEditingController();
    var phoneController = TextEditingController();
    var usernameController = TextEditingController();
    var imageProfile = '';
    var formKey = GlobalKey<FormState>();

    return BlocConsumer<AppCubit, AppStates>(listener: (context, state) {
      if (state is UploadImageSuccessState) {
        imageProfile = state.imageUri;
        toastMessage(message: "image uploaded");
      }
      if (state is UpdateProfileSuccess) {
        toastMessage(message: "changed saved");
      }
    }, builder: (context, state) {
      AppCubit cubit = AppCubit.get(context);
      var user = cubit.user;
     if (user != null) {
        usernameController.text = user.username!;
        bioController.text = user.bio ?? '';
        addressController.text = user.address ?? '';
        phoneController.text = user.phone ?? '';
        imageProfile = user.image ??
            'https://www.kindpng.com/picc/m/24-248253_user-profile-default-image-png-clipart-png-download.png';
      }

      return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'.toUpperCase()),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  header(
                    text: 'profile image',
                    context: context,
                    icon: ConditionalBuilder(
                      condition: state is! UploadImageLoadingState,
                      builder: (BuildContext context) => IconButton(
                          onPressed: () {
                            cubit.updateImage();
                          },
                          icon: cubit.profileImage != null
                              ? const Icon(Icons.check)
                              : const SizedBox()),
                      fallback: (context) =>    const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: SizedBox(height: 28,width: 28, child: CircularProgressIndicator(strokeWidth: 2,)),
                      ),
                    ),
                  ),
                  spaceBetween(),
                  Row(
                    children: [
                      TextButton(
                        child: Text(
                          user!.image == null
                              ? 'Choose image'.toUpperCase()
                              : 'Choose New image'.toUpperCase(),
                          style: const TextStyle(
                              color: primaryColor,
                              fontSize: 12.0,
                              decoration: TextDecoration.underline),
                        ),
                        onPressed: () {
                          cubit.pickProfileImage();
                        },
                      ),
                      const Spacer(),
                      Container(
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          image: cubit.profileImage == null
                              ? DecorationImage(
                                  image: NetworkImage(imageProfile),
                                  fit: BoxFit.cover,
                                )
                              : DecorationImage(
                                  image: FileImage(cubit.profileImage!),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ],
                  ),
                  spaceBetween(size: 24),
                  Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        header(
                          text: 'Your information',
                          context: context,
                          icon: ConditionalBuilder(
                            condition: state is! UpdateProfileLoading,
                            builder: (BuildContext context) => IconButton(
                                onPressed: () {
                                  cubit.updateUser(
                                    username: usernameController.text,
                                    address: addressController.text,
                                    phone: phoneController.text,
                                    bio: bioController.text,
                                  );
                                },
                                icon: const Icon(Icons.check)),
                            fallback: (context) =>
                                const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: SizedBox(height: 28,width: 28, child: CircularProgressIndicator(strokeWidth: 2,)),
                                ),
                          ),
                        ),
                        spaceBetween(),
                        textInputField(
                          context: context,
                          controller: usernameController,
                          keyboard: TextInputType.name,
                          hintText: 'Enter Username',
                          prefixIcon: Icons.person_rounded,
                          validator: nameValidator,
                        ),
                        /*   spaceBetween(),
                                IntlPhoneField(
                                  decoration:  InputDecoration(
                                    hintText: 'Enter Phone',
                                 //   icon: const Icon(Icons.phone_rounded),
                                    alignLabelWithHint: false,
                                    counterStyle: Theme.of(context).textTheme.subtitle2
                                  ),
                                  controller: phoneController,
                                  onChanged: (phone) {
                                  //  print(phone.completeNumber);
                                  },
                                  countryCodeTextColor:smallTextColor,
                                  initialCountryCode: '+970',
                                  showDropdownIcon: false,
                                  onCountryChanged: (phone) {
                                    print('Country code changed to: ' +
                                        phone.countryCode.toString());
                                  },
                                ),*/
                        spaceBetween(),
                        textInputField(
                          context: context,
                          controller: phoneController,
                          keyboard: TextInputType.phone,
                          hintText: 'Enter Phone',
                          prefixIcon: Icons.phone_rounded,
                          validator: nameValidator,
                        ),
                        spaceBetween(),
                        textInputField(
                          context: context,
                          controller: addressController,
                          keyboard: TextInputType.streetAddress,
                          hintText: 'Enter Address',
                          prefixIcon: Icons.location_on_rounded,
                          validator: nameValidator,
                        ),
                        spaceBetween(size: 24),
                         Text('Enter BIO'.toUpperCase(),style: Theme.of(context).textTheme.subtitle2,),
                        spaceBetween(),
                        textInputFieldLong(
                            context: context,
                            max: 100,
                            controller: bioController,
                            keyboard: TextInputType.name,
                            hintText: '',
                            validator: nameValidator,
                            onChange: (value) {
                              cubit.valueOnChange = value;
                              print(value);
                            }),
                        /* spaceBetween(size: 24),
                        ConditionalBuilder(
                          condition: state is! UpdateProfileLoading,
                          builder: (context) {
                            return primaryButton(
                              text: 'Save Changes',
                              function: () {
                                //  if (formKey.currentState!.validate()) {
                                cubit.updateUser(
                                  username: usernameController.text,
                                  bio: bioController.text,
                                  address: addressController.text,
                                  phone: phoneController.text,
                                );
                                //}
                              },
                            );
                          },
                          fallback: (context) {
                            return const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                              ),
                            );
                          },
                        ),*/
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
    });
  }
}
