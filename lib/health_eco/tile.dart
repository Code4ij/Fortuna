import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Item {
  Item({
    this.expandedValue,
    this.title,
    this.isExpanded = false,
    this.isChecked,
    this.index,
  });

  String expandedValue;
  String title;
  bool isExpanded;
  int isChecked;
  int index;
}

List<Item> generateItems(Map<int,dynamic> gameData,Map scoreData) {

  return List.generate(gameData.length, (int index) {
    return Item(
        title: gameData[index]["title"],
        expandedValue: gameData[index]["data"],
        index: index,
        isChecked: scoreData[index.toString()]
    );
  });
}

class Tiles extends StatefulWidget {

  final List<Item> data;
  final Map scoreData;
  const Tiles({Key key, this.data, this.scoreData}) : super(key: key);
  @override
  _TilesState createState() => _TilesState();
}

class _TilesState extends State<Tiles> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(size.width * 0.025),
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            widget.data[index].isExpanded = !isExpanded;
          });
        },
        children: widget.data.map<ExpansionPanel>((Item item) {
          return ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                visualDensity: VisualDensity.compact,
                title: AutoSizeText(
                    item.title,
                  style: TextStyle(
                    fontSize: (size.height * 0.02).round().toDouble(),
                  ) ,
                ),
                leading: Checkbox(
                    value: item.isChecked == 0 ? false : true,
                    onChanged: (val){
                  setState(() {
                    if(item.isChecked != 2){
                      if(item.isChecked == 0)
                        widget.data[item.index].isChecked = 1;
                      else
                        widget.data[item.index].isChecked = 0;
                    }
                  });
                }),
              );
            },
            body:Padding(
              padding: EdgeInsets.only(bottom:size.height * 0.01875,left: size.width * 0.075,right: size.width * 0.05),
              child: AutoSizeText(
                  item.expandedValue,
                minFontSize: (size.height * 0.0218).round().toDouble(),
                style: TextStyle(
                  wordSpacing: 2,
                ),
              ),
            ),

            isExpanded: item.isExpanded,
            canTapOnHeader: true
          );
        }).toList(),
      ),
    );
  }
}

