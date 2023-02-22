import 'package:flutter/material.dart';

@immutable
abstract class CreateScreenState{
  const CreateScreenState();
}

class InitialCreateScreenState extends CreateScreenState{

  const InitialCreateScreenState();
}

class LoadingCreateScreenState extends CreateScreenState{}

class OnErrorCreateScreenState extends CreateScreenState{
  final String msg;

  OnErrorCreateScreenState(this.msg);

}

class CloseCreateScreenState extends CreateScreenState{}