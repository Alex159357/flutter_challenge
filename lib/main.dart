import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/ui/screens/main_screen/main_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'bloc/history/history_bloc.dart';
import 'bloc/main_navigation/main_navigation_cubit.dart';
import 'bloc/task_bloc/task_bloc.dart';
late Database database;

void main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  database = await _getMainDb();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MainNavigationCubit>(
          create: (BuildContext context) => MainNavigationCubit(),
        ),
        BlocProvider<TaskBloc>(
          create: (BuildContext context) => TaskBloc(),
        ),
        BlocProvider<HistoryBloc>(
          create: (BuildContext context) => HistoryBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
            bottomAppBarTheme: const BottomAppBarTheme(color: Colors.transparent)
        ),
        home: const MainScreen(),
      ),
    );
  }
}

Future<Database> _getMainDb() async {
  var dir = await getApplicationDocumentsDirectory();
  await dir.create(recursive: true);
  var dbPath = join(dir.path, 'test_app.db');
  FlutterNativeSplash.remove();
  return await databaseFactoryIo.openDatabase(dbPath, version: 1);
}
