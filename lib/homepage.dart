// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;
import 'web.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _scrollController;
  late double _scrollPosition;
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final wardController = TextEditingController();
  final addressController = TextEditingController();
  final municipalityAccNoController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final officialNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final keySignaturePad = GlobalKey<SfSignaturePadState>();

  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  _scrollListener() {
    _scrollPosition = _scrollController.position.maxScrollExtent;
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void _openWhatsApp(
      String nameControllerText, String phoneNumberControllerText) async {
    String name = nameControllerText;
    String phoneNumber = phoneNumberControllerText;
    var url =
        'https://wa.me/${phoneNumber}?text=Good%20day%20${name}%20please find your proof of residence attached below';
    await launch(url);
  }

  Future<Uint8List> _readImageData(String name) async {
    final data = await rootBundle.load('images/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Future<void> _createProofOfRes(
      String name,
      String idNumber,
      String ward,
      String address,
      String municipalityAccNo,
      String phoneNumber,
      String official,
      ByteData imageSignature) async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();

    page.graphics.drawString('LOCAL MUNICIPALITY/MASEPALA WA SELEGAE/PLAASLIKE',
        PdfStandardFont(PdfFontFamily.helvetica, 18));

    page.graphics.drawString(
        'MUNISIPALITEIT', PdfStandardFont(PdfFontFamily.helvetica, 18),
        bounds: const Rect.fromLTWH(0, 20, 0, 0));

    page.graphics.drawImage(
        PdfBitmap(await _readImageData('eproof_app_logo_transparent.png')),
        const Rect.fromLTWH(0, 40, 120, 180));

    String companyAddress =
        'MARKET STREET/MMILA WA MARKET/MARKSTRAAT 19A P.O BOX/LEBOKOSE POSE/POSBUS 35 VRYBURG 8600';
    PdfTextElement(
            text: companyAddress,
            font: PdfStandardFont(PdfFontFamily.timesRoman, 18))
        .draw(
            page: page,
            bounds: Rect.fromLTWH(230, 50, page.getClientSize().width / 2,
                page.getClientSize().height / 2));

    page.graphics.drawString(
        'NALEDI', PdfStandardFont(PdfFontFamily.timesRoman, 30),
        bounds: const Rect.fromLTWH(100, 200, 0, 0));

    page.graphics.drawString('TELEPHONE/MOGALA/TELEFOON:',
        PdfStandardFont(PdfFontFamily.timesRoman, 18),
        bounds: const Rect.fromLTWH(230, 180, 0, 0));

    page.graphics.drawString(
        '(053) 928-2199/2200', PdfStandardFont(PdfFontFamily.timesRoman, 18),
        bounds: const Rect.fromLTWH(230, 200, 0, 0));

    page.graphics.drawString('FAX/FEKESE/FAKS(053) 927 3482',
        PdfStandardFont(PdfFontFamily.timesRoman, 18),
        bounds: const Rect.fromLTWH(230, 220, 0, 0));

    page.graphics.drawString(
        'DEPARTMENT:', PdfStandardFont(PdfFontFamily.timesRoman, 18),
        bounds: const Rect.fromLTWH(0, 320, 0, 0));

    page.graphics.drawString(
        'LEFAPHA:', PdfStandardFont(PdfFontFamily.timesRoman, 18),
        bounds: const Rect.fromLTWH(0, 340, 0, 0));

    page.graphics.drawString(
        'DEPARTEMENT:', PdfStandardFont(PdfFontFamily.timesRoman, 18),
        bounds: const Rect.fromLTWH(0, 360, 0, 0));

    page.graphics.drawString(
        'PROOF OF RESIDENCY', PdfStandardFont(PdfFontFamily.helvetica, 30),
        bounds: const Rect.fromLTWH(0, 400, 0, 0));

    String text =
        'This letter serves to confirm that $name ID Number $idNumber is a resident at $address. and Ward $ward';

    PdfTextElement textElement = PdfTextElement(
        text: text, font: PdfStandardFont(PdfFontFamily.timesRoman, 25));

    //Create layout format
    PdfLayoutFormat layoutFormat = PdfLayoutFormat(
        layoutType: PdfLayoutType.paginate,
        breakType: PdfLayoutBreakType.fitPage);

    //Draw the first paragraph
    PdfLayoutResult result = textElement.draw(
        page: page,
        bounds: Rect.fromLTWH(0, 450, page.getClientSize().width / 1,
            page.getClientSize().height),
        format: layoutFormat)!;

    page.graphics.drawString('Municipality acc no.: $municipalityAccNo',
        PdfStandardFont(PdfFontFamily.timesRoman, 25),
        bounds: Rect.fromLTWH(
            0, 650, page.getClientSize().width, page.getClientSize().height));
    final page2 = document.pages.add();

    page2.graphics.drawString(
        'Signed by: $official', PdfStandardFont(PdfFontFamily.timesRoman, 25),
        bounds: Rect.fromLTWH(
            0, 100, page2.getClientSize().width, page2.getClientSize().height));

    final PdfBitmap image = PdfBitmap(imageSignature.buffer.asUint8List());

    final currentDate = DateFormat.yMMMEd().format(DateTime.now());
    final signatureText = currentDate;

    page2.graphics.drawString(signatureText,
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
        format: PdfStringFormat(alignment: PdfTextAlignment.left),
        bounds: Rect.fromLTWH(page2.getClientSize().width - 220,
            page2.getClientSize().height - 280, 0, 0));

    page2.graphics.drawImage(
        image,
        Rect.fromLTWH(page2.getClientSize().width - 520,
            page2.getClientSize().height - 600, 150, 80));

    //Create template and draw text in template graphics
    final PdfPageTemplateElement custom = PdfPageTemplateElement(
        const Offset(200, 0) & page2.getClientSize(), page2);
    custom.dock = PdfDockStyle.none;
    PdfGraphicsState state = custom.graphics.save();
    custom.graphics.rotateTransform(-40);
    custom.graphics.drawString(
        'VERIFIED', PdfStandardFont(PdfFontFamily.helvetica, 22),
        pen: PdfPens.red,
        brush: PdfBrushes.red,
        bounds: const Rect.fromLTWH(-150, 300, 400, 400));
    custom.graphics.restore(state);

//Add template as a stamp to the PDF document
    document.template.stamps.add(custom);

    page2.graphics.drawImage(
        PdfBitmap(await _readImageData('eproof_app_logo_mini.png')),
        const Rect.fromLTWH(250, 320, 140, 150));

    List<int> bytes = document.save();
    document.dispose();

    saveAndLaunchFile(bytes, '$name Proof Of Residence Letter.pdf');
    _formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green[900],
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              Navigator.pushNamed(context, '/login');
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Scrollbar(
          isAlwaysShown: true,
          controller: _scrollController,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const <Widget>[
                      Text(
                        'Enter Residents Details',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: nameController,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Full Names cannot be empty';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      nameController.text = value!;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Full Names',
                      hintText: 'Enter Full Names',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: idController,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'ID Number cannot be empty';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      idController.text = value!;
                    },
                    decoration: const InputDecoration(
                      labelText: 'ID Number',
                      hintText: 'Enter ID Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: wardController,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ward cannot be empty';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      wardController.text = value!;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Ward',
                      hintText: 'Enter Ward',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: addressController,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Address cannot be empty';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      addressController.text = value!;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      hintText: 'Enter Address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: municipalityAccNoController,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Municipality Acc Number cannot be empty';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      municipalityAccNoController.text = value!;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Municipality Acc Number',
                      hintText: 'Enter Municipality Acc No.',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: phoneNumberController,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone Number cannot be empty';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      phoneNumberController.text = value!;
                    },
                    decoration: const InputDecoration(
                      labelText: 'PhoneNumber',
                      hintText: 'Enter Phone Number with country code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: officialNameController,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Official name cannot be empty';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      officialNameController.text = value!;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Official',
                      hintText: 'Enter Officials Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      const Text('Signature:'),
                      TextButton(
                        onPressed: () {
                          keySignaturePad.currentState!.clear();
                        },
                        child: const Text('Reset Signature'),
                        style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.green[900]),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SfSignaturePad(
                    key: keySignaturePad,
                    backgroundColor: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () async {
                      _openWhatsApp(
                          nameController.text, phoneNumberController.text);
                      final image =
                          await keySignaturePad.currentState?.toImage();
                      final imageSignature = await image!
                          .toByteData(format: ui.ImageByteFormat.png);
                      validateAndSave()
                          ? _createProofOfRes(
                              nameController.text,
                              idController.text,
                              wardController.text,
                              addressController.text,
                              municipalityAccNoController.text,
                              phoneNumberController.text,
                              officialNameController.text,
                              imageSignature!)
                          : Navigator.pushNamed(context, '/home');
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.green[900]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
