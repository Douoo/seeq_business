import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:seeq_business/screens/profile_settings.dart';

import '../components/buttons.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/cloud_storage.dart';
import '../services/main_db.dart';
import '../utils/constants.dart';

enum ImageType { profile, cover }

class ProfileSetup extends StatefulWidget {
  static const String route = '/profile_setup';
  // final UserProfile user;

  // const ProfileSetup({Key? key, this.user}) : super(key: key);
  @override
  _ProfileSetupState createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  File? _profileImage;
  File? _coverImage;
  final picker = ImagePicker();
  final _auth = FirebaseAuth.instance;
  final _descriptionController = TextEditingController();

  bool _isLoading = false;

  // CloudStorageService _cloudStorageService = CloudStorageService();
  final cloudinary = CloudinaryPublic('dqminndjm', 'u8fstdwf', cache: true);

  Future getProfileImage(ImageSource source) async {
    final pickedImage = await picker.pickImage(source: source);

    setState(() {
      if (pickedImage != null) {
        _profileImage = File(pickedImage.path);
        Navigator.pop(context);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getCoverImage(ImageSource source) async {
    final pickedImage = await picker.pickImage(source: source);

    setState(() {
      if (pickedImage != null) {
        _coverImage = File(pickedImage.path);
        Navigator.pop(context);
      } else {
        print('No image selected.');
      }
    });
  }

  Future imagePickDialog(BuildContext context, ImageType imageType) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'UPLOAD IMAGE',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(),
              TextButton(
                child: Text(
                  'CAMERA',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.button,
                ),
                onPressed: () {
                  imageType == ImageType.profile
                      ? getProfileImage(ImageSource.camera)
                      : getCoverImage(ImageSource.camera);
                },
              ),
              TextButton(
                child: Text(
                  'GALLERY',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.button,
                ),
                onPressed: () {
                  imageType == ImageType.profile
                      ? getProfileImage(ImageSource.gallery)
                      : getCoverImage(ImageSource.gallery);
                },
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser =
        ModalRoute.of(context)!.settings.arguments as UserProfile;
    final authProfile =
        ScopedModel.of<Authentication>(context, rebuildOnChange: true);

    _descriptionController.text = currentUser.description!;

    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: kPrimaryColor,
            title: Text('Update profile'),
            centerTitle: true,
            elevation: 1),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 215,
                forceElevated: true,
                actions: [
                  Container(
                    color: kLightDark.withOpacity(0.3),
                    child: TextButton.icon(
                        icon: Icon(Icons.camera),
                        label: Text('Change Cover'),
                        onPressed: () =>
                            imagePickDialog(context, ImageType.cover),
                        style: TextButton.styleFrom(primary: kWhiteColor)),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Image.asset(
                      //   'images/background_image.jpg',
                      //   height: 200,
                      //   fit: BoxFit.cover,
                      // ),
                      GestureDetector(
                        onTap: () => imagePickDialog(context, ImageType.cover),
                        child: _coverImage == null && currentUser.coverPic != ''
                            ? CachedNetworkImage(
                                imageUrl: currentUser.coverPic!,
                                fit: BoxFit.fitWidth,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              )
                            : Container(
                                decoration: _coverImage == null
                                    ? const BoxDecoration(
                                        color: Colors.grey,
                                        image: DecorationImage(
                                          image: AssetImage('images/cover.png'),
                                          fit: BoxFit.fitWidth,
                                        ),
                                      )
                                    : BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.fitWidth,
                                            image: FileImage(_coverImage!))),
                              ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            imagePickDialog(context, ImageType.profile),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.all(14.0),
                            child: _profileImage == null
                                ? currentUser.profilePicture != null
                                    ? CachedNetworkImage(
                                        imageUrl: currentUser.profilePicture!,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                CircleAvatar(
                                          radius: 40,
                                          backgroundColor: kSecondaryColor,
                                          backgroundImage: imageProvider,
                                        ),
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                        errorWidget: (context, url, error) =>
                                            CircleAvatar(
                                                radius: 40,
                                                child: Icon(Icons.error)),
                                      )
                                    : Container(
                                        width: 80,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: kLightDark),
                                        child: Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: Icon(
                                            Icons.domain_outlined,
                                            size: 40,
                                            color: kWhiteColor,
                                          ),
                                        ),
                                      )
                                : CircleAvatar(
                                    radius: 40,
                                    backgroundImage: FileImage(_profileImage!),
                                  ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    ListTile(
                        leading: Icon(Icons.domain_outlined),
                        title: Text(currentUser.name)),
                    ListTile(
                        leading: Icon(Icons.phone_outlined),
                        title: Text(currentUser.phoneNumber)),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            onFieldSubmitted: (submitted) {
                              // FocusScope.of(context).requestFocus();
                            },
                            decoration: kTextFieldDecoration.copyWith(
                                labelText: 'Email',
                                icon: Icon(Icons.mail_outline)),
                          ),
                          TextFormField(
                            controller: _descriptionController,
                            onFieldSubmitted: (submitted) {
                              // FocusScope.of(context).requestFocus();
                            },
                            maxLines: 5,
                            decoration: kTextFieldDecoration.copyWith(
                              labelText: "Organizer's description",
                              icon: Icon(Icons.text_snippet_outlined),
                            ),
                          ),
                          TextFormField(
                            onFieldSubmitted: (submitted) {
                              // FocusScope.of(context).requestFocus();
                            },
                            decoration: kTextFieldDecoration.copyWith(
                                labelText: 'Website', icon: Icon(Icons.link)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: ScopedModelDescendant<AppModel>(
                          builder: (context, child, model) {
                        return RoundButton(
                          onTap: () async {
                            setState(() => _isLoading = true);

                            Map<String, dynamic> data = {
                              'phoneNumber': _auth.currentUser!.phoneNumber,
                              'displayName': _auth.currentUser!.displayName,
                              'about': _descriptionController.text,
                              'photoUrl': currentUser.profilePicture ?? '',
                              'coverPhoto': currentUser.coverPic ?? '',
                            };

                            CloudinaryResponse response;
                            CloudinaryResponse response2;
                            try {
                              if (_profileImage != null &&
                                  _coverImage != null) {
                                response = await cloudinary.uploadFile(
                                  CloudinaryFile.fromFile(_profileImage!.path,
                                      resourceType:
                                          CloudinaryResourceType.Image),
                                );

                                response2 = await cloudinary.uploadFile(
                                  CloudinaryFile.fromFile(_coverImage!.path,
                                      resourceType:
                                          CloudinaryResourceType.Image),
                                );

                                data['photoUrl'] = response.secureUrl;
                                data['coverPhoto'] = response2.secureUrl;
                                _auth.currentUser!
                                    .updatePhotoURL(response.secureUrl);
                                authProfile.updateProfile(data).then(
                                    (_) => setState(() => _isLoading = false));
                              } else if (_profileImage != null) {
                                response = await cloudinary.uploadFile(
                                  CloudinaryFile.fromFile(_profileImage!.path,
                                      resourceType:
                                          CloudinaryResourceType.Image),
                                );
                                _auth.currentUser!
                                    .updatePhotoURL(response.secureUrl);
                                data['photoUrl'] = response.secureUrl;

                                authProfile.updateProfile(data).then((_) {
                                  setState(() => _isLoading = false);
                                });
                              } else if (_coverImage != null) {
                                response = await cloudinary.uploadFile(
                                  CloudinaryFile.fromFile(_coverImage!.path,
                                      resourceType:
                                          CloudinaryResourceType.Image,
                                      folder: _auth.currentUser!.uid),
                                );
                                data['coverPhoto'] = response.secureUrl;
                                authProfile.updateProfile(data).then(
                                    (_) => setState(() => _isLoading = false));
                              }
                            } on CloudinaryException catch (e) {
                              print(e.message);
                              print(e.request);
                            }
                          },
                          title: 'UPDATE PROFILE',
                        );
                      }),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
