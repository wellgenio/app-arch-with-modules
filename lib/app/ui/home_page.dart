import 'package:flutter/material.dart';
import 'package:modular_di_app/app/modules/auth/data/repositories/auth_repository.dart';
import 'package:modular_di_app/app/ui/auth/logout/logout_button.dart';
import 'package:modular_di_app/app/ui/auth/logout/logout_button_view_model.dart';
import 'package:provider/provider.dart';

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
            title: Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 12.0,
                children: [
                  Text('Complex'),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      'TODO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              MenuAnchor(
                style: MenuStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                ),
                menuChildren: [
                  ChangeNotifierProvider(
                    create: (_) => LogoutButtonViewModel(
                      context.read<IAuthRepository>(),
                    ),
                    child: LogoutButton(),
                  ),
                ],
                builder: (context, controller, __) {
                  return IconButton(
                    icon: Icon(Icons.more_vert, color: Colors.black),
                    onPressed: controller.open,
                  );
                },
              ),
            ],
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
