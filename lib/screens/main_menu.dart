import 'package:flutter/material.dart';
import 'package:frenc_app/screens/family/family_screen.dart';
import 'package:frenc_app/screens/vocals/linking_vocals_game_screen.dart';
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
          children: const <Widget>[],
        ),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LinkingVocalsGame(),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FractionallySizedBox(
                      widthFactor: 0.8, // Porcentaje del ancho disponible
                      child: GameCard(
                        frName: 'Nom en Français',
                        esName: 'Nombre en Español',
                        imagePath: 'assets/images/default.png',
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    /*Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NumbersScreen(), // Aquí reemplaza OtherScreen() con la pantalla a la que deseas navegar
          ),
        );*/
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FractionallySizedBox(
                      widthFactor: 0.8, // Porcentaje del ancho disponible
                      child: GameCard(
                        frName: 'Nombres',
                        esName: 'Numeros',
                        imagePath: 'assets/images/menu_numeros.png',
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const FamilyGame(), // Aquí reemplaza OtherScreen() con la pantalla a la que deseas navegar
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FractionallySizedBox(
                      widthFactor: 0.8, // Porcentaje del ancho disponible
                      child: GameCard(
                        frName: 'Nom en Français',
                        esName: 'Nombre en Español',
                        imagePath: 'assets/images/default.png',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
