import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:itemtracker/models/item_model.dart';
import 'package:itemtracker/providers/item_provider.dart';
import 'package:itemtracker/screens/Item_List.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:device_preview/device_preview.dart';
import 'package:itemtracker/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  Hive.registerAdapter(ItemModelAdapter());
  await Hive.openBox<ItemModel>('itembox');

  runApp(ScreenUtilInit(
      splitScreenMode: true, minTextAdapt: true, child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.

  final ThemeData lighttheme = ThemeData(
      primaryColor: Colors.white,
      brightness: Brightness.light,
      primaryColorDark: Colors.black,
      canvasColor: Colors.white,
      primarySwatch: Colors.deepPurple,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20)),
      cardTheme: const CardTheme(
          color: Color.fromARGB(255, 205, 192, 240),
          shape: RoundedRectangleBorder()),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromARGB(255, 183, 161, 243),
          splashColor: Color.fromARGB(255, 232, 107, 98)),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 196, 186, 186),
              shape: const RoundedRectangleBorder())));

  final ThemeData darktheme = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20)),
      cardTheme:
          const CardTheme(color: Colors.grey, shape: RoundedRectangleBorder()),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.grey, splashColor: Colors.black),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.black,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[999],
              shape: const RoundedRectangleBorder())));
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ItemProvider()),
      ],
      child: Consumer<ItemProvider>(
        builder: (context, itemprovider, child) {
          return MaterialApp(
            title: 'Item tracker',
            theme: lighttheme,
            darkTheme: darktheme,
            themeMode: itemprovider.thememode,
            home: const ItemList(),
          );
        },
      ),
    );
  }
}
