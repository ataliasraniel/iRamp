import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:thunderapp/shared/constants/app_enums.dart';
import 'package:thunderapp/shared/core/entities/ramp_model.dart';
import 'package:thunderapp/shared/core/features/notifications/notifications_manager.dart';
import 'package:thunderapp/shared/core/toast/app_notification_manager.dart';

class FirestoreDatabaseManager {
  final _db = FirebaseFirestore.instance;
  static const String recipesCollectionName = 'recipes';
  static const String triviaCollectionName = 'trivia';
  static const String rampCollectionName = 'ramps';
  static const String usersColletionName = 'users';

  final user = FirebaseAuth.instance;
  List<RampModel> ramps = [];

  Future<bool> createUserInDB(String email) async {
    _db
        .collection(usersColletionName)
        .add({'email': email, 'favs': []}).then((value) {
      return true;
    });
    return false;
  }

  Future<bool> createNewRampInDb(
      String reference,
      String description,
      int rank,
      double latitude,
      double longitude) async {
    _db.collection(rampCollectionName).add({
      'lat': latitude,
      'long': longitude,
      'imageUrl': 'asdasd',
      'rank': rank,
      'reference': reference,
      'description': description
    }).then((value) {
      log('Successfuly create new ramp');
      AppSnackbarManager.showSimpleNotification(
          NotificationType.success, 'Sucesso!');
      return true;
    }).catchError((e) {
      log('something got wrong $e');
    });
    return false;
  }

  Future<List<RampModel>> getRamps() async {
    await _db
        .collection(rampCollectionName)
        .get()
        .then((result) {
      for (var doc in result.docs) {
        log(doc.data()['lat'].toString());
        ramps.add(RampModel(doc.data()['lat'],
            doc.data()['long'], doc.data()['rank']));
        // recipes.add(RampModel(
        //     doc.data()['title'],
        //     doc.data()['description'],
        //     doc.data()['timesMade'],
        //     doc.data()['rating'].toDouble(),
        //     doc.data()['steps'],
        //     doc.data()['igredients'],
        //     doc.data()['difficulty'].runtimeType == String
        //         ? int.parse(doc.data()['difficulty'])
        //         : doc.data()['difficulty'],
        //     false,
        //     doc.id));
      }
      return ramps;
    }).catchError((e) {
      print(e);
    });
    return ramps;
  }

  Future<List<String>> getTriviaTexts() async {
    late List<String> texts = [];
    await _db.collection("trivia").get().then((event) {
      for (var doc in event.docs) {
        texts.add(doc.data()['text']);
      }
    });
    return texts;
  }

  Future saveFavoriteRecipe(
      {required RampModel recipe}) async {
    try {
      final collection = _db
          .collection(usersColletionName)
          .where('email',
              isEqualTo: user.currentUser!.email);
      collection.get().then((value) {
        for (var element in value.docs) {
          // element.reference.update({
          //   'favs': FieldValue.arrayUnion([
          //     {
          //       'title': recipe.title,
          //       'description': recipe.description,
          //       'steps': recipe.steps,
          //       'igredients': recipe.igredients,
          //       'difficulty': recipe.difficulty
          //     }
          //   ])
          // });
        }
      });
      //!!ADD A NEW USER INTO COLLECTION
      // _db.collection(usersColletionName).add({
      //   'email': user.currentUser!.email,
      //   'favs': [
      //     {
      //       'title': 'Ovo de codorna pra cumerrr',
      //       'description': 'Have you ever see the rain?'
      //     }
      //   ]
      // });
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> unfovorite(RampModel recipe) async {
    try {
      final collection = _db
          .collection(usersColletionName)
          .where('email',
              isEqualTo: user.currentUser!.email);
      collection.get().then((value) {
        for (var element in value.docs) {
          // element.reference.update({
          //   'favs':
          //       FieldValue.arrayRemove([recipe.toJson()])
          // });
          log('succesfuly removed favorite');
        }
      });
      return true;
    } on FirebaseException catch (fe) {
      log('something got wrong while unfavorinting: $fe');
      return false;
    } catch (e) {
      log('something got wrong while unfavorinting: $e');
      rethrow;
    }
  }

  Future<List<RampModel>> getUserFavorites() async {
    try {
      _db
          .collection(usersColletionName)
          .where('email',
              isEqualTo: user.currentUser!.email)
          .get()
          .then((value) {
        for (var doc in value.docs) {
          for (var i = 0;
              i < doc.data()['favs'].length;
              i++) {
            // userFavs.add(
            //   RampModel(
            //     doc.get('favs')[i]['title'],
            //     doc.get('favs')[i]['description'],
            //     0,
            //     0,
            //     doc.get('favs')[i]['steps'],
            //     doc.get('favs')[i]['igredients'],
            //     doc.get('favs')[i]['difficulty'],
            //     false,
            //     doc.id,
            //   ),
            // );
          }
        }
      });
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<RampModel>> performSimpleQuery(
      String searchQuery) async {
    String keyword = searchQuery.toLowerCase();
    List<RampModel> foundRecipes = [];
    final recipesRef =
        _db.collection(recipesCollectionName);
    final result = await recipesRef
        .orderBy('title')
        .startAt([keyword]).endAt(['$keyword\uf8ff']).get();
    // if (result.docs.isNotEmpty) {
    //   for (var doc in result.docs) {
    //     foundRecipes.add(RampModel.fromJson(data: doc));
    //   }
    // } else {}

    return foundRecipes;
  }

  Future rateRecipe(
      String docId, int rating, int timesMade) async {
    _db
        .collection(recipesCollectionName)
        .doc(docId)
        .update(
            {'rating': rating, 'timesMade': timesMade + 1})
        .then((value) => log('Successfuly rated'))
        .catchError((error) {
          throw Exception('error: $error');
        });
  }
}
