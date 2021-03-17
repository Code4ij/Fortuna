import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fortuna/atm_game/atm.dart';
import 'package:fortuna/basket_game/main_screen..dart';
import 'package:fortuna/car_game/car_game.dart';
import 'package:fortuna/common/data.dart';
import 'package:fortuna/farmer_game/main_screen.dart';
import 'package:fortuna/health_eco/health_option.dart';
import 'package:fortuna/module1_game/Module1.dart';
import 'package:fortuna/module4_game/Module4.dart';
import 'package:fortuna/module6_game/Module6.dart';
import 'package:fortuna/qa_game/QAGame.dart';
import 'package:fortuna/skillz_game/main_screeen.dart';
import 'package:fortuna/split_and_card_game/game_page.dart';
import 'package:fortuna/templates/game_template.dart';

class ModuleController extends StatelessWidget {
  final int index;

  static ModuleController of(BuildContext context) => context.findAncestorWidgetOfExactType<ModuleController>();

  const ModuleController({Key key, this.index}) : super(key: key);

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    switch (index) {
      case 0:
        return GameTemplate(
          index: index,
          color: data[index]["color"],
          icon: "asset/Module1/pigcolorless.png",
          image: "asset/image/module1_background.png",
          name: data[index]["name"],
          title: "AHORRO",
          data:
          "Muy bien has aprendido ahorrar, ahora puede empezar hacerlo más seguido guardando bien una porción de tu dinero para invertirlo en un buen recurso o una verdadera necesidad",
          discription: data[index]["discription"],
          gamemode: Module1(
              color: data[index]["color"],
              icon: "asset/Module1/pigcolorless.png",
              image: "asset/image/module1_background.png"),
        );
        break;
      case 1:
        return CarGameRunner(index: index,);
        break;
      case 2:
        return GameTemplate(
            index: index,
            color: data[index]["color"],
            icon: "asset/Module3/Icon.png",
            image: "asset/image/module3_background.png",
            name: data[index]["name"],
            title: "CUENTAS",
            data:
            "Muy bien has aprendido a manejar un cajero No dejes de practicar para el día que te toque usar uno",
            discription: data[index]["discription"],
            gamemode: SplitCardGame());
        break;
      case 3:
        return GameTemplate(
          index: index,
          color: data[index]["color"],
          icon: "asset/Module4/heart.png",
          image: "asset/image/module4&6_background.png",
          name: data[index]["name"],
          title: "DEUDAS",
          data: "",
          discription: data[index]["discription"],
          gamemode: Module4(
              color: data[index]["color"],
              icon: "asset/Module4/heart.png",
              image: "asset/image/module4&6_background.png"),
        );
        break;
      case 4:
        return GameTemplate(
          index: index,
          color: data[index]["color"],
          icon: "asset/image/module5_icon.png",
          image: "asset/image/module5_background.png",
          name: data[index]["name"],
          title: "COMUNIDAD",
          data: "El trabajo social comunitario es un proceso que se realiza para el bienestar social. El modo de conseguir este fin, es siempre a través de la utilización, potenciamiento o creación de recursos. La propia comunidad es el principal recurso para tener en cuenta en cualquier intervención comunitaria.",
          discription: data[index]["discription"],
          gamemode: FarmerGameScreen(),
        );
        break;
      case 5:
        return GameTemplate(
            index: index,
            color: data[index]["color"],
            icon: "asset/Module6/module6icon.png",
            image: "asset/image/module4&6_background.png",
            name: data[index]["name"],
            title: "Servicios Financieros",
            data: "",
            discription: data[index]["discription"],
            gamemode: Module6(
                color: data[index]["color"],
                icon: "asset/Module6/module6icon.png",
                image: "asset/image/module4&6_background.png"));
        break;
      case 6:
        return GameTemplate(
          index: index,
          color: data[index]["color"],
          icon: "asset/image/module7_icon.png",
          image: "asset/image/module7_background.png",
          name: data[index]["name"],
          title: "Cajero Automático",
          data: null,
          discription: data[index]["discription"],
          gamemode: Atm(),
        );
        break;
      case 7:
        return GameTemplate(
          index: index,
          color: data[index]["color"],
          image: 'asset/image/module8_background.png',
          discription: data[index]["discription"],
          title: "Presión",
          name: data[index]["name"],
          icon: "asset/image/clock.png",
          gamemode: Builder(
            builder: (context) => PuzzleGame(
              size: MediaQuery.of(context).size,
            ),
          ),
          data: "",
        );
        break;
      case 8:
        return GameTemplate(
          index: index,
          color: data[index]["color"],
          image: 'asset/image/module9_background.png',
          discription: data[index]["discription"],
          title: "Desiciones",
          name: data[index]["name"],
          icon: "asset/image/module${index}_icon.png",
          gamemode: QAGame(
            color: data[index]["color"],
          ),
          data: "",
        );
        break;
      case 9:
        return GameTemplate(
          index: index,
          color: data[index]["color"],
          image: 'asset/image/module10_background.png',
          discription: data[index]["discription"],
          title: "TENTACION",
          name: data[index]["name"],
          icon: "asset/image/cherry.png",
          gamemode: Builder(
            builder: (context) => BasketScreen(
              size: MediaQuery.of(context).size,
            ),
          ),
          data: "",
        );
        break;
      case 10:
        return GameTemplate(
          index: index,
          color: data[index]["color"],
          image: 'asset/image/module10_background.png',
          discription: data[index]["discription"],
          title: "Salud Económica",
          name: data[index]["name"],
          icon: "asset/image/module11_icon.png",
          gamemode: HealthOption(index: index),
          data: "",
        );
        break;
    }
  }
}
