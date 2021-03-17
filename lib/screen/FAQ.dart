import 'package:flutter/material.dart';
import 'package:fortuna/common/data.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:fortuna/common/prefs.dart';

class FAQ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(size.width, size.height * 0.08),
        child: AppBar(
          title: Text(
            'Preguntas Frecuentes',
          ),
          backgroundColor: Prefs().color,
          elevation: 0,
        ),
      ),
      body: Column(
        children: [
          Container(
            height: size.height * 0.92,
            color: Prefs().color,
            child: ListView.builder(
                itemCount: chat_qa.length,
                itemBuilder: (context, index) {
                  String question = chat_qa.keys.elementAt(index);
                  return Padding(
                    padding: EdgeInsets.only(
                        left: index % 2 == 1 ? 12.0 : size.width * 0.15, right: index % 2 == 0 ? 12.0 : size.width * 0.15, top: 8, bottom: 8),
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 18.0, right: 18, top: 12, bottom: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                            bottomLeft:
                                index % 2 == 0 ? Radius.circular(30.0) : Radius.circular(0.0),
                            bottomRight: index % 2 == 1 ? Radius.circular(30.0) : Radius.circular(0.0)),
                        color: index % 2 == 1 ? Colors.white : Colors.black,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$question',
                            style: TextStyle(
                                color: Color(0xffC19305),
                                wordSpacing: 2,
                                fontSize: 18),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 16),
                            child: DottedLine(
                              direction: Axis.horizontal,
                              lineLength: double.infinity,
                              lineThickness: 3.0,
                              dashLength: 4.0,
                              dashColor: Color(0xffC19305),
                              dashRadius: 0,
                              dashGapLength: 4.0,
                              dashGapColor: Colors.transparent,
                              dashGapRadius: 0.0,
                            ),
                          ),
                          Text(
                            '${chat_qa[question] is List ? chat_qa[question][0] : chat_qa[question]}',
                            style: TextStyle(wordSpacing: 2, fontSize: 16, color: index % 2 == 0 ? Colors.white : Colors.black),
                          ),

                          index == 7
                              ? Tile('${chat_qa[question][1]}')
                              : Container(),
                          index == 7
                              ? Tile('${chat_qa[question][2]}')
                              : Container(),
                          index == 7
                              ? Tile('${chat_qa[question][3]}')
                              : Container(),
                          index == 7
                              ? Tile('${chat_qa[question][4]}')
                              : Container(),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget Tile(String message) {
    return ListTile(
      leading: Icon(
        Icons.check_circle_sharp,
        color: Color(0xffC19305),
      ),
      title: Text('$message'),
    );
  }
}
