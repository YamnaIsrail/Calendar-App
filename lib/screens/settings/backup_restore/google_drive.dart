//
// import 'package:googleapis/drive/v3.dart';
// import 'package:googleapis_auth/auth_io.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// Future<void> listDriveFiles() async {
//   final user = FirebaseAuth.instance.currentUser;
//   if (user == null) {
//     print("User not authenticated");
//     return;
//   }
//
//   // Use the Google access token obtained from Firebase Authentication
//   final accessToken = await user.getIdToken();
//   final client = await clientViaAccessToken(AccessToken('Bearer', accessToken));
//
//   final driveApi = DriveApi(client);
//
//   // List the files in the user's Google Drive
//   var fileList = await driveApi.files.list();
//   for (var file in fileList.files!) {
//     print(file.name);
//   }
// }
//
//
//
// Future<void> uploadFile(String path, String mimeType) async {
//   final file = File(path);
//   final media = Media(file.openRead(), file.lengthSync());
//   final driveFile = File()
//     ..name = 'uploaded_file.txt'
//     ..mimeType = mimeType;
//
//   final driveApi = DriveApi(await clientViaAccessToken(AccessToken('Bearer', await FirebaseAuth.instance.currentUser!.getIdToken())));
//
//   final response = await driveApi.files.create(driveFile, uploadMedia: media);
//   print('File uploaded: ${response.name}');
// }
//
//
// Future<void> downloadFile(String fileId) async {
//   final driveApi = DriveApi(await clientViaAccessToken(AccessToken('Bearer', await FirebaseAuth.instance.currentUser!.getIdToken())));
//
//   final media = await driveApi.files.get(fileId, downloadOptions: DownloadOptions.fullMedia);
//   final file = File('downloaded_file.txt');
//   final sink = file.openWrite();
//   media.stream.listen((data) {
//     sink.add(data);
//   }, onDone: () {
//     sink.close();
//   });
// }
//
