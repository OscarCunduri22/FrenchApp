import 'package:flutter/material.dart';
import 'package:frenc_app/widgets/game_card.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromRGBO(44, 54, 116, 1),
        child: ListView(
          padding: EdgeInsets.zero,
          children: const <Widget>[
            // Add your drawer items here
          ],
        ),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background Image
            Image.asset(
              'assets/images/static_main_menu.png',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            // Cards
            GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              children: [
                const GameCard(
                  frName: 'Nom en Français',
                  esName: 'Nombre en Español',
                  imagePath: 'assets/images/default.png',
                ),
                const GameCard(
                  frName: 'Nombres',
                  esName: 'Numeros',
                  imagePath: 'assets/images/menu_numeros.png',
                ),
                const GameCard(
                  frName: 'Nom en Français',
                  esName: 'Nombre en Español',
                  imagePath: 'assets/images/default.png',
                ),
              ].map((gameCard) {
                return Center(
                  child: gameCard,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
