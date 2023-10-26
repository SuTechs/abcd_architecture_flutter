import 'package:flutter/material.dart';

import '../widgets/save_page_state.dart';
import 'leaderboard/leaderboard.dart';
import 'learn/learn.dart';
import 'library/library.dart';
import 'play/play.dart';
import 'profile/profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  static final pageController = PageController();

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final pages = [
    const SavePageSate(child: LibraryScreen()),
    const SavePageSate(child: PlayScreen()),
    const SavePageSate(child: LearnScreen()),
    const SavePageSate(child: LeaderboardScreen()),
    const SavePageSate(child: ProfileScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          _BottomNavigationBar(pageController: Home.pageController),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: Home.pageController,
        children: pages,
      ),
    );
  }
}

class _BottomNavigationBar extends StatefulWidget {
  final PageController pageController;

  const _BottomNavigationBar({Key? key, required this.pageController})
      : super(key: key);

  @override
  State<_BottomNavigationBar> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<_BottomNavigationBar> {
  late final destinations = [
    // library
    const NavigationDestination(
      icon: Icon(Icons.library_books_outlined),
      selectedIcon: Icon(Icons.library_books),
      label: 'Library',
    ),

    // play
    const NavigationDestination(
      icon: Icon(Icons.play_arrow_outlined),
      selectedIcon: Icon(Icons.play_arrow),
      label: 'Play',
    ),

    // learn
    const NavigationDestination(
      icon: Icon(Icons.school_outlined),
      selectedIcon: Icon(Icons.school),
      label: 'Learn',
    ),

    // leaderboard
    const NavigationDestination(
      icon: Icon(Icons.leaderboard_outlined),
      selectedIcon: Icon(Icons.leaderboard),
      label: 'Leaderboard',
    ),

    // profile
    const NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  int _localIndexFlag = 0;

  @override
  void initState() {
    super.initState();

    widget.pageController.addListener(() {
      final page = widget.pageController.page;

      // to reduce the number of rebuild
      // this is when the page is changed without tapping on bottom navigation bar
      // for e.g like tapping profile button on appbar
      if (page != null) {
        if (page.toInt() != _localIndexFlag && mounted) {
          _localIndexFlag = page.toInt();
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      // height: kToolbarHeight,
      selectedIndex: widget.pageController.page?.toInt() ?? 0,
      onDestinationSelected: (index) {
        _localIndexFlag = index;
        widget.pageController.jumpToPage(index);

        setState(() {});
      },
      destinations: destinations,
    );
  }
}
