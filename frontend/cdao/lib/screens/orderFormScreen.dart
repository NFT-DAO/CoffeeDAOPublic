import 'package:cdao/helpers/orderMaker.dart';
import 'package:cdao/providers/firestoreProvider.dart';
import 'package:cdao/widgets/common/contact/contactDialog.dart';
import 'package:cdao/widgets/common/web_drawer.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/mintResponseModel.dart';
import '../providers/firebaseRTDBProvider.dart';
import '../models/nftDbModel.dart';
import '../routes/route_const.dart';
import '../widgets/orderForm/addressController.dart';
import '../widgets/orderForm/cityTextForm.dart';
import '../widgets/orderForm/emailTextForm.dart';
import '../widgets/orderForm/formError.dart';
import '../widgets/orderForm/nameTextForm.dart';
import '../widgets/orderForm/phoneTextForm.dart';
import '../widgets/orderForm/stateTextForm.dart';
import '../widgets/orderForm/street1TextForm.dart';
import '../widgets/orderForm/street2TextForm.dart';
import '../widgets/orderForm/walletSelector.dart';
import '../widgets/orderForm/zipTextForm.dart';
import '../widgets/common/title.dart';

class OrderFormScreen extends StatefulWidget {
  final String id;
  final String prem;
  const OrderFormScreen({
      required this.id,
      required this.prem,
      super.key
    });

  @override
  State<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController email1 = TextEditingController();
  TextEditingController email2 = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();
  TextEditingController street1 = TextEditingController();
  TextEditingController street2 = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController zip = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController wallet = TextEditingController();
  String? _err;
  // String? wallet;
  bool _isSubmitting = false;
  final _formKey = GlobalKey<FormState>();
  late DB _db;
  late FirestoreService _firestore;
  bool loaded = false;
  bool available = false;
  NftDBModel? nft;
  bool addressShow = false;
  String? local;
  late String arweaveId;
  late bool premium;

  Future<void> getNft() async {
    _firestore = Provider.of<FirestoreService>(context, listen: false);
    _db = Provider.of<DB>(context, listen: false);
    nft = await _db.getOneNft(premium, widget.id);
    available = nft!.available as bool;
    arweaveId = nft!.arweaveId as String;
    if (available) {
      await _db.updateNft(premium, widget.id, false, 'hold');
    }
    loaded = true;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // state.text = 'AA';
    wallet.text = 'NAMI';
    if (widget.prem == 'true') {
      premium = true;
    } else {
      premium = false;
    }
    getNft();
  }

  @override
  Widget build(BuildContext context) {
    String phone = '';
    String nameError = '';
    String streetError = '';
    String stateError = '';
    String cityError = '';
    String zipError = '';
    String emailError = '';
    String walletError = '';

    Future<Map<String, String>> submitOrderForm(ctx) async {
      _err = '';
      setState(() {});
      OrderMaker oh = OrderMaker(
          premium,
          widget.id,
          arweaveId,
          wallet.text,
          name.text,
          street1.text,
          street2.text,
          city.text,
          state.text,
          zip.text,
          phone,
          email1.text,
          _firestore,
          _db);
      Map<String, String> resp = await oh.placeOrder();
      if (resp['error'] != null) {
        debugPrint(
            '9999999999999999 order screen order Error ${resp['error']}');
        _err = resp['error'];
      }
      _isSubmitting = false;
      setState(() {});
      return resp;
    }

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
            child: TitleWidget(),
          ),
          centerTitle: true,
        ),
        drawer: const WebDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              color: Colors.blueGrey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Your NFT',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(235, 165, 65, 1.0),
                          fontSize: 40),
                    ),
                    const Text(
                      '''The original that you will receive will not have the NFTDAO watermark.''',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    !loaded
                        ? const Center(child: CircularProgressIndicator())
                        : available
                            ? Image.network(nft!.wmImageUrl as String)
                            : const Text(
                                '''Sorry, looks like someone beat you to this NFT. Please select another one.''',
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(color: Colors.red, fontSize: 25),
                              ),
                    !available
                        ? const SizedBox(
                            height: 0,
                          )
                        : Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              if (_err != null)
                                Text(
                                  _err!,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 40),
                                ),
                              Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 20),
                                      const Text(
                                        '''We need a little information for shipping.
Continental USA Only''',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 30),
                                      ),
                                      NameTextForm(
                                          isSubmitting: _isSubmitting,
                                          name: name,
                                          nameError: nameError),
                                      FormError(error: nameError),
                                      const SizedBox(height: 12),
                                      EmailTextForm(
                                        email1: email1,
                                        email2: email2,
                                        emailError: emailError,
                                        isSubmitting: _isSubmitting,
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        '''Type your address and select the correct suggested address. If you don't see your address you can type it in below.''',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 30),
                                      ),
                                      const SizedBox(height: 30),
                                      AddressController(
                                        addressShow: addressShow,
                                        addresscontroller: addresscontroller,
                                        city: city,
                                        isSubmitting: _isSubmitting,
                                        state: state,
                                        street1: street1,
                                        zip: zip,
                                      ),
                                      const SizedBox(height: 12),
                                      //street1
                                      Street1TextForm(
                                          isSubmitting: _isSubmitting,
                                          street1: street1,
                                          streetError: streetError),
                                      FormError(error: streetError),
                                      const SizedBox(height: 12),
                                      //street2
                                      Street2TextForm(street2: street2),
                                      const SizedBox(height: 12),
                                      //city
                                      CityTextForm(
                                        city: city,
                                        cityError: cityError,
                                        isSubmitting: _isSubmitting,
                                      ),
                                      FormError(error: cityError),
                                      const SizedBox(height: 12),
                                      //state
                                      SizedBox(
                                        width: 50,
                                        child: StateTextForm(
                                            isSubmitting: _isSubmitting,
                                            stateError: stateError,
                                            state: state),
                                      ),
                                      const SizedBox(height: 12),
                                      FormError(error: stateError),
                                      //Zip
                                      ZipTextForm(
                                        isSubmitting: _isSubmitting,
                                        zip: zip,
                                        zipError: zipError,
                                      ),
                                      const SizedBox(height: 12),
                                      FormError(error: zipError),
                                      const SizedBox(height: 12),
                                      PhoneTextForm(phone: phone),
                                      const SizedBox(height: 12),
                                      WalletSelector(
                                        isSubmitting: _isSubmitting,
                                        wallet: wallet,
                                        walletError: walletError,
                                      ),
                                      const SizedBox(height: 12),
                                      FormError(error: walletError),
                                      const SizedBox(height: 12),
                                      _isSubmitting // TODO
                                          ? const CircularProgressIndicator()
                                          : ElevatedButton(
                                              onPressed: () async {
                                                _formKey.currentState!.save();
                                                final isValid = _formKey
                                                    .currentState!
                                                    .validate();
                                                if (isValid) {
                                                  _isSubmitting = true;
                                                  _err = null;
                                                  setState(() {});
                                                  await submitOrderForm(context)
                                                      .then((value) {
                                                    MintResponseModel mr =
                                                        MintResponseModel
                                                            .fromMap(value);
                                                    if (mr.error == null) {
                                                      String x =
                                                          '''{"hash": "${value['hash']}", "nftUrl": "${value['nftUrl']}"}''';
                                                      context.goNamed(
                                                          CDAOConstants
                                                              .receiptRoute,
                                                          pathParameters: {
                                                            "data": x
                                                          });
                                                    } else {
                                                      _isSubmitting = false;
                                                      setState(() {});
                                                    }
                                                  });
                                                } else {
                                                  _isSubmitting = false;
                                                  setState(() {});
                                                }
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Submit',
                                                  style:
                                                      TextStyle(fontSize: 30),
                                                ),
                                              ),
                                            ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  )),
                              const SizedBox(height: 20),
                              const Text(
                                  '''All personal information is only used for shipping and deleted 30 days after your order has shipped.''',
                                  textAlign: TextAlign.center)
                            ],
                          ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Text(
                      '''Having Troubles or Questions? Contact us at contact@coffeedao.me or via the contact form.''',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    IconButton(
                      alignment: Alignment.bottomCenter,
                      iconSize: 40,
                      color: const Color.fromRGBO(156, 112, 53, 1.0),
                      icon: const Icon(Icons.contact_mail_rounded),
                      onPressed: () {
                        showDialog(
                            barrierColor: Colors.blueGrey,
                            builder: (BuildContext context) {
                              return const ContactDialog();
                            },
                            context: context);
                      },
                    ),
                    const Text('Copyright © NFTDAO 2023')
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
