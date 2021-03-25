import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class CustomPdfViewer extends StatefulWidget {
  final Size size;

  const CustomPdfViewer({Key key, this.size}) : super(key: key);
  @override
  _CustomPdfViewerState createState() => _CustomPdfViewerState();
}

class _CustomPdfViewerState extends State<CustomPdfViewer> {
  PdfController _pdfController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pdfController = PdfController(document: PdfDocument.openAsset("asset/privacy_policy.pdf"));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 0.0,
      backgroundColor: Colors.black.withOpacity(0.75),
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
      width: widget.size.width * 0.9,
      height: widget.size.height * 0.75,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                width: widget.size.width * 0.85,
                height: widget.size.height * 0.7,
                child: PdfView(controller: _pdfController,),
              ),
            ),
          ),
          Positioned(
            right: 0.0,
            child: GestureDetector(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 14.0,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.close, color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pdfController.dispose();
    super.dispose();
  }
}
