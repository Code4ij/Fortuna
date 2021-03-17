class DataModel {
  String themeColor;
  int activeIndex;
  int updateTime;
  List<dynamic> score;

  DataModel({this.themeColor, this.activeIndex, this.score, this.updateTime});

  DataModel.fromJson(Map<dynamic, dynamic> json)
      : themeColor = json["themeColor"],
        activeIndex = json["activeIndex"],
        score = json["score"],
        updateTime = json["updateTime"];

  Map<String, dynamic> toJson() =>
      {
        "themeColor": themeColor,
        "activeIndex": activeIndex,
        "score": score,
        "updateTime": updateTime
      };
}