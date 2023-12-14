import 'package:carousel_slider/carousel_slider.dart';
import 'package:cdao/providers/storageProvider.dart';
import 'package:cdao/widgets/common/contact/contactDialogForm.dart';
import 'package:cdao/widgets/common/title.dart';
import 'package:cdao/widgets/common/web_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../routes/route_const.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StorageService storage;
  List<Widget> imageSliders = [];
  bool loaded = false;
  String? pageToken;
  @override
  void initState() {
    super.initState();
    setup();
  }

  Future<void> setup() async {
    storage = Provider.of<StorageService>(context, listen: false);
    Map<String, dynamic> imgList =
        await storage.getNFTDownloadURLs(10, null, 'nfts');
    pageToken = imgList['pageToken'];
    for (String x in imgList['urls']) {
      imageSliders.add(Image.network(
        x,
      ));
    }
    loaded = true;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var logoImage = Image.asset('lib/assets/images/logo.png');
    var nftImage = Image.asset('lib/assets/images/7.jpg');
    var crewImage = Image.asset(
      'lib/assets/images/crew.png',
      fit: BoxFit.fill,
    );
    var bagImage = Image.asset('lib/assets/images/bagNcup.png');
    var p1Image = Image.asset('lib/assets/images/p1.png');
    var p2Image = Image.asset('lib/assets/images/p2.png');

    const Gradient gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromRGBO(209, 255, 230, 1.0),
          Color.fromRGBO(235, 165, 65, 1.0)
        ]);
    const Gradient gradient2 = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromRGBO(77, 58, 39, 1.0),
          Color.fromRGBO(36, 32, 32, 1.0),
        ]);
    double largeTextSize = width > 650 ? 50 : 30;
    double smallTextSize = width > 650 ? 25 : 15;

    var scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          shadowColor: Theme.of(context).scaffoldBackgroundColor,
          toolbarHeight: 100,
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
            child: IconButton(
              onPressed: () {
                scaffoldKey.currentState?.openDrawer();
              },
              icon: const Icon(Icons.menu),
              color: const Color.fromRGBO(235, 165, 65, 1.0),
              iconSize: 30,
            ),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: const Padding(
            padding: EdgeInsets.all(8.0),
            child:  TitleWidget(),
          ),
          centerTitle: true,
        ),
        drawer: const WebDrawer(),
        body: Center(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'From Farm To Connoisseur',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: largeTextSize,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(100, 0, 60, 0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'CoffeeDAO ',
                    style: TextStyle(
                        fontSize: largeTextSize,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromRGBO(235, 165, 65, 1.0)),
                    children: <TextSpan>[
                      TextSpan(
                          text:
                              '''is an initiative to attach an NFT with each coffee bag sold on our platform. This provides consumers with the origin of the coffee, its characteristics, and the growers' artistic process used in the production.''',
                          style: TextStyle(
                              fontSize: smallTextSize,
                              fontWeight: FontWeight.normal,
                              color: Colors.white)),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Stack(
                fit: StackFit.passthrough,
                clipBehavior: Clip.antiAlias,
                children: <Widget>[
                  Column(
                    children: [
                      nftImage,
                      Container(
                        width: width,
                        height: width > 1350 ? width / 3 * 2 : width / 2,
                        decoration: const BoxDecoration(
                          gradient: gradient,
                        ),
                      ),
                    ],
                  ),
                  // bagImage
                  Positioned(
                      top:  width > 1130 && width <= 1200
                      ? width / 4 * 3 
                      : width > 1200 
                      ? width / 3*2 
                      : width /5*4,
                      left: 5,
                      child: SizedBox(width: width, child: bagImage)),
                  Positioned(left: 20, top: width / 3, child: p1Image),
                  Positioned(left: width / 5 * 3, top: width, child: p2Image),
                  // // Notify Me button
                //   Positioned(
                //       //TODO
                //       left: width / 18 * 6,
                //       top:  width > 1130 && width <= 1200
                //       ? (width / 4 * 3) + 100
                //       : width > 1200 
                //       ? width / 3*2 + 100
                //       : width /5*4 + 100,
                //       child: ElevatedButton(
                //         child: Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Text(
                //             'Buy Now!', //TODO
                //             style: TextStyle(fontSize: largeTextSize),
                //           ),
                //         ),
                // onPressed: () => context.goNamed(CDAOConstants.premiumNftRoute),
                //       )),
                ], //<Widget>[]
              ),
              SizedBox(width: width, child: crewImage),
              Container(
                margin: EdgeInsets.zero,
                decoration: const BoxDecoration(gradient: gradient2),
                child: Stack(
                    fit: StackFit.loose,
                    clipBehavior: Clip.antiAlias,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(100, 50, 100, 50),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'CoffeeDAO ',
                            style: TextStyle(
                              fontSize: largeTextSize,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromRGBO(235, 165, 65, 1.0),
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      '''is an initiative to attach an NFT with each coffee bag sold on our platform. This provides customers with the origin of the coffee, characteristics of the coffee, and the artistic process used in the production by the grower. For producers it creates a record of the consistent quality of their product and a direct link with the coffee drinkers that buy their coffee.

This is a single origin coffee, cultivated 5,249 feet above sea level in the mountains of Concepcion de Los Hornos, Comayagua, Honduras by the artisan Mr. Melvin Humberto Baquis at the Finca "La Casona" and "El Ocotialto". With special care in preparing the land and preserving the environment, using compost from anaerobic bio digesters and formula for fertilization. The cultivated coffee tree species are from the Timor and Villa Sarchi families, specifically Parainema as well as PACA and H-90 species. In the same way, the flowers of the surrounding plants such as citrus and cherry fruits, are used to flavor the coffee's unique aroma during the bee pollination process.

After individually harvesting the coffee cherries, a manual screening is carried out eliminating natural defects. The pulp is removed and washed in an ordinary case and then dried at outdoor temperature until reaching an optimal humidity of 11% per batch. Subsequently, the parchment, a natural membrane that covers the bean, is removed and ready for a medium roast. It's important to carefully control the roasting mechanisms maintaining the balance of time by volume of each batch and air to be in ratio, ending with a rapid cooling process to preserve the aromas.

This coffee's profile aroma is at 85%, a creamy texture with dark sweet chocolate fragrances and mandarin and orange citrus tones. The ways to enjoy your coffee beans varies and it's recommended to keep your samples at a cold temperature and grind it in a suitable mill just before making the infusion.''',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: smallTextSize,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                      ),
                    ]),
              ),
              ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('''Buy Now!''',
                            style: TextStyle(
                                fontSize: largeTextSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                  // RichText(
                  //   textAlign: TextAlign.center,
                  //   text: TextSpan(
                  //     text: 'NFT',
                  //     style: TextStyle(
                  //         fontSize: smallTextSize,
                  //         fontWeight: FontWeight.bold,
                  //         color: const Color.fromRGBO(235, 165, 65, 1.0)),
                  //     children: <TextSpan>[
                  //       TextSpan(
                  //           text: '''Buy Now!''',
                  //           style: TextStyle(
                  //               fontSize: smallTextSize,
                  //               fontWeight: FontWeight.normal,
                  //               color: Colors.white)),
                  //     ],
                  //   ),
                  // ),
                ),
                onPressed: () => context.goNamed(CDAOConstants.premiumNftRoute),////livePremiumNftRoute
              ),
              const SizedBox(
                height: 25,
              ),
              InkWell(
                  onTap: () => context.goNamed(CDAOConstants.premiumNftRoute),///livePremiumNftRoute
                  child: loaded
        ? CarouselSlider(
            items: imageSliders,
            options: CarouselOptions(autoPlay: true),
          )
        : const CircularProgressIndicator()),
              const SizedBox(
                height: 25,
              ),
              Container(
                color: const Color.fromRGBO(36, 32, 32, 1.0),
                child: Stack(
                    alignment: AlignmentDirectional.topCenter,
                    fit: StackFit.loose,
                    clipBehavior: Clip.antiAlias,
                    children: <Widget>[
                      RotatedBox(quarterTurns: 1, child: p2Image),
                      //purchase details
                      Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Text(
                            '''BUY ONE HALF POUND OF PREMIUM HONDURAN COFFEE & GET A CARDANO ORIGIN CERTIFICATE NFT''',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: largeTextSize)),
                      ),
                    ]),
              ),
              SizedBox(width: width / 4, child: logoImage),
              const SizedBox(
                height: 12,
              ),
              Text(
                '''Questions & Comments''',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: smallTextSize,
                ),
              ),
              const ContactForm(),
//               Padding(
//                 padding: const EdgeInsets.all(18.0),
//                 child: RichText(
//                   textAlign: TextAlign.center,
//                   text: TextSpan(
//                     text: 'LEGAL Disclaimer: ',
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                         fontSize: 10),
//                     children: <TextSpan>[
//                       TextSpan(
//                           text:
//                               '''If you choose to provide us with your email address, we will use it only to send updates on the CoffeeDAO NFT project. To unsubscribe write to contact@coffeedao.me
// Copyright© NFTDAO 2023''',
//                           style: TextStyle(
//                               color: Colors.grey.shade400, fontSize: 10)),
//                     ],
//                   ),
//                 ),
//               ),
            ],
          ),
        )));
  }
}
