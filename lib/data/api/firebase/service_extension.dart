// import 'firebase_service.dart';
//
// /// Experience
// extension OtherCollectionDemoService on FirebaseService {
//   /// collection name or id
//   static const collectionFireId = FireIds.otherCollection;
//
//   Future<List<OtherCollectionData>?> getAllExperience(String userId) async {
//     final data = await getCollection([FireIds.user, userId, collectionFireId]);
//
//     return data?.map((e) => OtherCollectionData.fromJson(e)).toList();
//   }
//
//   Future<String> addOtherDoc(OtherCollectionData value) async {
//     return await addDoc([...userPath, collectionFireId], value.toJson(),
//         documentId: value.id);
//   }
//
//   Future<void> updateOtherDoc(OtherCollectionData value) async {
//     await updateDoc([...userPath, collectionFireId, value.id], value.toJson());
//   }
//
//   Future<void> deleteExperience(String docId) async {
//     await deleteDoc([...userPath, collectionFireId, docId]);
//   }
// }
//
