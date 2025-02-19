import 'package:flutter/material.dart';

import 'collections/collections_page.dart';
import 'tasks/tasks_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PageController pageController;

  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  void nextPage(int page) {
    setState(() {
      currentPage = page;
    });
    pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            title: Text('Modular App'),
            centerTitle: true,
          ),
          SliverPersistentHeader(
            floating: false,
            pinned: true,
            delegate: _SliverAppBarDelegate(
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ListenableBuilder(
                    listenable: pageController,
                    builder: (context, _) {
                      final pageNormalize = (pageController.positions.isNotEmpty
                              ? pageController.page
                              : 0.0) ??
                          0.0;

                      return TabBar(
                        controller: TabController(
                          length: 2,
                          vsync: Scaffold.of(context),
                          initialIndex: pageNormalize.round(),
                        ),
                        onTap: nextPage,
                        tabs: [
                          Tab(child: Text('Tasks')),
                          Tab(child: Text('Collections')),
                        ],
                      );
                    }),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            child: PageView(
              controller: pageController,
              children: [
                TasksPage(),
                CollectionsPage(),
              ],
            ),
          ),
        ],
      )),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => 50;

  @override
  double get maxExtent => 80;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: _tabBar,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
