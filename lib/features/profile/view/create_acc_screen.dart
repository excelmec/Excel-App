import 'package:dropdown_search/dropdown_search.dart';
import 'package:excelapp2025/core/api/routes/api_routes.dart';
import 'package:excelapp2025/core/api/services/api_service.dart';
import 'package:excelapp2025/core/api/services/auth_service.dart';
import 'package:excelapp2025/features/profile/widgets/dialogue_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../bloc/profile_bloc.dart';

enum CreateAccMode { CREATE, UPDATE }

//TODO : lot of context calls in async

class CreateAccScreen extends StatefulWidget {
  const CreateAccScreen({super.key, required this.mode});
  final CreateAccMode mode;

  @override
  State<CreateAccScreen> createState() => _CreateAccScreenState();
}

class _CreateAccScreenState extends State<CreateAccScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  // final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _institutionNameController =
      TextEditingController();

  String? _selectedGender;
  final List<String> genderOptions = ['Male', 'Female', 'Others'];
  List<String> collegeOptions = ['Other'];
  List<String> schoolOptions = ['Other'];

  String? _selectedInstitutionType;
  String? _selectedInstitution;

  bool isInitialized = false;

  Future<int> updateProfile() async {
    String token = await AuthService.getToken();
    dynamic response = await ApiService.post(
      ApiRoutes.profileUpdate,
      baseUrl: ApiService.accountsBaseUrl,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json-patch+json",
      },
      body: {
        "name": _firstNameController.text,
        "gender": _selectedGender,
        "mobileNumber": _contactController.text,
        "institutionName":
            _selectedInstitution == 'Other' ||
                _selectedInstitutionType == 'Other Institution'
            ? _institutionNameController.text
            : _selectedInstitution.toString().split(" ").sublist(1).join(" "),
        "institutionId": _selectedInstitution.toString().split(" ")[0],
        "categoryId": "0",
      },
    );
    int statusCode;
    response['id'] != -1 ? statusCode = 200 : statusCode = 500;
    return statusCode;
  }

  //TODO (IMPORTANT): Sometimes image not getting reflected at all
  // gets uploaded cuz console print new link
  // but even if uninstall and reinstall app still old image shown ( so likely not caching issue )

  Future<int> _pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();

    if (!context.mounted) return -1;

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return -1;

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          '${ApiService.accountsBaseUrl}${ApiRoutes.profilePictureUpload}',
        ),
      );
      var multipartFile = await http.MultipartFile.fromPath(
        'Image',
        image.path,
      );
      request.files.add(multipartFile);

      String token = await AuthService.getToken();

      request.headers.addAll({
        'accept': 'application/json',
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $token',
      });

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final currentState = context.read<ProfileBloc>().state;
        if (currentState is ProfileLoaded) {
          await NetworkImage(currentState.profileModel.picture).evict();
        }
        context.read<ProfileBloc>().add(LoadProfileData());
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated successfully!'),
          ),
        );
        return 200;
      } else {
        // Error from server
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: ${response.statusCode}')),
        );

        return response.statusCode;
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('An error occurred')));
    } finally {
      return -1;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    // _lastNameController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _institutionNameController.dispose();
    super.dispose();
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization capitalization = TextCapitalization.none,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // FIX: Always reserve icon space to keep alignment consistent
          SizedBox(
            width: 24,
            child: icon != null
                ? Icon(icon, color: Colors.white, size: 26)
                : const SizedBox(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              textCapitalization: capitalization,
              style: const TextStyle(color: Colors.white, fontFamily: 'Mulish'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter $label";
                }
                //Phone Specific validation
                if (label == "Contact" &&
                    (value.length != 10 ||
                        !RegExp(r'^[0-9]+$').hasMatch(value))) {
                  return "Enter valid contact number";
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: label,
                labelStyle: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Mulish',
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool searchable = false,
  }) {
    return DropdownSearch<String>(
      selectedItem: value,
      items: (f, cs) => items,
      popupProps: PopupProps.menu(
        fit: FlexFit.loose,
        showSearchBox: searchable,
        searchFieldProps: TextFieldProps(
          style: const TextStyle(color: Colors.white, fontFamily: 'Mulish'),
          decoration: const InputDecoration(
            hintText: "Search...",
            hintStyle: TextStyle(color: Colors.white54),
            border: OutlineInputBorder(),
          ),
        ),
        menuProps: const MenuProps(backgroundColor: Colors.black),
      ),
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          labelText: hint,
          labelStyle: const TextStyle(
            color: Colors.white,
            fontFamily: 'Mulish',
            overflow: TextOverflow.ellipsis,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white),
          ),
        ),
      ),
      dropdownBuilder: (context, selectedItem) => Text(
        selectedItem ?? "",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.white, fontFamily: 'Mulish'),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Select $hint";
        }
        return null;
      },
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded && !isInitialized) {
          isInitialized = true;

          //TODO : solution feels hacky, use better state management and logic
          void initializeCollegeOptions() async {
            _selectedInstitutionType = state.profileModel.institutionId >= 2300
                ? 'School'
                : state.profileModel.institutionId >= 400
                ? 'College'
                : null;
            try {
              String token = await AuthService.getToken();
              ApiService.get(
                ApiRoutes.collegeList,
                baseUrl: ApiService.accountsBaseUrl,
                headers: ApiService.authHeaders(token),
              ).then((response) {
                final List<dynamic> data = response;
                setState(() {
                  collegeOptions = data
                      .map((item) => "${item['id']} ${item['name']}")
                      .toList();
                  if (_selectedInstitutionType == 'College') {
                    _selectedInstitution = collegeOptions.firstWhere(
                      (inst) =>
                          inst.contains(state.profileModel.institutionName),
                      orElse: () => 'Other',
                    );
                  }
                });
              });
              ApiService.get(
                ApiRoutes.schoolList,
                baseUrl: ApiService.accountsBaseUrl,
                headers: ApiService.authHeaders(token),
              ).then((response) {
                final List<dynamic> data = response;
                setState(() {
                  schoolOptions = data
                      .map((item) => "${item['id']} ${item['name']}")
                      .toList();
                  if (_selectedInstitutionType == 'School') {
                    schoolOptions.firstWhere(
                      (inst) => inst.startsWith(
                        state.profileModel.institutionId.toString(),
                      ),
                      orElse: () => 'Other',
                    );
                  }
                });
              });
            } catch (e) {
              throw Exception('Failed to load institution options: $e');
            }

            if (_selectedInstitutionType == 'Other Institution') {
              setState(() {
                _selectedInstitution = null;
              });
            }
          }

          try {
            initializeCollegeOptions();
          } catch (e) {
            throw Exception('Failed to load institution options: $e');
          }

          _firstNameController.text = state.profileModel.name;
          _selectedGender = genderOptions.contains(state.profileModel.gender)
              ? state.profileModel.gender
              : "Others";
          _contactController.text = state.profileModel.mobileNumber;
          _emailController.text = state.profileModel.email;
          _institutionNameController.text = state.profileModel.institutionName;
        }
        if (state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ProfileLoaded) {
          return Scaffold(
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    widget.mode == CreateAccMode.CREATE
                        ? "assets/images/welcome_background.png"
                        : "assets/images/profile_background.png",
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(color: Colors.black.withAlpha(150)),
                ),
                Column(
                  children: [
                    widget.mode == CreateAccMode.UPDATE
                        ? AppBar(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            title: Text(
                              "Edit Profile",
                              style: GoogleFonts.mulish(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            centerTitle: true,
                            leading: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) {
                                    return DialogueSheet(
                                      title: "Discard Changes?",
                                      description:
                                          "Are you sure you want to discard the changes made to your profile?",
                                      primaryActionText: "Discard",
                                      secondaryActionText: "Cancel",
                                      onPrimaryAction: () {
                                        Navigator.pop(
                                          context,
                                        ); // Close the bottom sheet
                                        Navigator.pop(context); // Navigate back
                                      },
                                      onSecondaryAction: () {
                                        Navigator.pop(
                                          context,
                                        ); // Just close the bottom sheet
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                            actions: [
                              IconButton(
                                icon: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate() &&
                                      context.mounted) {
                                    try {
                                      int response = await updateProfile();
                                      if (response == 200) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text("Profile Updated!"),
                                          ),
                                        );
                                        context.read<ProfileBloc>().add(
                                          LoadProfileData(),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Failed to update profile.",
                                            ),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            //TODO : better error handling
                                            e.toString().contains(
                                                  "(Status code: 422)",
                                                )
                                                ? "No changes found to update."
                                                : "Failed to update profile.",
                                          ),
                                        ),
                                      );
                                    }
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ],
                          )
                        : const SizedBox(height: 80),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 40,
                        ),
                        child: Column(
                          children: [
                            widget.mode == CreateAccMode.CREATE
                                ? Text(
                                    "Complete Your Profile",
                                    style: const TextStyle(
                                      fontSize: 28,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'Mulish',
                                    ),
                                  )
                                : Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 70,
                                        backgroundImage: NetworkImage(
                                          state.profileModel.picture,
                                        ),
                                      ),

                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: GestureDetector(
                                          onTap: () async {
                                            await _pickAndUploadImage();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withAlpha(
                                                200,
                                              ),
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 4,
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.camera_alt_outlined,
                                              size: 20,
                                              color: Color(0xFF691701),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            const SizedBox(height: 28),
                            widget.mode == CreateAccMode.CREATE
                                ? Text(
                                    "Seems like you are new here. Let's get \n you started with a new Excel account",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      height: 1.5,
                                      fontFamily: 'Mulish',
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            const SizedBox(height: 50),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  _buildInputField(
                                    controller: _firstNameController,
                                    label: "Name",
                                    icon: Icons.person_outline,
                                    capitalization: TextCapitalization.words,
                                  ),
                                  // _buildInputField(
                                  //   controller: _lastNameController,
                                  //   label: "Last Name",
                                  //   capitalization: TextCapitalization.words,
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(width: 24),
                                        const SizedBox(width: 12),
                                        SizedBox(
                                          width: 160,
                                          child: _buildDropdownField(
                                            hint: 'Gender',
                                            value: _selectedGender,
                                            items: genderOptions,
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedGender = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _buildInputField(
                                    controller: _contactController,
                                    label: "Contact",
                                    icon: Icons.phone_in_talk_outlined,
                                    keyboardType: TextInputType.phone,
                                  ),
                                  // _buildInputField(
                                  //   controller: _emailController,
                                  //   label: "E-mail",
                                  //   icon: Icons.email_outlined,
                                  //   keyboardType: TextInputType.emailAddress,
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(width: 24),
                                        const SizedBox(width: 12),
                                        SizedBox(
                                          width: 200,
                                          child: _buildDropdownField(
                                            hint: 'Institution Type',
                                            value: _selectedInstitutionType,
                                            items: const [
                                              'College',
                                              'School',
                                              'Other Institution',
                                            ],
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedInstitutionType =
                                                    value;
                                                _selectedInstitution = null;
                                                _institutionNameController
                                                        .text =
                                                    "";
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _selectedInstitutionType == 'College' ||
                                          _selectedInstitutionType == 'School'
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 16,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const SizedBox(width: 24),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: _buildDropdownField(
                                                  hint:
                                                      _selectedInstitutionType ==
                                                          'College'
                                                      ? 'College Name'
                                                      : _selectedInstitutionType ==
                                                            'School'
                                                      ? 'School Name'
                                                      : 'Institution Name',
                                                  value: _selectedInstitution,
                                                  items:
                                                      _selectedInstitutionType ==
                                                          'College'
                                                      ? collegeOptions
                                                      : _selectedInstitutionType ==
                                                            'School'
                                                      ? schoolOptions
                                                      : ['Other'],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _selectedInstitution =
                                                          value;
                                                    });
                                                  },
                                                  searchable: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                  _selectedInstitution == 'Other' ||
                                          _selectedInstitutionType ==
                                              'Other Institution'
                                      ? _buildInputField(
                                          controller:
                                              _institutionNameController,
                                          label: "Institution Name",
                                          icon: Icons.location_on_outlined,
                                          capitalization:
                                              TextCapitalization.words,
                                        )
                                      : const SizedBox.shrink(),

                                  const SizedBox(height: 28),
                                  widget.mode == CreateAccMode.CREATE
                                      ? SizedBox(
                                          width: 301,
                                          height: 54,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 32,
                                                    vertical: 16,
                                                  ),
                                            ),
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                      .validate() &&
                                                  context.mounted) {
                                                try {
                                                  int response =
                                                      await updateProfile();
                                                  if (response == 200) {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          "Profile Updated!",
                                                        ),
                                                      ),
                                                    );
                                                    context
                                                        .read<ProfileBloc>()
                                                        .add(LoadProfileData());
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          "Failed to update profile.",
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                } catch (e) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        //TODO : better error handling
                                                        e.toString().contains(
                                                              "(Status code: 422)",
                                                            )
                                                            ? "No changes found to update."
                                                            : "Failed to update profile.",
                                                      ),
                                                    ),
                                                  );
                                                }
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Text(
                                                  "Update Profile",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                    fontFamily: 'Mulish',
                                                  ),
                                                ),
                                                // Icon(
                                                //   Icons.arrow_forward,
                                                //   size: 20,
                                                //   color: Colors.white,
                                                // ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
