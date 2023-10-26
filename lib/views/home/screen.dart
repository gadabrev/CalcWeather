import 'dart:io';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:test_project/components/system/date-formatter.dart';
import 'package:test_project/core/globals.dart';
import 'package:test_project/core/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  final FocusNode _focusName = FocusNode();
  final FocusNode _focusPassword = FocusNode();
  final FocusNode _focusDate = FocusNode();
  final FocusNode _focusPhone = FocusNode();

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerDate = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();

  bool _isCheckedPassword = false;
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();
  RegExp regex = RegExp(r'[A-Za-z0-9!@#\$&*~_]');

  String date = DateFormat('dd/MM/yyyy').format(DateTime.now());
  void set_date(String value) {
    setState(() {
      date = value;
    });
  }

  File? image;
  Future getImage(ImageSource source) async {
    final _image = await ImagePicker().pickImage(
      source: source,
      imageQuality: 25,
    );
    if (_image == null) return;

    final fixedImage = await FlutterExifRotation.rotateImage(path: _image.path);

    setState(() {
      image = fixedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScrollScreen(
      useGesture: true,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.person,
                  size: 14,
                  color: Colors.black26,
                ),
                Padding(padding: EdgeInsets.only(right: 10)),
                Text(
                  'Имя',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.black26,
                  ),
                ),
              ],
            ),
            TextFormField(
              onFieldSubmitted: (value) => _focusPassword.requestFocus(),
              keyboardType: TextInputType.text,
              controller: _controllerName,
              cursorHeight: 18,
              cursorWidth: 2,
              cursorColor: Colors.black,
              focusNode: _focusName,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Zа-яА-Я]')),
              ],
              style: const TextStyle(fontSize: 18),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(12),
                hintText: 'Введите текст',
                hintStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.black26,
                  letterSpacing: 0.5,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.black26),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.black),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.lock,
                  size: 14,
                  color: Colors.black26,
                ),
                Padding(padding: EdgeInsets.only(right: 10)),
                Text(
                  'Пароль',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.black26,
                  ),
                ),
              ],
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                focusNode: _focusPassword,
                controller: _controllerPassword,
                onFieldSubmitted: (value) => 0,
                validator: (currentPassword) {
                  RegExp(r'\w');
                  var passNonNullValue = currentPassword ?? "";
                  if (passNonNullValue.isEmpty) {
                    _isCheckedPassword = false;
                  } else if (passNonNullValue.length < 8) {
                    _isCheckedPassword = false;
                    return ("Пароль должен содержать более 8 символов");
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _isCheckedPassword = true;
                    if (_formKey.currentState!.validate()) return;
                  });
                },
                style: const TextStyle(fontSize: 18),
                textAlignVertical: TextAlignVertical.center,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.visiblePassword,
                inputFormatters: [
                  FilteringTextInputFormatter(regex, allow: true),
                ],
                cursorColor: Colors.black,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  hintText: 'Введите пароль',
                  hintStyle: const TextStyle(
                    color: Colors.black26,
                    letterSpacing: 0.5,
                    fontSize: 18,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.black26),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.black),
                  ),
                  focusedErrorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.black),
                  ),
                  errorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: Colors.red,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                      color: _isObscure ? Colors.black26 : Colors.grey,
                    ),
                    splashColor: Colors.transparent,
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.date_range_rounded,
                  size: 14,
                  color: Colors.black26,
                ),
                Padding(padding: EdgeInsets.only(right: 10)),
                Text(
                  'Дата',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.black26,
                  ),
                ),
              ],
            ),
            TextFormField(
              focusNode: _focusDate,
              controller: _controllerDate,
              style: const TextStyle(fontSize: 18),
              textAlignVertical: TextAlignVertical.center,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                LengthLimitingTextInputFormatter(10),
                DateFormatter(),
              ],
              onFieldSubmitted: (value) => date = value,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: '01/01/2000',
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                hintStyle: const TextStyle(
                  color: Colors.black26,
                  letterSpacing: 0.5,
                  fontSize: 18,
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.black26),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.black),
                ),
                suffixIcon: RawButton(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.calendar_month, color: Colors.black54),
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      locale: const Locale("ru", "RU"),
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: ColorScheme.light(
                              primary: const Color.fromARGB(
                                  255, 114, 1, 44), // header background color
                              onPrimary: Colors.white, // header text color
                              onSurface: Colors.black, // body text color
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    Colors.black, // button text color
                              ),
                            ),
                            dialogBackgroundColor: Colors.white,
                          ),
                          child: child!,
                        );
                      },
                    ).then((_date) {
                      if (isNullOrEmpty(_date)) return;
                      _controllerDate.text =
                          DateFormat('dd/MM/yyyy').format(_date!);
                      set_date(DateFormat('dd/MM/yyyy').format(_date));
                    });
                  },
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.call,
                  size: 14,
                  color: Colors.black26,
                ),
                const Padding(padding: EdgeInsets.only(right: 10)),
                Text(
                  'Номер телефона',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.black26,
                  ),
                ),
              ],
            ),
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: _controllerPhone,
              cursorHeight: 18,
              cursorWidth: 2,
              cursorColor: Colors.black,
              focusNode: _focusPhone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'\d')),
              ],
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(12),
                hintText: 'Введите номер телефона',
                hintStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.black26,
                  letterSpacing: 0.5,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.black26),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.black),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            image == null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 250,
                        child: Text(
                          'Выберите фотографию из галереи или сфотографируйте через камеру',
                          style: TextStyle(
                            color: Colors.black26,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          RawButton(
                            padding: EdgeInsets.all(5),
                            child: Icon(
                              Icons.photo,
                              size: 60,
                            ),
                            onPressed: () => getImage(ImageSource.gallery),
                          ),
                          RawButton(
                            padding: EdgeInsets.all(5),
                            child: Icon(
                              Icons.camera_alt,
                              size: 60,
                            ),
                            onPressed: () => getImage(ImageSource.camera),
                          ),
                        ],
                      ),
                    ],
                  )
                : Container(
                    height: 270,
                    width: 270,
                    child: Stack(
                      children: [
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              height: 250,
                              width: 250,
                              color: Colors.black26,
                              child: image != null
                                  ? Image.file(image!, fit: BoxFit.cover)
                                  : Container(),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: RawButton(
                              onPressed: () {
                                setState(() {
                                  image = null;
                                });
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.shade300),
                                  child: Icon(
                                    Icons.close,
                                    size: 30,
                                  ))),
                        ),
                      ],
                    ),
                  ),
            Padding(padding: EdgeInsets.only(top: 40)),
            RawButton(
              onPressed: () {},
              active: _isCheckedPassword && _controllerName.text.isNotEmpty,
              height: 60,
              width: 120,
              color: const Color.fromARGB(255, 114, 1, 44),
              alignment: Alignment.center,
              child: const Text(
                'Submit',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
          ],
        ),
      ],
    );
  }
}
