// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class ChatServiceManager {
//   final FirebaseAuth auth = FirebaseAuth.instance;
//
//   /// Create A User
//   Future<void> createUser({required String email, required String password, required String name, required String mobile}) async {
//     try {
//       UserCredential userCredential = await auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       String uid = userCredential.user!.uid;
//
//       await FirebaseFirestore.instance.collection('users').doc(uid).set({
//         'name': name,
//         'email': email,
//         'uid': uid,
//         'mobile': mobile,
//         'profile_pic': Session.userProfileImage,
//       });
//
//       FirebaseUserResponseModel firebaseUserResponseModel = FirebaseUserResponseModel(
//         uid: uid,
//         mobile: mobile,
//         profilePic: '',
//         email: email,
//         name: name,
//       );
//
//       Session.firebaseResponse = firebaseUserResponseModelToJson(firebaseUserResponseModel);
//       Session.firebaseUId = uid;
//
//       showLog('User created successfully');
//     } catch (e) {
//       showLog('Error creating user: $e');
//     }
//   }
//
//   Future<bool> signInUser(String email, String password) async {
//     try {
//       UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
//       Session.firebaseUId = userCredential.user?.uid ?? '';
//       showLog('Check Firebase User Id ${Session.firebaseUId} - ${userCredential.user?.uid}');
//       return true;
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         print('❌ Error: No user found for this email.');
//       } else if (e.code == 'wrong-password') {
//         print('❌ Error: Incorrect password.');
//       } else {
//         print('🚨 Error: ${e.message}');
//       }
//       return false;
//     }
//   }
//
//   Future<bool> checkUserExists(String email) async {
//     try {
//       List<String> signInMethods = await auth.fetchSignInMethodsForEmail(email);
//
//       if (signInMethods.isNotEmpty) {
//         print('User exists with email: $email');
//         return true;
//       } else {
//         print('User does not exist.');
//         return false;
//       }
//     } catch (e) {
//       print('Error checking user existence: $e');
//       return false;
//     }
//   }
//
//   /// Get Chat Or Create Chat
//   Future<String> getChatID({
//     required String receiverId,
//     required String requestNumber,
//     required String displayName,
//     required int displayNameUId,
//     required String postedBy,
//     required int postedByUId,
//     required int requestId,
//   }) async {
//     String currentUserUID = Session.firebaseUId;
//     String receiverUID = receiverId;
//
//     String customChatID = '${currentUserUID}_${requestNumber}_$receiverUID';
//
//     final DocumentReference chatRef = FirebaseFirestore.instance.collection('chats').doc(customChatID);
//
//     final DocumentSnapshot chatDoc = await chatRef.get();
//
//     if (!chatDoc.exists) {
//       // If chat does not exist, create a new one with display_name
//       await chatRef.set({
//         'user1ID': currentUserUID,
//         'user2ID': receiverUID,
//         'createdAt': FieldValue.serverTimestamp(),
//         'display_name': displayName,
//         'display_name_user_id': displayNameUId.toString(),
//         'posted_by': postedBy,
//         'posted_by_id': postedByUId.toString(),
//         'request_id': requestId.toString(),
//       });
//     } else {
//       // If chat exists, update the display_name field
//       await chatRef.update({
//         'display_name': displayName,
//         'display_name_user_id': displayNameUId.toString(),
//         'posted_by': postedBy,
//         'posted_by_id': postedByUId.toString(),
//         'request_id': requestId.toString(),
//       });
//     }
//
//     return customChatID;
//   }
//
//   /// Send Message
//   Future<void> sendMessage({required String chaId, required String messageContent, String image = ''}) async {
//     if (messageContent.isEmpty) return;
//
//     await FirebaseFirestore.instance.collection('chats').doc(chaId).collection('messages').add({
//       'senderID': Session.firebaseUId,
//       'message': messageContent,
//       'timestamp': FieldValue.serverTimestamp(),
//       'image': image,
//     });
//   }
//
//   Future<FirebaseUserResponseModel?> getUserInfo({required String userId}) async {
//     DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
//     FirebaseUserResponseModel? firebaseUserResponseModel;
//     if (userSnapshot.exists) {
//       firebaseUserResponseModel = FirebaseUserResponseModel(
//         name: userSnapshot['name'] ?? '',
//         mobile: userSnapshot['mobile'] ?? '',
//         email: userSnapshot['email'] ?? '',
//         profilePic: userSnapshot['profile_pic'] ?? '',
//         uid: userSnapshot['uid'] ?? '',
//       );
//     } else {
//       showLog('User document not found!');
//     }
//     return firebaseUserResponseModel;
//   }
//
//   Future<String> getLastMessageOnce(String chatId) async {
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('chats').doc(chatId).collection('messages').orderBy('timestamp', descending: true).limit(1).get();
//     DocumentSnapshot? lastMessage = querySnapshot.docs.isNotEmpty ? querySnapshot.docs.first : null;
//
//     var data = lastMessage?.data() as Map<String, dynamic>?;
//
//     String lastMsg = '';
//     if (data?['message'] != null) {
//       lastMsg = data?['message'];
//     } else {
//       lastMsg = '';
//     }
//     return lastMsg;
//   }
//
//   Future<String> getDisplayNameOnce(String chatId) async {
//     DocumentSnapshot chatDoc = await FirebaseFirestore.instance.collection('chats').doc(chatId).get();
//
//     if (chatDoc.exists) {
//       Map<String, dynamic>? data = chatDoc.data() as Map<String, dynamic>?;
//
//       return data?['display_name'] ?? ''; // Return display_name or empty string if not found
//     }
//     return ''; // Return empty string if chat does not exist
//   }
//
//   Future<String> getDisplayNameUIDOnce(String chatId) async {
//     DocumentSnapshot chatDoc = await FirebaseFirestore.instance.collection('chats').doc(chatId).get();
//
//     if (chatDoc.exists) {
//       Map<String, dynamic>? data = chatDoc.data() as Map<String, dynamic>?;
//
//       return data?['display_name_user_id'].toString() ?? ''; // Return display_name or empty string if not found
//     }
//     return '0'; // Return empty string if chat does not exist
//   }
//
//   Future<String> getPostedByNameOnce(String chatId) async {
//     DocumentSnapshot chatDoc = await FirebaseFirestore.instance.collection('chats').doc(chatId).get();
//
//     if (chatDoc.exists) {
//       Map<String, dynamic>? data = chatDoc.data() as Map<String, dynamic>?;
//
//       return data?['posted_by'] ?? ''; // Return display_name or empty string if not found
//     }
//     return ''; // Return empty string if chat does not exist
//   }
//
//   Future<String> getRequestId(String chatId) async {
//     DocumentSnapshot chatDoc = await FirebaseFirestore.instance.collection('chats').doc(chatId).get();
//
//     if (chatDoc.exists) {
//       Map<String, dynamic>? data = chatDoc.data() as Map<String, dynamic>?;
//
//       return data?['request_id'] ?? ''; // Return display_name or empty string if not found
//     }
//     return ''; // Return empty string if chat does not exist
//   }
//
//   Future<String> getPostedByIdOnce(String chatId) async {
//     DocumentSnapshot chatDoc = await FirebaseFirestore.instance.collection('chats').doc(chatId).get();
//
//     if (chatDoc.exists) {
//       Map<String, dynamic>? data = chatDoc.data() as Map<String, dynamic>?;
//
//       return data?['posted_by_id'].toString() ?? ''; // Return display_name or empty string if not found
//     }
//     return '0'; // Return empty string if chat does not exist
//   }
//
//   Future<String> uploadImage(File imageFile) async {
//     try {
//       String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//       Reference storageRef = FirebaseStorage.instance.ref().child('chat_images/$fileName');
//
//       UploadTask uploadTask = storageRef.putFile(imageFile);
//
//       TaskSnapshot snapshot = await uploadTask;
//       String imageUrl = await snapshot.ref.getDownloadURL();
//       return imageUrl;
//     } catch (e) {
//       showLog('Error uploading image: $e');
//       return '';
//     }
//   }
// }
