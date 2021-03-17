class FramerImage{
  String image;
  bool isActive;
  FramerImage({this.image,this.isActive = true});
  bool isFour = false;

}
class GameBox extends FramerImage{
  String backgroundiamge ;
  GameBox({this.backgroundiamge,String image}) : super(image: image);
}