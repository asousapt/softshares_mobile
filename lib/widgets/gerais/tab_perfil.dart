import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: SingleChildScrollView(
        child: TabPerfil(),
      ),
    );
  }
}

class TabPerfil extends StatefulWidget {
  const TabPerfil({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TabPerfilState();
  }
}

class _TabPerfilState extends State<TabPerfil> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          isScrollable: false,
          controller: _tabController,
          tabs: [
            Tab(
              icon: FaIcon(FontAwesomeIcons.user),
              text: "Informações Pessoais",
            ),
            Tab(
              icon: FaIcon(FontAwesomeIcons.heart),
              text: "Áreas Favoritas",
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height -
              kToolbarHeight -
              kBottomNavigationBarHeight -
              100,
          child: TabBarView(
            controller: _tabController,
            children: [
              // Add your content for tab 1 (Personal Information)
              Center(
                child: Text("Personal Information"),
              ),
              // Add your content for tab 2 (Favorite Areas)
              Center(
                child: Text("Favorite Areas"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
