import 'package:musicBuddies/Pages/spotifire.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:spotify_auth_player/spotify_auth_player.dart';

Future<void> trySpotifire(spotifyUrl) async {
  await Spotifire.init(clientid: "Your client id");
  await Spotifire.connectRemote.then(print);
  await Spotifire.playPlaylist(playlistUri: Spotifire.getSpotifyUri(spotifyUrl));
}

class Scan extends StatefulWidget {
  const Scan({Key? key}) : super(key: key);

  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? barcode;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {

    controller?.dispose();
    super.dispose();
  }


  // @override
  // void reassemble() async{
  //   super.reassemble();
  //   if(Platform.isAndroid){
  //     await controller!.pauseCamera();
  //   }
  //   controller!.resumeCamera();
  // }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          buildQrView(context),
          Positioned(top: 10, child: buildControlButtons()),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SpotifirePage(barcode: barcode)),
              );
              // Navigate back to first route when tapped.
            }, child: Text(barcode != null ? 'Play!' : 'Scan a code!', maxLines: 3),
          )
        ],
      )
    ),
  );

  Widget buildControlButtons() => Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white24,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: FutureBuilder<bool?>(
                future: controller?.getFlashStatus(),
                builder: (context, snapshot){
                  if(snapshot.data != null){
                    return Icon(
                      snapshot.data! ? Icons.flash_on : Icons.flash_off
                    );
                  }else{
                    return Container();
                  }
                },
            ),
            onPressed: () async {
              await controller?.toggleFlash();
              setState(() {});
            },
          ),
          IconButton(
            icon: FutureBuilder(
              future: controller?.getCameraInfo(),
              builder: (context, snapshot){
                if(snapshot.data != null){
                  return Icon(Icons.switch_camera);
                }else{
                  return Container();
                }
              },
            ),
            onPressed: () async {
              await controller?.flipCamera();
              setState(() {});
            },
          ),
      ],
    ),
  );

  Widget buildResult() => Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white24,
      ),
      child: Text(
        barcode != null ? 'Result : ${barcode!.code}' : 'Scan a code!',
        maxLines: 3,
      )
  );

  Widget buildQrView(BuildContext context) => QRView(
      key: qrKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderWidth: 10,
        borderLength: 20,
        borderRadius: 10,
        borderColor: Theme.of(context).accentColor,
        cutOutSize: MediaQuery.of(context).size.width * 0.8,
      ),
    );

  void onQRViewCreated(QRViewController controller){
    setState(() => this.controller = controller);
    controller.scannedDataStream.listen((barcode) => setState(() => this.barcode = barcode));
  }

}

