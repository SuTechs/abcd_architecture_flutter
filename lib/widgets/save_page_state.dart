import 'package:flutter/material.dart';

class SavePageSate extends StatefulWidget {
  final Widget child;

  const SavePageSate({Key? key, required this.child}) : super(key: key);

  @override
  State<SavePageSate> createState() => _SavePageSateState();
}

class _SavePageSateState extends State<SavePageSate>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
