import 'package:fortuna/skillz_game/puzzle5_model.dart';

String selectedTile = "";
int selectedIndex ;
bool selected = true;

List<TileModel> myPairs = new List<TileModel>();
List<bool> clicked = new List<bool>();
int points = 0;

List<bool> getClicked(){
  List<bool> yoClicked = new List<bool>();
  List<TileModel> myairs = new List<TileModel>();
  myairs = getPairs();
  for(int i=0;i<myairs.length;i++){
    yoClicked[i] = false;
  }
  return yoClicked;
}

List<TileModel>  getPairs(){

  List<TileModel> pairs = new List<TileModel>();

  //1
  TileModel tileModel = new TileModel();
  tileModel.setImageAssetPath("asset/image/fox.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);

  //2
  tileModel = new TileModel();
  tileModel.setImageAssetPath("asset/image/hippo.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);

  //3
  tileModel = new TileModel();
  tileModel.setImageAssetPath("asset/image/horse.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);

  //4
  tileModel = new TileModel();
  tileModel.setImageAssetPath("asset/image/monkey.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);

  //5
  tileModel = new TileModel();
  tileModel.setImageAssetPath("asset/image/panda.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);

  //6
  tileModel = new TileModel();
  tileModel.setImageAssetPath("asset/image/parrot.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);

  //7
  tileModel = new TileModel();
  tileModel.setImageAssetPath("asset/image/rabbit.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);

  //8
  tileModel = new TileModel();
  tileModel.setImageAssetPath("asset/image/zoo.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);

  return pairs;
}

List<TileModel>  getQuestionPairs(){

  List<TileModel> pairs = new List<TileModel>();

  //1
  TileModel tileModel = new TileModel();
  tileModel.setImageAssetPath("asset/image/question.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);

  //2
  tileModel = new TileModel();
  tileModel.setImageAssetPath("asset/image/question.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);

  //3
  tileModel = new TileModel();
  tileModel.setImageAssetPath("asset/image/question.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);

  //4
  tileModel = new TileModel();
  tileModel.setImageAssetPath("asset/image/question.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);

  //5
  tileModel = new TileModel();
  tileModel.setImageAssetPath("asset/image/question.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);

  //6
  tileModel = new TileModel();
  tileModel.setImageAssetPath("asset/image/question.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);

  //7
  tileModel = new TileModel();
  tileModel.setImageAssetPath("asset/image/question.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);

  //8
  tileModel = new TileModel();
  tileModel.setImageAssetPath("asset/image/question.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);

  return pairs;
}