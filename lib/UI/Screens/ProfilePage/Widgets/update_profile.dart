import 'package:cached_network_image/cached_network_image.dart';
import 'package:excelapp/Accounts/account_services.dart';
import 'package:excelapp/Models/user_model.dart';
import 'package:excelapp/Models/view_user.dart';
import 'package:excelapp/UI/Components/AlertDialog/alertDialog.dart';
import 'package:excelapp/UI/Components/LoadingUI/alertDialog.dart';
import 'package:excelapp/UI/Themes/colors.dart';
import 'package:excelapp/UI/Themes/gradient.dart';
import 'package:excelapp/UI/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class UpdateProfile extends StatefulWidget {
  final ViewUser user;
  UpdateProfile(this.user);

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  List<Institution> collegeInstitutions = [];
  List<Institution> schoolInstitutions = [];

  // Form Fields
  final _formKey = GlobalKey<FormState>();
//int _id;
  late String _name;
  late String _picture;
  late String _mobileNumber;
  late int _categoryId;
  late int _institutionId;
  late String _institutionName;
  late String _gender;
  late String _emailId;
  late List<String> _categories = <String>['College', 'School'];
  late List<String> _genders = <String>['Male', 'Female', 'Other'];
  late String notInListOptionName = "NOT IN THIS LIST";
  late String _customInstitutionName = "";

// Category id's & their values:
// 0: College
// 1: School
// 2: Other

  @override
  void initState() {
    super.initState();
    print(widget.user);
    initialiseUserDetails(widget.user);
    //initialiseUserDetails();
  }

  // Initialize form fields
  initialiseUserDetails(
    ViewUser user,
  ) async {
    //_id = user.id;
    _name = user.name;
    _mobileNumber = user.mobileNumber;
    _picture = user.picture;
    //_category = user.category != "Not Registered" ? user.category : "college";
    _institutionId = user.institutionId;
    _institutionName = user.institutionName;
    _gender = user.gender;
    _emailId = user.email;
    _categoryId = 0;
    if (_categoryId == 1 || _categoryId == 0) {
      await getInstitutions(loading: false);
      _institutionName = await getInstitutionName(_institutionId);
      print("Institution Name: $_institutionName");
      setState(() {
        _institutionName = _institutionName;
      });
    }
  }

  backConfirmation() {
    showModalBottomSheet(
      useRootNavigator: true,
      backgroundColor: backgroundBlue,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40))),
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        maxHeight: 230,
      ),
      context: context,
      builder: (BuildContext bc) {
        return Container(
            child: Column(
          children: [
            SizedBox(height: 8),
            Image.asset(
              "assets/icons/divider.png",
              width: 340,
            ),
            SizedBox(
              height: 20,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Text(
                    "Abandon Changes ?",
                    style: TextStyle(
                      fontFamily: "mulish",
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: white100,
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: Text(
                  'The changes made aren’t saved. Are you sure you want to discard all changes?',
                  style: TextStyle(
                    fontFamily: "mulish",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: white100,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        int count = 0;
                        Navigator.of(context).popUntil((_) => count++ >= 2);
                        // Navigator.pushAndRemoveUntil(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => CheckUserLoggedIn()),
                        //     (route) => false);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color.fromARGB(255, 239, 112, 95),
                        ),
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 60,
                        child: Center(
                          child: Text(
                            "Discard",
                            style: TextStyle(
                              fontFamily: "mulish",
                              fontSize: 14,
                              color: Color.fromARGB(255, 251, 255, 255),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color(0xff000000),
                        ),
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 60,
                        child: Center(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                fontFamily: "mulish",
                                fontSize: 14,
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ])
          ],
        ));
      },
    );
  }

  // Fetch institutions based on category
  getInstitutions({loading = true}) async {
    print("Fetching Institutions for category: $_categoryId");
    await Future.delayed(Duration(microseconds: 1));
    String category;
    if (_categoryId == 0)
      category = "college";
    else if (_categoryId == 1)
      category = "school";
    else
      category = "Other";
    final loadingDialog = alertBox("Fetching Institutions");
    if (loading)
      showDialog(
        context: context,
        builder: (BuildContext context) => loadingDialog,
        barrierDismissible: false,
      );

    try {
      List<Institution> res = await AccountServices.fetchInstitutions(category);
      Institution notInListOption =
          Institution(id: 0, name: notInListOptionName);
      res.insert(0, notInListOption);
      setState(() {
        if (_categoryId == 0)
          collegeInstitutions = res;
        else if (_categoryId == 1) schoolInstitutions = res;
      });
      if (loading) Navigator.of(context, rootNavigator: true).pop();
    } catch (_) {
      if (loading) Navigator.of(context, rootNavigator: true).pop();
      alertDialog(
        text: "Failed to fetch institutions\nTry again",
        context: context,
      );
    }
  }

  // Submit Form
  Future submitForm() async {
    setState(() {});
    final loadingDialog = alertBox("Submitting Form");
    showDialog(
      context: context,
      builder: (BuildContext context) => loadingDialog,
      barrierDismissible: false,
    );

    // // get institutionId only if category is school or college & not in list
    if (_categoryId != 2 && _institutionName != notInListOptionName) {
      _institutionId = await getInstitutionId(_institutionName);
    }
    // Set institution if to 0 if its custom entered
    if (_institutionName == notInListOptionName) {
      _institutionId = 0;
    }
    if (_institutionId == null && _categoryId != 2) {
      Navigator.of(context, rootNavigator: true).pop();
      return "One or more fields are invalid!";
    }
    if (_categoryId != 2 && _institutionName == null) {
      Navigator.of(context, rootNavigator: true).pop();
      return "Select institution";
    }
    if (_customInstitutionName == notInListOptionName) {
      Navigator.of(context, rootNavigator: true).pop();
      return "Enter institution name";
    }
    if (_institutionName == null && _categoryId != 2) {
      Navigator.of(context, rootNavigator: true).pop();
      return "Choose institution name";
    }

    String finalInstitutionName = (_institutionName == notInListOptionName)
        ? _customInstitutionName
        : _institutionName;

    print("Institution Name: $finalInstitutionName");

    Map<String, dynamic> userInfo = {
      "name": _name,
      "institutionId": _institutionId,
      "institutionName": finalInstitutionName,
      "gender": _gender,
      "mobileNumber": _mobileNumber.toString(),
      "categoryId": _categoryId.toString()
    };
    print(userInfo);
    var res = await AccountServices.updateProfile(userInfo);
    Navigator.of(context, rootNavigator: true).pop();
    if (res == "error")
      alertDialog(text: "Something went wrong", context: context);
    else {
      return "Submitted";
    }
  }

  // Method to get institution Id
  Future<int> getInstitutionId(String institutionName) async {
    int id = -1;
    if (_categoryId == 0)
      collegeInstitutions.forEach((e) {
        if (institutionName == e.name) {
          id = e.id;
        }
      });
    else if (_categoryId == 1)
      schoolInstitutions.forEach((e) {
        if (institutionName == e.name) {
          id = e.id;
        }
      });
    return id;
  }

  Future<String> getInstitutionName(int institutionId) async {
    String name = ''; // Initialize name with an empty string
    if (_categoryId == 0) {
      collegeInstitutions.forEach((e) {
        if (institutionId == e.id) {
          name = e.name;
        }
      });
    } else if (_categoryId == 1) {
      schoolInstitutions.forEach((e) {
        if (institutionId == e.id) {
          name = e.name;
        }
      });
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        shadowColor: null,
        elevation: 0,
        toolbarHeight: 64,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: secondaryColor,
          onPressed: () {
            backConfirmation();
          },
        ),
        titleTextStyle: TextStyle(
          color: secondaryColor,
          fontFamily: pfontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        title: Text("Edit Profile"),
        actions: [
          saveButton(),
        ],
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          primaryColor: backgroundBlue,
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          decoration: BoxDecoration(
            gradient: primaryGradient(),
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 30),
                  Center(
                      child: Container(
                    //padding: EdgeInsets.symmetric(horizontal: 10),
                    width: 140,
                    height: 110,
                    //color: Colors.yellow,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 10,
                          child: CircleAvatar(
                            radius: 56,
                            backgroundColor: Colors.white38,
                            child: CircleAvatar(
                              radius: 53,
                              backgroundImage:
                                  CachedNetworkImageProvider(_picture),
                            ),
                          ),
                        ),
                        // Positioned(
                        //   //alignment: Alignment.topRight,
                        //   top: 0,
                        //   right: 0,
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(0.0),
                        //     child: ElevatedButton(
                        //       style: ElevatedButton.styleFrom(
                        //         padding: EdgeInsets.all(10),
                        //         backgroundColor: primaryColor,
                        //         shape: CircleBorder(
                        //           side: BorderSide(
                        //             color: primaryColor,
                        //             width: 2,
                        //           ),
                        //         ),
                        //       ),
                        //       child: Icon(
                        //         Icons.camera_alt_outlined,
                        //         size: 18,
                        //         color: Colors.white,
                        //       ),
                        //       onPressed: () {},
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  )),
                  SizedBox(height: 30),
                  // Name
                  TextFormField(
                    initialValue: _name,
                    style: TextStyle(
                      fontFamily: pfontFamily,
                      fontSize: 15,
                      color: secondaryColor,
                    ),
                    onSaved: (value) {
                      setState(() {
                        _name = value!.trim();
                      });
                    },
                    onChanged: (String value) {
                      setState(() {
                        _name = value.trim();
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your Name";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: secondaryColor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: "Name",
                      icon: Icon(Icons.person),
                      contentPadding: EdgeInsets.all(16),
                      iconColor: secondaryColor,
                      labelStyle: TextStyle(
                        color: secondaryColor,
                        fontSize: 14,
                      ),
                      fillColor: backgroundBlue,
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 20),
                  //second name
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                  //   child: TextFormField(
                  //     initialValue: _lastName,
                  //     style: TextStyle(fontFamily: pfontFamily, fontSize: 15),
                  //     onSaved: (String value) {
                  //       setState(() {
                  //         _lastName = value.trim();
                  //       });
                  //     },
                  //     validator: (value) {
                  //       if (value.isEmpty) {
                  //         return "Please enter your name";
                  //       }
                  //       return null;
                  //     },
                  //     decoration: InputDecoration(
                  //       border: OutlineInputBorder(
                  //         borderSide: BorderSide(color: primaryColor),
                  //         borderRadius: BorderRadius.circular(20),
                  //       ),
                  //       enabledBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(color: secondaryColor),
                  //         borderRadius: BorderRadius.circular(20),
                  //       ),
                  //       labelText: "Last Name",
                  //       //icon: Icon(Icons.person),
                  //       contentPadding: EdgeInsets.all(16),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 30,
                  // ),
                  // Select Gender

                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: DropdownButtonFormField(
                          icon: Icon(Icons.keyboard_arrow_down),
                          dropdownColor: backgroundBlue,
                          decoration: InputDecoration(
                            fillColor: backgroundBlue,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: secondaryColor),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            labelText: "Gender",
                            labelStyle: TextStyle(
                              color: secondaryColor,
                              fontSize: 14,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                              borderRadius: BorderRadius.circular(20),
                            ),

                            //hintText: _gender ?? "Select Gender",
                            contentPadding: EdgeInsets.all(16),
                          ),
                          //border: OutlineInputBorder()),
                          items: _genders.map<DropdownMenuItem<String>>((val) {
                            return DropdownMenuItem<String>(
                              value: val,
                              child: Text(
                                val,
                                style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 14,
                                ),
                              ),
                            );
                          }).toList(),
                          hint: Text(_gender ?? "Select Gender",
                              style: TextStyle(color: secondaryColor)),
                          onChanged: (value) {
                            setState(() {
                              _gender = value.toString();
                            });
                          },
                          onSaved: (value) {
                            setState(() {
                              _gender = value.toString();
                            });
                          }),
                    ),
                  ),
                  // Container(
                  //   child: DropdownButton<String>(
                  //     isExpanded: true,
                  //     isDense: true,
                  //     style: TextStyle(color: primaryColor),
                  //     underline: Center(),
                  //     icon: Icon(Icons.keyboard_arrow_down),
                  //     hint: Text(_gender ?? "Select Gender"),

                  //   ),
                  // ),
                  SizedBox(height: 30),
                  // Mobile Number
                  TextFormField(
                    initialValue: (_mobileNumber == null) ? "" : _mobileNumber,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                    ],
                    style: TextStyle(
                      fontFamily: pfontFamily,
                      fontSize: 15,
                      color: secondaryColor,
                    ),
                    onSaved: (value) {
                      setState(() {
                        _mobileNumber = value!;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        _mobileNumber = value;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your mobile number";
                      }
                      if (value.length > 10) {
                        return "Invalid Mobile number";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Contact",
                      icon: Icon(Icons.phone),
                      iconColor: secondaryColor,
                      labelStyle: TextStyle(
                        color: secondaryColor,
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: backgroundBlue,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: secondaryColor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      //icon: Icon(Icons.person),
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                  SizedBox(height: 30),
                  //email
                  TextFormField(
                    initialValue: _emailId ?? "",
                    keyboardType: TextInputType.emailAddress,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(
                          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                          r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                          r"{0,253}[a-zA-Z0-9])?)*$"))
                    ],
                    style: TextStyle(
                      fontFamily: pfontFamily,
                      fontSize: 15,
                      color: secondaryColor,
                    ),
                    onSaved: (value) {
                      setState(() {
                        _emailId = value!;
                      });
                    },
                    validator: (value) {
                      String pattern =
                          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                          r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                          r"{0,253}[a-zA-Z0-9])?)*$";
                      RegExp regex = RegExp(pattern);
                      if (!regex.hasMatch(value!))
                        return 'Enter a valid email address';
                      if (value.isEmpty) {
                        return "Please enter your Email Address";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "E-mail",
                      icon: Icon(Icons.email_outlined),
                      iconColor: secondaryColor,
                      labelStyle: TextStyle(
                        color: secondaryColor,
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: backgroundBlue,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: secondaryColor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      //icon: Icon(Icons.person),
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  // SizedBox(height: 20),
                  // Select Category
                  // Container(
                  //   width: MediaQuery.of(context).size.width,
                  //   child: DropdownButtonFormField(
                  //       decoration: InputDecoration(
                  //         border: OutlineInputBorder(
                  //           borderSide: BorderSide(color: primaryColor),
                  //           borderRadius: BorderRadius.circular(20),
                  //         ),
                  //         enabledBorder: OutlineInputBorder(
                  //           borderSide: BorderSide(color: secondaryColor),
                  //           borderRadius: BorderRadius.circular(20),
                  //         ),
                  //         focusedBorder: OutlineInputBorder(
                  //           borderSide: BorderSide(color: primaryColor),
                  //           borderRadius: BorderRadius.circular(20),
                  //         ),
                  //         labelText: "Institute Type",
                  //         icon: Icon(Icons.location_on_outlined),
                  //         iconColor: secondaryColor,
                  //         labelStyle: TextStyle(
                  //           color: secondaryColor,
                  //           fontSize: 14,
                  //         ),
                  //         fillColor: backgroundBlue,
                  //         filled: true,
                  //         contentPadding: EdgeInsets.all(16),
                  //       ),
                  //       icon: Icon(Icons.keyboard_arrow_down),
                  //       dropdownColor: backgroundBlue,
                  //       //border: OutlineInputBorder()),
                  //       items: _categories.map<DropdownMenuItem<String>>((val) {
                  //         return DropdownMenuItem<String>(
                  //           value: val,
                  //           child: Text(
                  //             val,
                  //             style: TextStyle(
                  //               color: secondaryColor,
                  //               fontSize: 14,
                  //             ),
                  //           ),
                  //         );
                  //       }).toList(),
                  //       hint: Text(
                  //         _categories[_categoryId] ?? "Select Category",
                  //         style: TextStyle(color: secondaryColor),
                  //       ),
                  //       onChanged: (value) {
                  //         setState(() {
                  //           _categoryId = _categories.indexOf(value.toString());
                  //           if (kDebugMode) {
                  //             print("Category ID: $_categoryId");
                  //           }
                  //           //measureList.add(measure);
                  //         });
                  //         getInstitutions();
                  //       },
                  //       onSaved: (value) {
                  //         setState(() {
                  //           _categoryId = _categories.indexOf(value.toString());
                  //           if (kDebugMode) {
                  //             print("Category ID: $_categoryId");
                  //           }
                  //         });
                  //       }),
                  // ),
                  // SizedBox(height: 16),
                  // Select Institution

                  // (_categoryId != 2 &&
                  //         ((_categoryId == 0)
                  //             ? (collegeInstitutions.length > 0)
                  //             : (schoolInstitutions.length > 0)))
                  //     ? Container(
                  //         margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                  //         padding: EdgeInsets.all(8),
                  //         decoration: BoxDecoration(
                  //           border: Border.all(color: black200),
                  //           borderRadius: BorderRadius.circular(24),
                  //           color: backgroundBlue,
                  //         ),
                  //
                  //         // child: SearchableDropdown.single(
                  //         //   underline: Center(),
                  //         //   readOnly: _categoryId == null || _categoryId == 2,
                  //         //   items: institutions
                  //         //       .map<DropdownMenuItem<String>>((val) {
                  //         //     return DropdownMenuItem<String>(
                  //         //       value: val.name,
                  //         //       child: Text(
                  //         //         val.name.toString(),
                  //         //         style: TextStyle(
                  //         //           color: Colors.black87,
                  //         //           fontSize: 14,
                  //         //         ),
                  //         //       ),
                  //         //     );
                  //         //   }).toList(),
                  //         //   displayClearIcon: false,
                  //         //   hint: _institutionName ?? 'Select Institution',
                  //         //   style: TextStyle(fontSize: 14),
                  //         //   icon: Icon(Icons.keyboard_arrow_down),
                  //         //   searchHint: 'Enter Institution Name',
                  //         //   onChanged: (value) {
                  //         //     setState(() {
                  //         //       _institutionName = value;
                  //         //     });
                  //         //   },
                  //         //   isExpanded: true,
                  //         // ),
                  //         child: SearchableDropdown(
                  //           hintText:
                  //               Text(_institutionName ?? 'Select Institution'),
                  //           searchHintText: 'Enter Institution Name',
                  //           items: (_categoryId == 0)
                  //               ? collegeInstitutions
                  //                   .map<SearchableDropdownMenuItem<String>>(
                  //                       (val) {
                  //                   return SearchableDropdownMenuItem<String>(
                  //                     value: val.id.toString(),
                  //                     label: val.name,
                  //                     child: Text(
                  //                       val.name.toString(),
                  //                       style: TextStyle(
                  //                         color: secondaryColor,
                  //                         fontSize: 14,
                  //                       ),
                  //                     ),
                  //                   );
                  //                 }).toList()
                  //               : schoolInstitutions
                  //                   .map<SearchableDropdownMenuItem<String>>(
                  //                       (val) {
                  //                   return SearchableDropdownMenuItem<String>(
                  //                     value: val.id.toString(),
                  //                     label: val.name,
                  //                     child: Text(
                  //                       val.name.toString(),
                  //                       style: TextStyle(
                  //                         color: secondaryColor,
                  //                         fontSize: 14,
                  //                       ),
                  //                     ),
                  //                   );
                  //                 }).toList(),
                  //           onChanged: (value) {
                  //             print(int.parse('14'));
                  //             setState(() {
                  //               _institutionId = int.parse('14');
                  //               _institutionName = (_categoryId == 0)
                  //                   ? collegeInstitutions
                  //                       .firstWhere((element) =>
                  //                           element.id == _institutionId)
                  //                       .name
                  //                   : schoolInstitutions
                  //                       .firstWhere((element) =>
                  //                           element.id == _institutionId)
                  //                       .name;
                  //             });
                  //           },
                  //         ))
                  //     : Center(),

                  // (_institutionName == notInListOptionName && _categoryId != 2)
                  //     ? Padding(
                  //         padding: const EdgeInsets.only(top: 15.0),
                  //         child: TextFormField(
                  //           style: TextStyle(
                  //             fontFamily: pfontFamily,
                  //             fontSize: 15,
                  //             color: secondaryColor,
                  //           ),
                  //           onSaved: (value) {
                  //             setState(() {
                  //               _customInstitutionName = value!.trim();
                  //             });
                  //           },
                  //           onChanged: (String value) {
                  //             setState(() {
                  //               _customInstitutionName = value.trim();
                  //             });
                  //           },
                  //           validator: (value) {
                  //             if (value!.isEmpty) {
                  //               return "Please enter your Institute Name";
                  //             }
                  //             return null;
                  //           },
                  //           decoration: InputDecoration(
                  //             iconColor: secondaryColor,
                  //             labelStyle: TextStyle(
                  //               color: secondaryColor,
                  //               fontSize: 14,
                  //             ),
                  //             filled: true,
                  //             fillColor: backgroundBlue,
                  //             border: OutlineInputBorder(
                  //               borderSide: BorderSide(color: primaryColor),
                  //               borderRadius: BorderRadius.circular(20),
                  //             ),
                  //             enabledBorder: OutlineInputBorder(
                  //               borderSide: BorderSide(color: secondaryColor),
                  //               borderRadius: BorderRadius.circular(20),
                  //             ),
                  //             focusedBorder: OutlineInputBorder(
                  //               borderSide: BorderSide(color: primaryColor),
                  //               borderRadius: BorderRadius.circular(20),
                  //             ),
                  //             labelText: "Institute Name",
                  //             icon: Icon(Icons.location_on_outlined),
                  //             contentPadding: EdgeInsets.all(16),
                  //           ),
                  //         ),
                  //       )
                  //     : Center(),

                  SizedBox(height: _categoryId != null ? 25 : 90),
                  // Submit button

                  SizedBox(height: 120)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget saveButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 6, 24, 6),
      margin: EdgeInsets.symmetric(vertical: 4),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.fromLTRB(24, 8, 24, 8),
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(
          "Save",
          style: TextStyle(
              color: Colors.black,
              fontFamily: pfontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 12),
        ),
        onPressed: () {
          print("Saved");
          _formKey.currentState!.validate()
              ? submitForm().then((value) {
                  if (value == "Submitted") {
                    // Navigator.pushAndRemoveUntil(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => CheckUserLoggedIn(),
                    //   ),
                    //   (Route<dynamic> route) => false,
                    // );

                    Navigator.pop(context);
                  } else {
                    // // _formKey.currentState.save();
                    // ScaffoldMessenger.of(context).showSnackBar(snackBar(value));
                  }
                }).catchError((e) => print(e))
              : print("Not valid");
        },
      ),
    );
  }
}
