import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:myknott/Config/CustomColors.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  final Map orderInfo;

  const MapScreen({Key key, this.orderInfo}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with AutomaticKeepAliveClientMixin<MapScreen> {
  List<Marker> _markers = <Marker>[];
  final Color blueColor = CustomColor().blueColor;
  Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {}
  }

  @override
  void initState() {
    _markers.add(
      Marker(
          markerId: MarkerId("hello"),
          position: widget.orderInfo['order']['appointment']['latitude'] == null
              ? LatLng(28.7041, 77.1025)
              : LatLng(
                  widget.orderInfo['order']['appointment']['latitude'],
                  widget.orderInfo['order']['appointment']['longitude'],
                )),
    );
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            markers: Set<Marker>.of(_markers),
            initialCameraPosition: CameraPosition(
                target: widget.orderInfo['order']['appointment']['latitude'] ==
                        null
                    ? LatLng(28.7041, 77.1025)
                    : LatLng(
                        widget.orderInfo['order']['appointment']['latitude'],
                        widget.orderInfo['order']['appointment']['longitude'],
                      ),
                zoom: 15),
          ),
          widget.orderInfo.isNotEmpty
              ? SlidingUpPanel(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  parallaxEnabled: true,
                  maxHeight: 340,
                  backdropEnabled: true,
                  minHeight: 120,
                  panel: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () => openMap(
                                        widget.orderInfo['order']['appointment']
                                                ['latitude'] ??
                                            28.7041,
                                        widget.orderInfo['order']['appointment']
                                                ['longitude'] ??
                                            77.1025),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "assets/location.png",
                                          height: 50,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            "View Direction",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xff051c91),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Address",
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.grey.shade700),
                                          ),
                                          SizedBox(
                                            child: Text(
                                              widget.orderInfo['order']
                                                          ['appointment']
                                                      ['place'] ??
                                                  "",
                                              textAlign: TextAlign.start,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey.shade700),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Time: " +
                                                DateFormat("h:mm a").format(
                                                  DateTime.parse(
                                                    widget.orderInfo["order"]
                                                                ["appointment"]
                                                            ["time"] ??
                                                        "",
                                                  ).toLocal(),
                                                ),
                                            style: TextStyle(
                                              fontSize: 16,
                                              // color: Colors.grey.shade700),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/avatar.png",
                                          height: 40,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Signer Details",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Signer Name",
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                              fontSize: 17),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          ": ${widget.orderInfo['order']['appointment']['signerFullName'] ?? ""}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            // fontWeight: FontWeight.w400,
                                            fontSize: 17.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Phone Number",
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                              fontSize: 17),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          ": ${widget.orderInfo['order']['appointment']['signerPhoneNumber'] ?? ""}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            // fontWeight: FontWeight.w400,
                                            fontSize: 17.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    widget.orderInfo['order']['appointment']
                                                ['signerAddress'] !=
                                            null
                                        ? Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Address",
                                                style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.8),
                                                    fontSize: 17),
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              widget.orderInfo['order']
                                                              ['appointment']
                                                          ['signerAddress'] !=
                                                      null
                                                  ? Flexible(
                                                      child: Text(
                                                        "${widget.orderInfo['order']['appointment']['signerAddress'] ?? ""}",
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.8),
                                                            fontSize: 17),
                                                      ),
                                                    )
                                                  : Container(),
                                            ],
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
              : Container()
        ],
      ),
    );
  }
}
