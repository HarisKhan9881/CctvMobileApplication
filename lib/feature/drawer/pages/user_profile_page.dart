import 'dart:typed_data';

import 'package:cctv_app/core/components/custom_dropdown.dart';
import 'package:cctv_app/core/components/custom_textfield.dart';
import 'package:cctv_app/core/components/plain_selection_widget.dart';
import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/network/api_exception.dart';
import 'package:cctv_app/core/network/models/country_option.dart';
import 'package:cctv_app/core/network/models/general_parameter_option.dart';
import 'package:cctv_app/core/network/models/uploaded_media.dart';
import 'package:cctv_app/core/network/models/user_profile.dart';
import 'package:cctv_app/core/network/services/application_cloud_service.dart';
import 'package:cctv_app/core/network/services/common_parameter_service.dart';
import 'package:cctv_app/core/network/services/general_parameter_service.dart';
import 'package:cctv_app/core/network/services/user_service.dart';
import 'package:cctv_app/core/storage/auth_storage.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final CommonParameterService _commonParameterService =
      const CommonParameterService();
  final GeneralParameterService _generalParameterService =
      const GeneralParameterService();
  final UserService _userService = const UserService();
  final ApplicationCloudService _applicationCloudService =
      const ApplicationCloudService();
  List<CountryOption> _countries = const [];
  List<GeneralParameterOption> _genders = const [];
  List<GeneralParameterOption> _profileTypes = const [];
  CountryOption? _selectedCountry;
  GeneralParameterOption? _selectedGender;
  GeneralParameterOption? _selectedProfileType;
  UserProfile? _userProfile;
  UploadedMedia? _uploadedProfileImage;
  bool _isLoadingCountries = false;
  bool _isLoadingGenders = false;
  bool _isLoadingProfileTypes = false;
  bool _isLoadingProfile = false;
  bool _isUploadingProfileImage = false;
  bool _isSavingProfile = false;
  String? _countryLoadError;
  String? _genderLoadError;
  String? _profileTypeLoadError;
  String? _profileLoadError;
  String? _selectedMonth;
  String? _selectedDay;
  String? _selectedYear;

  List<String> get _days => List.generate(31, (index) => '${index + 1}');

  List<String> get _years {
    final currentYear = DateTime.now().year;
    return List.generate(100, (index) => '${currentYear - index}');
  }

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    firstNameController.text = '';
    lastNameController.text = '';
    phoneNumberController.text = '';
    await Future.wait([_loadCountries(), _loadGenders(), _loadProfileTypes()]);
    await _loadUserProfile();
  }

  Future<void> _loadCountries() async {
    setState(() {
      _isLoadingCountries = true;
      _countryLoadError = null;
    });

    try {
      final accessToken = await const AuthStorage().readAccessToken();
      if (accessToken == null || accessToken.trim().isEmpty) {
        throw const ApiException('Session token not found');
      }
      final countries = await _commonParameterService.getCountries(
        accessToken: accessToken,
      );

      if (!mounted) return;
      setState(() {
        _countries = countries;
        _syncCountrySelection(countries);
        if (countries.isEmpty) {
          _countryLoadError = 'No countries returned from API';
        }
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _countryLoadError = e.message;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _countryLoadError = 'Failed to load countries';
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load countries: $e')));
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoadingCountries = false;
      });
    }
  }

  Future<void> _loadGenders() async {
    setState(() {
      _isLoadingGenders = true;
      _genderLoadError = null;
    });

    try {
      final accessToken = await const AuthStorage().readAccessToken();
      if (accessToken == null || accessToken.trim().isEmpty) {
        throw const ApiException('Session token not found');
      }

      final genders = await _generalParameterService.getByHeaderName(
        headerName: 'GENDER',
        accessToken: accessToken,
      );

      if (!mounted) return;
      setState(() {
        _genders = genders;
        _syncGenderSelection(genders);
        if (genders.isEmpty) {
          _genderLoadError = 'No genders returned from API';
        }
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _genderLoadError = e.message;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _genderLoadError = 'Failed to load genders';
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load genders: $e')));
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoadingGenders = false;
      });
    }
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoadingProfile = true;
      _profileLoadError = null;
    });

    try {
      final storage = const AuthStorage();
      final accessToken = await storage.readAccessToken();
      final userId = await storage.readUserId();

      if (accessToken == null || accessToken.trim().isEmpty) {
        throw const ApiException('Session token not found');
      }
      if (userId == null) {
        throw const ApiException('Session user not found');
      }

      final profile = await _userService.getUserById(
        accessToken: accessToken,
        userId: userId,
      );

      if (!mounted) return;
      setState(() {
        _userProfile = profile;
        firstNameController.text = profile.firstName;
        lastNameController.text = profile.lastName;
        _syncCountrySelection(_countries);
        _syncGenderSelection(_genders);
        _syncProfileTypeSelection(_profileTypes);
        _applyDob(profile.dob);
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _profileLoadError = e.message;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _profileLoadError = 'Failed to load user profile';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user profile: $e')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoadingProfile = false;
      });
    }
  }

  Future<void> _loadProfileTypes() async {
    setState(() {
      _isLoadingProfileTypes = true;
      _profileTypeLoadError = null;
    });

    try {
      final accessToken = await const AuthStorage().readAccessToken();
      if (accessToken == null || accessToken.trim().isEmpty) {
        throw const ApiException('Session token not found');
      }

      final profileTypes = await _generalParameterService.getByHeaderName(
        headerName: 'PROFILE_TYPE',
        accessToken: accessToken,
      );

      if (!mounted) return;
      setState(() {
        _profileTypes = profileTypes;
        _syncProfileTypeSelection(profileTypes);
        if (profileTypes.isEmpty) {
          _profileTypeLoadError = 'No profile types returned from API';
        }
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _profileTypeLoadError = e.message;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _profileTypeLoadError = 'Failed to load profile types';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile types: $e')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoadingProfileTypes = false;
      });
    }
  }

  void _syncCountrySelection(List<CountryOption> countries) {
    final countryId = _userProfile?.countryId;
    if (countryId == null) {
      _selectedCountry = null;
      return;
    }

    for (final country in countries) {
      if (country.countryId == countryId) {
        _selectedCountry = country;
        return;
      }
    }
    _selectedCountry = null;
  }

  void _syncGenderSelection(List<GeneralParameterOption> genders) {
    final genderId = _userProfile?.genderId;
    if (genderId == null) {
      _selectedGender = null;
      return;
    }

    for (final gender in genders) {
      if (_matchesGeneralParameterId(gender, genderId)) {
        _selectedGender = gender;
        return;
      }
    }
    _selectedGender = null;
  }

  void _syncProfileTypeSelection(List<GeneralParameterOption> profileTypes) {
    final profileTypeId = _userProfile?.profileTypeId;
    if (profileTypeId == null) {
      _selectedProfileType = null;
      return;
    }

    for (final profileType in profileTypes) {
      if (_matchesGeneralParameterId(profileType, profileTypeId)) {
        _selectedProfileType = profileType;
        return;
      }
    }
    _selectedProfileType = null;
  }

  bool _matchesGeneralParameterId(GeneralParameterOption option, int targetId) {
    if (option.paramDetailId == targetId) {
      return true;
    }

    return int.tryParse(option.paramValue.trim()) == targetId;
  }

  void _applyDob(String? dob) {
    if (dob == null || dob.trim().isEmpty) {
      _selectedMonth = null;
      _selectedDay = null;
      _selectedYear = null;
      return;
    }

    final parsed = DateTime.tryParse(dob);
    if (parsed == null) {
      _selectedMonth = null;
      _selectedDay = null;
      _selectedYear = null;
      return;
    }

    _selectedMonth = _months[parsed.month - 1];
    _selectedDay = '${parsed.day}';
    _selectedYear = '${parsed.year}';
  }

  String? _buildDob() {
    if (_selectedMonth == null ||
        _selectedDay == null ||
        _selectedYear == null) {
      return null;
    }

    final monthIndex = _months.indexOf(_selectedMonth!);
    if (monthIndex == -1) return null;

    final month = '${monthIndex + 1}'.padLeft(2, '0');
    final day = _selectedDay!.padLeft(2, '0');
    return '${_selectedYear!}-$month-$day';
  }

  Future<void> _saveProfile() async {
    if (_isSavingProfile) return;

    try {
      final storage = const AuthStorage();
      final accessToken = await storage.readAccessToken();
      final userId = await storage.readUserId();

      if (accessToken == null || accessToken.trim().isEmpty) {
        throw const ApiException('Session token not found');
      }
      if (userId == null) {
        throw const ApiException('Session user not found');
      }
      if (_userProfile == null) {
        throw const ApiException('User profile not loaded');
      }

      setState(() {
        _isSavingProfile = true;
      });

      await _userService.updateUser(
        accessToken: accessToken,
        userId: userId,
        body: {
          'first_name': firstNameController.text.trim(),
          'last_name': lastNameController.text.trim(),
          'country_id': _selectedCountry?.countryId ?? 0,
          'state_id': _userProfile?.stateId ?? 0,
          'city_id': _userProfile?.cityId ?? 0,
          'dob': _buildDob(),
          'gender_id': _selectedGender?.paramDetailId ?? 0,
          'profile_type_id': _selectedProfileType?.paramDetailId ?? 0,
          'meta_id': _uploadedProfileImage?.metaId ?? _userProfile?.metaId ?? 0,
          'role_id': _userProfile?.roleId ?? 0,
          'is_active': _userProfile?.isActive ?? 'Y',
          'update_by': userId,
        },
      );

      await storage.saveAuth(
        accessToken: accessToken,
        userId: userId,
        roleId: _userProfile?.roleId,
        roleDescription: _userProfile?.roleDescription,
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: _userProfile?.email,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      await _loadUserProfile();
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update profile: $e')));
    } finally {
      if (!mounted) return;
      setState(() {
        _isSavingProfile = false;
      });
    }
  }

  Future<void> _pickAndUploadProfileImage() async {
    if (_isUploadingProfileImage) return;

    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(source: ImageSource.gallery);
      if (file == null) return;

      final accessToken = await const AuthStorage().readAccessToken();
      if (accessToken == null || accessToken.trim().isEmpty) {
        throw const ApiException('Session token not found');
      }

      setState(() {
        _isUploadingProfileImage = true;
      });

      final Uint8List fileBytes = await file.readAsBytes();
      final uploadedMedia = await _applicationCloudService.uploadImage(
        accessToken: accessToken,
        filePath: file.path,
        fileBytes: fileBytes,
        fileName: file.name,
      );

      if (!mounted) return;
      setState(() {
        _uploadedProfileImage = uploadedMedia;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile image uploaded successfully')),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload profile image: $e')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isUploadingProfileImage = false;
      });
    }
  }

  ImageProvider _profileImageProvider() {
    final profileImageUrl =
        _uploadedProfileImage?.metaUrl ??
        _userProfile?.applicationMeta?.metaUrl;
    if (profileImageUrl != null && profileImageUrl.trim().isNotEmpty) {
      return NetworkImage(profileImageUrl);
    }
    return const AssetImage(Assets.pngUser1Image);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 350;
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(backgroundColor: kWhiteColor),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: _isLoadingProfile
                          ? null
                          : _pickAndUploadProfileImage,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: _profileImageProvider(),
                            ),
                            Space.horizontal(16),
                            Expanded(
                              child: Text(
                                _isUploadingProfileImage
                                    ? "Uploading profile photo..."
                                    : _isLoadingProfile
                                    ? "Loading profile..."
                                    : "Upload Profile Photo",
                                style: context.normal.copyWith(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_profileLoadError != null) ...[
                      Space.vertical(8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          _profileLoadError!,
                          style: context.normal.copyWith(
                            color: kRedColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _isLoadingProfile
                              ? null
                              : _loadUserProfile,
                          child: const Text('Retry'),
                        ),
                      ),
                    ],
                    Space.vertical(20),
                    Text("First Name", style: context.semiBold),
                    Space.vertical(6),
                    CustomTextField(
                      hintText: "First Name",
                      hintTextColor: kDarkGreyColor,
                      controller: firstNameController,
                    ),
                    Space.vertical(10),
                    Text("Last Name", style: context.semiBold),
                    Space.vertical(6),
                    CustomTextField(
                      hintText: "Last Name",
                      hintTextColor: kDarkGreyColor,
                      controller: lastNameController,
                    ),
                    Space.vertical(10),
                    Text("Phone Number", style: context.semiBold),
                    Space.vertical(6),
                    CustomTextField(
                      hintText: "Phone Number",
                      hintTextColor: kDarkGreyColor,
                      controller: phoneNumberController,
                    ),
                    Space.vertical(10),
                    Text("Location", style: context.semiBold),
                    Space.vertical(6),
                    Row(
                      children: [
                        Expanded(
                          child: CustomDropdown<String>(
                            value: null,
                            items: const [],
                            hint: "City",
                            screenWidth: screenWidth,
                            isSmallScreen: isSmallScreen,
                            isSearchable: true,
                            openSearchInPopup: true,
                            searchHintText: "Search city",
                            validator: (_) => null,
                          ),
                        ),
                        Space.horizontal(8),
                        Expanded(
                          child: CustomDropdown<CountryOption>(
                            key: ValueKey(
                              'country-${_selectedCountry?.countryId ?? 'none'}',
                            ),
                            value: _selectedCountry,
                            items: _countries
                                .map(
                                  (country) => DropdownMenuItem<CountryOption>(
                                    value: country,
                                    child: Text(country.countryName),
                                  ),
                                )
                                .toList(),
                            hint: _isLoadingCountries
                                ? "Loading..."
                                : "Country",
                            screenWidth: screenWidth,
                            isSmallScreen: isSmallScreen,
                            isSearchable: true,
                            openSearchInPopup: true,
                            searchHintText: "Search country",
                            enabled: !_isLoadingCountries,
                            itemLabelBuilder: (country) => country.countryName,
                            validator: (_) => null,
                            onChanged: (country) {
                              setState(() {
                                _selectedCountry = country;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    if (_countryLoadError != null) ...[
                      Space.vertical(8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          _countryLoadError!,
                          style: context.normal.copyWith(
                            color: kRedColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _isLoadingCountries
                              ? null
                              : _loadCountries,
                          child: const Text('Retry'),
                        ),
                      ),
                    ],
                    Space.vertical(10),
                    Text("Birthday", style: context.semiBold),
                    Space.vertical(6),
                    Row(
                      children: [
                        Expanded(
                          child: CustomDropdown<String>(
                            value: _months.contains(_selectedMonth)
                                ? _selectedMonth
                                : null,
                            items: _months
                                .map(
                                  (month) => DropdownMenuItem<String>(
                                    value: month,
                                    child: Text(month),
                                  ),
                                )
                                .toList(),
                            hint: "Month",
                            screenWidth: screenWidth,
                            isSmallScreen: isSmallScreen,
                            onChanged: (value) {
                              setState(() {
                                _selectedMonth = value;
                              });
                            },
                          ),
                        ),
                        Space.horizontal(6),
                        Expanded(
                          child: CustomDropdown<String>(
                            value: _days.contains(_selectedDay)
                                ? _selectedDay
                                : null,
                            items: _days
                                .map(
                                  (day) => DropdownMenuItem<String>(
                                    value: day,
                                    child: Text(day),
                                  ),
                                )
                                .toList(),
                            hint: "Day",
                            screenWidth: screenWidth,
                            isSmallScreen: isSmallScreen,
                            onChanged: (value) {
                              setState(() {
                                _selectedDay = value;
                              });
                            },
                          ),
                        ),
                        Space.horizontal(6),
                        Expanded(
                          child: CustomDropdown<String>(
                            value: _years.contains(_selectedYear)
                                ? _selectedYear
                                : null,
                            items: _years
                                .map(
                                  (year) => DropdownMenuItem<String>(
                                    value: year,
                                    child: Text(year),
                                  ),
                                )
                                .toList(),
                            hint: "Year",
                            screenWidth: screenWidth,
                            isSmallScreen: isSmallScreen,
                            onChanged: (value) {
                              setState(() {
                                _selectedYear = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Space.vertical(10),
                    Text("Profile", style: context.semiBold),
                    Space.vertical(6),
                    if (_isLoadingProfileTypes)
                      Text(
                        'Loading profile types...',
                        style: context.normal.copyWith(color: kDarkGreyColor),
                      )
                    else
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: _profileTypes.map((profileType) {
                          return SizedBox(
                            width: (screenWidth - 44) / 2,
                            child: PlainSelectionWidget(
                              onChange: () {
                                setState(() {
                                  _selectedProfileType = profileType;
                                });
                              },
                              isSelected:
                                  _selectedProfileType?.paramDetailId ==
                                  profileType.paramDetailId,
                              title: profileType.paramLabel,
                              subTitle: "",
                            ),
                          );
                        }).toList(),
                      ),
                    if (_profileTypeLoadError != null) ...[
                      Space.vertical(8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          _profileTypeLoadError!,
                          style: context.normal.copyWith(
                            color: kRedColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _isLoadingProfileTypes
                              ? null
                              : _loadProfileTypes,
                          child: const Text('Retry'),
                        ),
                      ),
                    ],
                    Space.vertical(10),
                    Text("Gender", style: context.semiBold),
                    Space.vertical(6),
                    CustomDropdown<GeneralParameterOption>(
                      key: ValueKey(
                        'gender-${_selectedGender?.paramDetailId ?? _selectedGender?.paramValue ?? 'none'}',
                      ),
                      value: _selectedGender,
                      items: _genders
                          .map(
                            (gender) =>
                                DropdownMenuItem<GeneralParameterOption>(
                                  value: gender,
                                  child: Text(gender.paramLabel),
                                ),
                          )
                          .toList(),
                      hint: _isLoadingGenders ? "Loading..." : "Select Gender",
                      screenWidth: screenWidth,
                      isSmallScreen: isSmallScreen,
                      isSearchable: true,
                      openSearchInPopup: true,
                      searchHintText: "Search gender",
                      enabled: !_isLoadingGenders,
                      itemLabelBuilder: (gender) => gender.paramLabel,
                      validator: (_) => null,
                      onChanged: (gender) {
                        setState(() {
                          _selectedGender = gender;
                        });
                      },
                    ),
                    if (_genderLoadError != null) ...[
                      Space.vertical(8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          _genderLoadError!,
                          style: context.normal.copyWith(
                            color: kRedColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _isLoadingGenders ? null : _loadGenders,
                          child: const Text('Retry'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            Space.vertical(20),
            PrimaryButton(
              text: "Save",
              processing: _isSavingProfile,
              inactive: _isSavingProfile,
              onPressed: _saveProfile,
            ),
            Space.vertical(30),
          ],
        ),
      ),
    );
  }
}
