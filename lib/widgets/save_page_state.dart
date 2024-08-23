import 'package:flutter/material.dart';

/// SavePageSate
class SavePageSate extends StatefulWidget {
  final Widget child;

  const SavePageSate({super.key, required this.child});

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
