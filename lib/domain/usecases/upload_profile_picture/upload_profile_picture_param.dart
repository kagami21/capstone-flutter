import 'dart:io';

import 'package:flix_movie/domain/entities/user/user.dart';

class UploadProfilePictureParam {
  final File imageFile;
  final User user;

  UploadProfilePictureParam({required this.imageFile, required this.user});
}
