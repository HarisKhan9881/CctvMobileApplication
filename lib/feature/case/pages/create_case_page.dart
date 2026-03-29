import 'dart:typed_data';

import 'package:cctv_app/core/components/custom_dropdown.dart';
import 'package:cctv_app/core/components/custom_textfield.dart';
import 'package:cctv_app/core/components/plain_selection_widget.dart';
import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/search_bar_header.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/network/api_exception.dart';
import 'package:cctv_app/core/network/models/general_parameter_option.dart';
import 'package:cctv_app/core/network/models/uploaded_media.dart';
import 'package:cctv_app/core/network/models/user_option.dart';
import 'package:cctv_app/core/network/services/application_cloud_service.dart';
import 'package:cctv_app/core/network/services/general_parameter_service.dart';
import 'package:cctv_app/core/network/services/user_case_service.dart';
import 'package:cctv_app/core/network/services/user_service.dart';
import 'package:cctv_app/core/storage/auth_storage.dart';
import 'package:cctv_app/core/theme/app_colors.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/core/utils/validators.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class CreateCasePage extends StatefulWidget {
  const CreateCasePage({super.key});

  @override
  State<CreateCasePage> createState() => _CreateCasePageState();
}

class _CreateCasePageState extends State<CreateCasePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _caseTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool isMarkAsRead = false;
  bool _hasTriedSubmit = false;
  String? _selectedCategory;
  String? _selectedDefendant;
  String? _selectedViewCategory;
  String? _selectedAvailabilityType;
  bool _isLoadingCategories = true;
  bool _isLoadingDefendants = true;
  bool _isLoadingViewCategories = true;
  bool _isLoadingAvailabilityTypes = true;
  bool _isUploadingAttachment = false;
  bool _isSubmittingCase = false;
  String? _categoryLoadError;
  String? _defendantLoadError;
  String? _viewCategoryLoadError;
  String? _availabilityTypeLoadError;
  String? _selectedAttachmentName;
  String? _attachmentError;
  int? _attachmentMetaId;
  List<GeneralParameterOption> _categories = const [];
  List<UserOption> _defendants = const [];
  List<GeneralParameterOption> _viewCategories = const [];
  List<GeneralParameterOption> _availabilityTypes = const [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadDefendants();
    _loadViewCategories();
    _loadAvailabilityTypes();
  }

  @override
  void dispose() {
    _caseTitleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoadingCategories = true;
      _categoryLoadError = null;
    });

    try {
      final accessToken = await const AuthStorage().readAccessToken();
      if (accessToken == null || accessToken.trim().isEmpty) {
        throw Exception('Session token not found');
      }

      const service = GeneralParameterService();

      final categories = await service.getByHeaderName(
        headerName: 'CASE_CATEGORY',
        accessToken: accessToken,
      );

      if (!mounted) return;
      setState(() {
        _categories = categories;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _categoryLoadError = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _categoryLoadError = 'Failed to load categories';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoadingCategories = false;
      });
    }
  }

  Future<void> _loadDefendants() async {
    setState(() {
      _isLoadingDefendants = true;
      _defendantLoadError = null;
    });

    try {
      final accessToken = await const AuthStorage().readAccessToken();
      if (accessToken == null || accessToken.trim().isEmpty) {
        throw Exception('Session token not found');
      }

      const service = UserService();
      final users = await service.getAllUsers(accessToken: accessToken);

      if (!mounted) return;
      setState(() {
        _defendants = users;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _defendantLoadError = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _defendantLoadError = 'Failed to load defendants';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoadingDefendants = false;
      });
    }
  }

  Future<void> _loadViewCategories() async {
    setState(() {
      _isLoadingViewCategories = true;
      _viewCategoryLoadError = null;
    });

    try {
      final accessToken = await const AuthStorage().readAccessToken();
      if (accessToken == null || accessToken.trim().isEmpty) {
        throw Exception('Session token not found');
      }

      const service = GeneralParameterService();
      final viewCategories = await service.getByHeaderName(
        headerName: 'CASE_VIEW_CATEGORY',
        accessToken: accessToken,
      );

      if (!mounted) return;
      setState(() {
        _viewCategories = viewCategories;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _viewCategoryLoadError = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _viewCategoryLoadError = 'Failed to load case view options';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoadingViewCategories = false;
      });
    }
  }

  Future<void> _loadAvailabilityTypes() async {
    setState(() {
      _isLoadingAvailabilityTypes = true;
      _availabilityTypeLoadError = null;
    });

    try {
      final accessToken = await const AuthStorage().readAccessToken();
      if (accessToken == null || accessToken.trim().isEmpty) {
        throw Exception('Session token not found');
      }

      const service = GeneralParameterService();
      final availabilityTypes = await service.getByHeaderName(
        headerName: 'CASE_AVAILIBILITY_TYPE',
        accessToken: accessToken,
      );

      if (!mounted) return;
      setState(() {
        _availabilityTypes = availabilityTypes;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _availabilityTypeLoadError = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _availabilityTypeLoadError = 'Failed to load availability options';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoadingAvailabilityTypes = false;
      });
    }
  }

  bool get _hasPostVisibilitySelection => _selectedViewCategory != null;
  bool get _hasAvailabilitySelection => _selectedAvailabilityType != null;

  void _togglePostVisibility(String value) {
    setState(() {
      _selectedViewCategory = value;
    });
  }

  void _toggleAvailability(String value) {
    setState(() {
      _selectedAvailabilityType = value;
    });
  }

  int? _selectedParamDetailId(
    List<GeneralParameterOption> options,
    String? selectedValue,
  ) {
    if (selectedValue == null) return null;

    for (final option in options) {
      if (option.paramValue == selectedValue) {
        return option.paramDetailId;
      }
    }

    return null;
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    setState(() {
      _hasTriedSubmit = false;
      _selectedCategory = null;
      _selectedDefendant = null;
      _selectedViewCategory = null;
      _selectedAvailabilityType = null;
      _selectedAttachmentName = null;
      _attachmentError = null;
      _attachmentMetaId = null;
      isMarkAsRead = false;
      _caseTitleController.clear();
      _descriptionController.clear();
    });
  }

  Future<void> _showAttachmentPicker() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: kWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select attachment source',
                  style: context.bold.copyWith(fontSize: 18),
                ),
                Space.vertical(12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.image_outlined),
                  title: const Text('Image from gallery'),
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickImageFromGallery();
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.videocam_outlined),
                  title: const Text('Video from gallery'),
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickVideoFromGallery();
                  },
                ),
                // ListTile(
                //   contentPadding: EdgeInsets.zero,
                //   leading: const Icon(Icons.folder_open_outlined),
                //   title: const Text('Document from device'),
                //   onTap: () async {
                //     Navigator.pop(context);
                //     await _pickDocumentFromFiles();
                //   },
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(source: ImageSource.gallery);
      if (file == null || !mounted) return;
      final fileBytes = await file.readAsBytes();

      await _uploadSelectedFile(
        filePath: file.path,
        fileName: file.name,
        isImage: true,
        fileBytes: fileBytes,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image from gallery: $e')),
      );
    }
  }

  Future<void> _pickVideoFromGallery() async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickVideo(source: ImageSource.gallery);
      if (file == null || !mounted) return;
      final fileBytes = await file.readAsBytes();

      await _uploadSelectedFile(
        filePath: file.path,
        fileName: file.name,
        isImage: false,
        fileBytes: fileBytes,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick video from gallery: $e')),
      );
    }
  }

  Future<void> _uploadSelectedFile({
    required String filePath,
    required String fileName,
    required bool isImage,
    required Uint8List fileBytes,
  }) async {
    setState(() {
      _isUploadingAttachment = true;
      _attachmentError = null;
    });

    try {
      final accessToken = await const AuthStorage().readAccessToken();
      if (accessToken == null || accessToken.trim().isEmpty) {
        throw const ApiException('Session token not found');
      }

      const service = ApplicationCloudService();
      final UploadedMedia uploadedMedia = isImage
          ? await service.uploadImage(
              accessToken: accessToken,
              filePath: filePath,
              fileBytes: fileBytes,
              fileName: fileName,
            )
          : await service.uploadVideo(
              accessToken: accessToken,
              filePath: filePath,
              fileBytes: fileBytes,
              fileName: fileName,
            );

      if (!mounted) return;
      setState(() {
        _selectedAttachmentName = fileName;
        _attachmentMetaId = uploadedMedia.metaId;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${isImage ? 'Image' : 'Video'} uploaded successfully'),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _attachmentError = e.message;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _attachmentError = 'Failed to upload attachment';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload attachment: $e')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isUploadingAttachment = false;
      });
    }
  }

  Future<void> _submitForm() async {
    setState(() {
      _hasTriedSubmit = true;
    });

    final isFormValid = _formKey.currentState?.validate() ?? false;
    final hasCustomValidationPassed =
        _hasPostVisibilitySelection &&
        _hasAvailabilitySelection &&
        isMarkAsRead;

    if (!isFormValid || !hasCustomValidationPassed) {
      return;
    }

    final userId = await const AuthStorage().readUserId();
    final accessToken = await const AuthStorage().readAccessToken();
    final caseCategoryId = _selectedParamDetailId(
      _categories,
      _selectedCategory,
    );
    final caseViewStatusId = _selectedParamDetailId(
      _viewCategories,
      _selectedViewCategory,
    );
    final caseAvailableStatusId = _selectedParamDetailId(
      _availabilityTypes,
      _selectedAvailabilityType,
    );
    final defendantUserId = _selectedDefendant == null
        ? null
        : int.tryParse(_selectedDefendant!);

    if (userId == null || accessToken == null || accessToken.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session not found. Please login again.')),
      );
      return;
    }

    if (caseCategoryId == null ||
        caseViewStatusId == null ||
        caseAvailableStatusId == null ||
        defendantUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select all required options.')),
      );
      return;
    }

    setState(() {
      _isSubmittingCase = true;
    });

    try {
      final service = UserCaseService();
      await service.createUserCase(
        accessToken: accessToken,
        body: {
          'user_id': userId,
          'case_title': _caseTitleController.text.trim(),
          'case_description': _descriptionController.text.trim(),
          'case_category_id': caseCategoryId,
          'case_view_status_id': caseViewStatusId,
          'case_available_status_id': caseAvailableStatusId,
          'tag_defendent_user_id': defendantUserId,
          'meta_id': _attachmentMetaId,
          'is_accept_terms': isMarkAsRead,
          // Using the description as resolution until a separate UI field exists.
          'case_resolution': _descriptionController.text.trim(),
        },
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Case uploaded successfully')),
      );
      _clearForm();
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to upload case: $e')));
    } finally {
      if (!mounted) return;
      setState(() {
        _isSubmittingCase = false;
      });
    }
  }

  Widget _buildInlineError(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          message,
          style: context.normal.copyWith(color: kRedColor, fontSize: 12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 350;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SearchBarHeader(),
        ),
        Space.vertical(14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Create Case",
            style: context.bold.copyWith(fontSize: 24),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Space.vertical(20),
                    Text("Case title", style: context.normal),
                    Space.vertical(8),
                    CustomTextField(
                      controller: _caseTitleController,
                      hintText: "Enter case title",
                      hintTextColor: kDarkGreyColor,
                      validator: Validators.required,
                    ),
                    Space.vertical(16),
                    Text("Description", style: context.normal),
                    Space.vertical(8),
                    CustomTextField(
                      controller: _descriptionController,
                      hintText: "Enter case description",
                      hintTextColor: kDarkGreyColor,
                      maxLine: 5,
                      validator: Validators.required,
                    ),
                    Space.vertical(16),
                    Text("Category", style: context.normal),
                    Space.vertical(8),
                    CustomDropdown(
                      value: _selectedCategory,
                      items: _categories
                          .map(
                            (category) => DropdownMenuItem<String>(
                              value: category.paramValue,
                              child: Text(
                                category.paramLabel,
                                style: TextStyle(color: AppColors.blackColor),
                              ),
                            ),
                          )
                          .toList(),
                      hint: _isLoadingCategories
                          ? "Loading categories..."
                          : "Select a Category",
                      screenWidth: screenWidth,
                      isSmallScreen: isSmallScreen,
                      isSearchable: true,
                      openSearchInPopup: true,
                      searchHintText: "Search category",
                      enabled:
                          !_isLoadingCategories && _categoryLoadError == null,
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                    if (_categoryLoadError != null)
                      _buildInlineError(_categoryLoadError!),
                    if (_categoryLoadError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _loadCategories,
                            child: const Text('Retry'),
                          ),
                        ),
                      ),
                    Space.vertical(16),
                    Text("Tag user defendants", style: context.normal),
                    Space.vertical(8),
                    CustomDropdown(
                      value: _selectedDefendant,
                      items: _defendants
                          .map(
                            (user) => DropdownMenuItem<String>(
                              value: '${user.userId}',
                              child: Text(
                                user.displayName,
                                style: TextStyle(color: AppColors.blackColor),
                              ),
                            ),
                          )
                          .toList(),
                      hint: _isLoadingDefendants
                          ? "Loading defendants..."
                          : "Select defendant",
                      screenWidth: screenWidth,
                      isSmallScreen: isSmallScreen,
                      isSearchable: true,
                      openSearchInPopup: true,
                      searchHintText: "Search defendant",
                      enabled:
                          !_isLoadingDefendants && _defendantLoadError == null,
                      onChanged: (value) {
                        setState(() {
                          _selectedDefendant = value;
                        });
                      },
                    ),
                    if (_defendantLoadError != null)
                      _buildInlineError(_defendantLoadError!),
                    if (_defendantLoadError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _loadDefendants,
                            child: const Text('Retry'),
                          ),
                        ),
                      ),
                    Space.vertical(16),
                    Text("You want to post", style: context.normal),
                    Space.vertical(8),
                    if (_isLoadingViewCategories)
                      Text(
                        'Loading post visibility options...',
                        style: context.normal.copyWith(color: kDarkGreyColor),
                      )
                    else
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: _viewCategories.map((option) {
                          final value = option.paramValue;
                          return SizedBox(
                            width: (screenWidth - 44) / 2,
                            child: PlainSelectionWidget(
                              onChange: () => _togglePostVisibility(value),
                              isSelected: _selectedViewCategory == value,
                              title: option.paramLabel,
                              subTitle: "",
                            ),
                          );
                        }).toList(),
                      ),
                    if (_viewCategoryLoadError != null)
                      _buildInlineError(_viewCategoryLoadError!),
                    if (_viewCategoryLoadError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _loadViewCategories,
                            child: const Text('Retry'),
                          ),
                        ),
                      ),
                    if (_hasTriedSubmit && !_hasPostVisibilitySelection)
                      _buildInlineError('Please select post visibility'),
                    Space.vertical(16),
                    Text("Post publicly available", style: context.normal),
                    Space.vertical(8),
                    if (_isLoadingAvailabilityTypes)
                      Text(
                        'Loading availability options...',
                        style: context.normal.copyWith(color: kDarkGreyColor),
                      )
                    else
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: _availabilityTypes.map((option) {
                          final value = option.paramValue;
                          return SizedBox(
                            width: (screenWidth - 52) / 3,
                            child: PlainSelectionWidget(
                              onChange: () => _toggleAvailability(value),
                              isSelected: _selectedAvailabilityType == value,
                              title: option.paramLabel,
                              subTitle: "",
                            ),
                          );
                        }).toList(),
                      ),
                    if (_availabilityTypeLoadError != null)
                      _buildInlineError(_availabilityTypeLoadError!),
                    if (_availabilityTypeLoadError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _loadAvailabilityTypes,
                            child: const Text('Retry'),
                          ),
                        ),
                      ),
                    if (_hasTriedSubmit && !_hasAvailabilitySelection)
                      _buildInlineError('Please select availability duration'),
                    Space.vertical(16),
                    DottedBorder(
                      options: RectDottedBorderOptions(
                        color: kPrimaryColor,
                        dashPattern: [5, 5],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              SvgPicture.asset(Assets.svgMusicIcon),
                              Space.vertical(15),
                              Text(
                                "Attach video and audio Max 3 min length",
                                style: context.normal.copyWith(
                                  color: kPrimaryColor,
                                ),
                              ),
                              if (_selectedAttachmentName != null) ...[
                                Space.vertical(12),
                                Text(
                                  _selectedAttachmentName!,
                                  textAlign: TextAlign.center,
                                  style: context.normal.copyWith(
                                    color: AppColors.blackColor,
                                  ),
                                ),
                              ],
                              if (_attachmentMetaId != null) ...[
                                Space.vertical(8),
                                Text(
                                  'Meta ID: $_attachmentMetaId',
                                  textAlign: TextAlign.center,
                                  style: context.normal.copyWith(
                                    color: kPrimaryColor,
                                  ),
                                ),
                              ],
                              if (_attachmentError != null) ...[
                                Space.vertical(8),
                                Text(
                                  _attachmentError!,
                                  textAlign: TextAlign.center,
                                  style: context.normal.copyWith(
                                    color: kRedColor,
                                  ),
                                ),
                              ],
                              Space.vertical(15),
                              PrimaryButton(
                                height: 40,
                                isMainAxisSizeMin: true,
                                text: _isUploadingAttachment
                                    ? "Uploading..."
                                    : "Browse files",
                                buttonColor: kWhiteColor,
                                textColor: kBlackColor,
                                showBorder: true,
                                prefixIcon: Icon(Icons.attach_file),
                                borderColor: kPrimaryColor,
                                processing: _isUploadingAttachment,
                                inactive: _isUploadingAttachment,
                                onPressed: _showAttachmentPicker,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Space.vertical(16),
                    Text(
                      "Terms and conditions",
                      style: context.bold.copyWith(fontSize: 18),
                    ),
                    Space.vertical(10),
                    Text(
                      "By uploading a file, you confirm that you own the rights to the content or have permission to share it. The app is not responsible for any unauthorized, harmful, or illegal files uploaded by users. Inappropriate files may be removed and accounts suspended.",
                    ),
                    Space.vertical(6),
                    PlainSelectionWidget(
                      onChange: () {
                        setState(() {
                          isMarkAsRead = !isMarkAsRead;
                        });
                      },
                      isSelected: isMarkAsRead,
                      title: "Mark as read",
                      subTitle: "",
                    ),
                    if (_hasTriedSubmit && !isMarkAsRead)
                      _buildInlineError('Accept terms and condition first'),
                    Space.vertical(20),
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            text: "Clear",
                            showBorder: true,
                            buttonColor: kWhiteColor,
                            borderColor: kGreyColor,
                            textColor: kBlackColor,
                            onPressed: _clearForm,
                          ),
                        ),
                        Space.horizontal(10),
                        Expanded(
                          child: PrimaryButton(
                            text: "Upload Case",
                            processing: _isSubmittingCase,
                            inactive: _isSubmittingCase,
                            onPressed: _submitForm,
                          ),
                        ),
                      ],
                    ),
                    Space.vertical(20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
