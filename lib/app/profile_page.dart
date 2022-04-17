import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_lovers_app/common_widgets/platform_respensive_alert.dart';
import 'package:flutter_lovers_app/viewmodel/user_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common_widgets/login_buttons.dart';
import '../providers/all_providers.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late TextEditingController _controllerUsername;
  late File? _profilePhoto = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerUsername = TextEditingController();
  }

  @override
  void dispose() {
    _controllerUsername.dispose();
    super.dispose();
  }

  Future takePhotoFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _profilePhoto = File(pickedFile.path);
        Navigator.of(context).pop();
      });
    }
  }

  Future selectPhotoFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profilePhoto = File(pickedFile.path);
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var _userViewModelProvider =
        ref.watch<UserViewModel>(userViewModelProvider);

    _controllerUsername.text = _userViewModelProvider.user!.userName!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          TextButton(
              onPressed: () {
                confirmationForExit(context, _userViewModelProvider);
              },
              child: const Text(
                "Çıkış",
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 160,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.camera),
                                  title: const Text("Kameradan çek"),
                                  onTap: () {
                                    takePhotoFromCamera();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.camera),
                                  title: const Text("Galeriden seç"),
                                  onTap: () {
                                    selectPhotoFromGallery();
                                  },
                                )
                              ],
                            ),
                          );
                        });
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 75,
                    backgroundImage: _profilePhoto!= null ? Image.file(_profilePhoto!, fit: BoxFit.cover,).image : NetworkImage(_userViewModelProvider.user!.profileUrl!),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _userViewModelProvider.user!.email,
                  readOnly: true,
                  decoration: const InputDecoration(
                      labelText: "Emailiniz",
                      hintText: "Email",
                      border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controllerUsername,
                  decoration: const InputDecoration(
                      labelText: "Kullanıcı adınız",
                      hintText: "Kullanıcı adı",
                      border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: LoginButton(
                  buttonText: 'Değişiklikleri kaydet',
                  buttonColor: Colors.purple,
                  buttonTextColor: Colors.white,
                  onPressed: () {
                    _updateUsername(context,_userViewModelProvider);
                    _imageUpload(context,_userViewModelProvider);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> exitFromAuth(UserViewModel _userViewModelProvider) async {
    bool result = await _userViewModelProvider.signOut();
    return result;
  }

  Future confirmationForExit(
      BuildContext context, UserViewModel userViewModelProvider) async {
    final result = await PlatformResponsiveAlertDialog(
      header: "Emin misiniz?",
      content: "Çıkmak istediğinizden emin misiniz?",
      okButton: "Evet",
      cancelButton: "Vazgeç",
    ).show(context);

    if (result == true) {
      exitFromAuth(userViewModelProvider);
    }
  }

  void _updateUsername(BuildContext context,UserViewModel userViewModel) async {
    if (userViewModel.user!.userName != _controllerUsername.text) {
      bool updateResult = await userViewModel.updateUsername(
          userViewModel.user!.userID, _controllerUsername.text);

      if (updateResult) {
        userViewModel.user!.userName = _controllerUsername.text;
        PlatformResponsiveAlertDialog(
                header: "Başarılı",
                content: "Kullanıcı adı değiştirildi",
                okButton: "Tamam")
            .show(context);
      } else {
        PlatformResponsiveAlertDialog(
                header: "Hata",
                content:
                    "Kullanıcı adı zaten kullanımda, farklı bir kullanıcı adı deneyiniz.",
                okButton: "Tamam")
            .show(context);
      }
    }
  }

  void _imageUpload(BuildContext context,UserViewModel userViewModel) async{
    if(_profilePhoto!=null){
     var url = await userViewModel.uploadFile(userViewModel.user!.userID,"profile_image",_profilePhoto);
      if(url!=null){
        PlatformResponsiveAlertDialog(content: "Başarılı",header: "Profil fotoğrafı güncellendi",okButton: "Tamam").show(context);
      }
    }
  }
}
