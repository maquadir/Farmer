import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void storeUserDataInSharedPreferences(
    String name, String suburb, String poCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('user name', name);
  prefs.setString('suburb', suburb);
  prefs.setString('post code', poCode);
}

Future<SharedPreferences> loadUserPrefData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs;
}

clearPrefs() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.clear();
}

Future<void> showAlertDialog(
    String title, String message, BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

String getTodaysDate(){
  return DateFormat('dd-MM-yyyy').format(DateTime.now());
}

String getTodaysTime(){
  return DateFormat('kk:mm:ss').format(DateTime.now());
}


//realtime firebase code
// FirebaseFirestore.instance
//     .collection('sellers')
//     .get()
//     .then((QuerySnapshot querySnapshot) {
//   for (var doc in querySnapshot.docs) {
//     var dishName = doc.id;
//     downloadImageUrl(dishName,data['po code'])
//         .then((imageUrl) => updateList(foodList))
//         .onError((error, stackTrace) => updateList(foodList));
//   }
// });

// loadUserPrefData().then((prefs) => {
//       profile.userName = prefs.getString('user name') ?? "",
//       profile.poCode = prefs.getString('post code') ?? "",
//       profile.suburb = prefs.getString('suburb') ?? "",
//       if (profile.userName.isEmpty)
//         {fetchFromFirebase()}
//       else
//         {fetchItemsFromStream()},
//       updateProfile(profile)
//     });

// fetchFromFirebase() {
//   refProfile = database.ref(user!.uid.toString() + "/seller_profile");
//   //Get the data once
//   getProfile();
// }
//
// getProfile() async {
//   await refProfile.once().then((value) => addToProfile(value));
// }
//
// addToProfile(DatabaseEvent event) {
//   if (event.snapshot.value != null) {
//     profile = Profile(
//         event.snapshot.child("user name").value.toString(),
//         event.snapshot.child("suburb").value.toString(),
//         event.snapshot.child("po code").value.toString());
//     if (profile.userName.isNotEmpty) fetchItemsFromStream();
//   }
// }

// updateProfile(Profile profile) {
//   setState(() => this.profile = profile);
// }

// fetchItemsFromStream() {
//   stream = refDishes.onValue;

// Subscribe to the stream!
// stream.listen((DatabaseEvent event) {
//   foodList.clear();
//   //download dish image
//   for (var i = 0; i <= event.snapshot.children.length; i++) {
//     var item = event.snapshot.children.elementAt(i);
//     downloadImageUrl(item.child("dish name").value.toString())
//         .then((imageUrl) => addToList(item, imageUrl))
//         .onError((error, stackTrace) => addToList(item, ""));
//   }
// });
// }


// CollectionReference dishImages =
// FirebaseFirestore.instance.collection('dishImages');

// DatabaseReference refSellerDish =
// database.ref(user!.uid.toString() + "/dishes/" + dishName);
//
// DatabaseReference refBuyerDish =
// database.ref(profile.poCode + "/" + dishName);

// await refSellerDish.set({
//   "user name": userName,
//   "dish name": dishName,
//   "cuisine": cuisine,
//   "address": address,
//   "post code": postcode,
//   "price": price,
//   "food type": foodType,
//   "uid": user?.uid.toString(),
// });
//
// await refBuyerDish.set({
//   "user name": userName,
//   "dish name": dishName,
//   "cuisine": cuisine,
//   "address": address,
//   "post code": postcode,
//   "price": price,
//   "food type": foodType,
//   "uid": user?.uid.toString(),
// });

// void fetchFromFirebase() {
//   //Get the data once
//   getValue();
// }
//
// getValue() async {
//   // await refProfile.once().then((value) => addToProfile(value));
// }
//
// addToProfile(DatabaseEvent event) {
//   if (event.snapshot.value != null) {
//     Profile profile = Profile(
//         event.snapshot.child("user name").value.toString(),
//         event.snapshot.child("suburb").value.toString(),
//         event.snapshot.child("po code").value.toString());
//     storeUserDataInSharedPreferences(
//         profile.userName, profile.suburb, profile.poCode);
//     updateProfile(profile);
//   }
// }

// updateProfile(Profile profile) {
//   setState(() => this.profile = profile);
// }