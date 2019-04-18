import 'package:flutter/material.dart';
import './bloc_firebase.dart';
import './bloc_provider.dart';

class ProvidersWrapper extends StatelessWidget {
  final Widget child;

  ProvidersWrapper({Key key, @required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: FireBloc(),
      child: child,
    );
  }
}
