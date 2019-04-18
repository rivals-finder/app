import 'package:flutter/material.dart';
import './app_route.dart';
import './bloc/bloc.dart';

void main() => runApp(RivalsFinder());

class RivalsFinder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProvidersWrapper(child: AppRoute());
  }
}
