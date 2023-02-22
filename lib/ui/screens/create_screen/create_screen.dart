import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/create_task/create_task_bloc.dart';
import '../../../bloc/create_task/create_task_event.dart';
import '../../../helpers/create_screen_type.dart';
import '../../views/task/create_task/create_task.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({Key? key}) : super(key: key);

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  late BlocProvider bloc;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<CreateTaskBloc>(create: (BuildContext context) => CreateTaskBloc()..add(CreateInitEvent()),),
    ],
        child: SafeArea(child:  CreatetaskView()));
  }



}
