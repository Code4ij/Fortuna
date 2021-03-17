import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fortuna/services/user_service.dart';
import 'package:url_launcher/url_launcher.dart';

class AdScreen extends StatefulWidget {
  final Size size;

  const AdScreen({Key key, this.size}) : super(key: key);
  @override
  _AdScreenState createState() => _AdScreenState();
}

class _AdScreenState extends State<AdScreen> {
  final DocumentReference _adReference = FirebaseFirestore.instance.collection('ads').doc("ad_count");

  String upperAd = "";
  String upperAdLink = "";
  List<String> adLinks = [];
  List<String> links = [];
  bool isLinksAvailable = false;
  @override
  void initState() {
    // TODO: implement initState
    upperAd = "";
    upperAdLink = "";
    adLinks = [];
    links = [];
    isLinksAvailable = false;
    getAdLinks();
    super.initState();
  }

  Future<void> getAdLinks() async {
    try {
      final data = await _adReference.get().then((value) => value.data());
      upperAd = data["upper_ad"];
      upperAdLink = data["upper_ad_link"];
      for(String link in data["lower_ads"]) {
        adLinks.add(link);
        print("Link : $link");
      }
      for(String link in data["lower_ads_links"]) {
        links.add(link);
        print("Link : $link");
      }
    } catch (e) {
      print(e);
    }
    if(adLinks != null && adLinks.isNotEmpty && upperAd != null && upperAd.length > 0) {
      isLinksAvailable = true;
      print("Got Ads");
      if(mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return isLinksAvailable ? getAdsContainer() : getEmptyContainer();
  }

  Widget AdContainer(String image, Size size, String adUrl) {
    if(image == "null" || image == "error") {
      return Container(
        height: size.height * 0.2,
        width: size.width * 0.9,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          child: Container(
            height: size.height * 0.2,
            width: size.width * 0.9,
            color: Colors.white.withOpacity(0.5),
            child: SpinKitFadingCircle(color: Colors.black, size: 30,)
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: () async {
        if(await canLaunch(adUrl)) {
          await launch(adUrl);
        } else {
          UserService().flutterToast("Sin internet");
        }
      },
      child: Container(
        height: size.height * 0.2,
        width: size.width * 0.9,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          child: Container(
            height: size.height * 0.2,
            width: size.width * 0.9,
//          color: Colors.white.withOpacity(0.5),
            child: CachedNetworkImage(
              imageUrl: image,
              placeholder: (context, url) => SpinKitFadingCircle(color: Colors.black, size: 30,),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }

  Widget getEmptyContainer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
            padding: EdgeInsets.only(
                top: widget.size.height * 0.0406,
                bottom: widget.size.height * 0.025),
            child: AdContainer("null", widget.size, "")),
        Container(
          height: widget.size.height * 0.3,
          child: CarouselSlider(
            options: CarouselOptions(
              viewportFraction: 0.9,
              height: widget.size.height * 0.22,
              autoPlay: true,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
            items: ["null"].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return AdContainer(i, widget.size, "");
                },
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  Widget getAdsContainer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
            padding: EdgeInsets.only(
                top: widget.size.height * 0.0406,
                bottom: widget.size.height * 0.025),
            child: AdContainer("$upperAd", widget.size, "$upperAdLink")),
        Container(
          height: widget.size.height * 0.3,
          child: CarouselSlider(
            options: CarouselOptions(
              viewportFraction: 0.9,
              height: widget.size.height * 0.22,
              autoPlay: true,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
              // autoPlayAnimationDuration: Duration(microseconds: 100),
              // autoPlayInterval: Duration(microseconds: 100)
            ),
            items: adLinks.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  String link = "";
                  try {
                    link = links[adLinks.indexOf(i)];
                  } catch(e) {
                    link = "";
                  }
                  return AdContainer(i, widget.size, link);
                },
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}
