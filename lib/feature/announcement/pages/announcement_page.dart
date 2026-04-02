import 'dart:typed_data';

import 'package:cctv_app/core/components/app_alert.dart';
import 'package:cctv_app/core/components/admin_top_header.dart';
import 'package:cctv_app/core/components/custom_dropdown.dart';
import 'package:cctv_app/core/components/custom_textfield.dart';
import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/network/api_exception.dart';
import 'package:cctv_app/core/network/models/general_parameter_option.dart';
import 'package:cctv_app/core/network/services/admin_control_service.dart';
import 'package:cctv_app/core/network/services/application_cloud_service.dart';
import 'package:cctv_app/core/network/services/general_parameter_service.dart';
import 'package:cctv_app/core/storage/auth_storage.dart';
import 'package:cctv_app/core/theme/app_colors.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({super.key});

  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  static const _alertCategoryHeader = 'ALERT_CATEGORY_TYPE';
  final GeneralParameterService _generalParameterService =
      const GeneralParameterService();
  final AdminControlService _adminControlService = AdminControlService();
  final ApplicationCloudService _applicationCloudService =
      const ApplicationCloudService();
  final TextEditingController _attachmentController = TextEditingController();
  final TextEditingController _alertNoteController = TextEditingController();
  List<GeneralParameterOption> _categories = const [];
  String? _selectedCategory;
  bool _isLoadingCategories = false;
  bool _isUploadingAttachment = false;
  bool _isSubmittingAlert = false;
  String? _categoryLoadError;
  String? _attachmentError;
  int? _attachmentMetaId;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _attachmentController.dispose();
    _alertNoteController.dispose();
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
        throw const ApiException('Session token not found');
      }

      final categories = await _generalParameterService.getByHeaderName(
        headerName: _alertCategoryHeader,
        accessToken: accessToken,
      );

      if (!mounted) return;
      setState(() {
        _categories = categories;
        if (categories.isEmpty) {
          _categoryLoadError = 'No categories returned from API';
        }
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _categoryLoadError = e.message;
      });
      AppAlert.showError(context, e.message);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _categoryLoadError = 'Failed to load categories';
      });
      AppAlert.showError(context, 'Failed to load categories: $e');
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoadingCategories = false;
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(source: ImageSource.gallery);
      if (file == null || !mounted) return;
      final fileBytes = await file.readAsBytes();

      await _uploadSelectedImage(
        filePath: file.path,
        fileName: file.name,
        fileBytes: fileBytes,
      );
    } catch (e) {
      if (!mounted) return;
      AppAlert.showError(context, 'Failed to pick image from gallery: $e');
    }
  }

  Future<void> _uploadSelectedImage({
    required String filePath,
    required String fileName,
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

      final uploadedMedia = await _applicationCloudService.uploadImage(
        accessToken: accessToken,
        filePath: filePath,
        fileBytes: fileBytes,
        fileName: fileName,
      );

      if (!mounted) return;
      setState(() {
        _attachmentMetaId = uploadedMedia.metaId;
        _attachmentController.text = fileName;
      });

      AppAlert.showSuccess(context, 'Image uploaded successfully');
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _attachmentError = e.message;
      });
      AppAlert.showError(context, e.message);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _attachmentError = 'Failed to upload image';
      });
      AppAlert.showError(context, 'Failed to upload image: $e');
    } finally {
      if (!mounted) return;
      setState(() {
        _isUploadingAttachment = false;
      });
    }
  }

  String? _categoryInitial(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed.substring(0, 1).toUpperCase();
  }

  void _clearForm() {
    setState(() {
      _selectedCategory = null;
      _attachmentMetaId = null;
      _attachmentError = null;
    });
    _attachmentController.clear();
    _alertNoteController.clear();
  }

  Future<void> _submitAlert() async {
    final categoryInitial = _categoryInitial(_selectedCategory);
    final alertNote = _alertNoteController.text.trim();

    if (categoryInitial == null) {
      AppAlert.showWarning(context, 'Please select a category.');
      return;
    }
    if (alertNote.isEmpty) {
      AppAlert.showWarning(context, 'Please enter alert note.');
      return;
    }

    setState(() {
      _isSubmittingAlert = true;
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

      await _adminControlService.createApplicationAlert(
        accessToken: accessToken,
        createdBy: userId,
        category: categoryInitial,
        alertNote: alertNote,
        attachedMetaId: _attachmentMetaId ?? 0,
      );

      if (!mounted) return;
      _clearForm();
      AppAlert.showSuccess(context, 'Alert submitted successfully');
    } on ApiException catch (e) {
      if (!mounted) return;
      AppAlert.showError(context, e.message);
    } catch (e) {
      if (!mounted) return;
      AppAlert.showError(context, 'Failed to submit alert: $e');
    } finally {
      if (!mounted) return;
      setState(() {
        _isSubmittingAlert = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 350;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminTopHeader(),
            Space.vertical(20),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: kGreyColor),
                ),
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.history),
                    Space.horizontal(4),
                    Text("History", style: context.normal),
                  ],
                ),
              ),
            ),
            Space.vertical(10),
            Center(
              child: Text(
                "Send Alerts",
                style: context.bold.copyWith(fontSize: 24),
              ),
            ),
            Space.vertical(10),
            Text("Select Category", style: context.normal),
            Space.vertical(10),
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
                  : "Select category",
              screenWidth: screenWidth,
              isSmallScreen: isSmallScreen,
              isSearchable: true,
              openSearchInPopup: true,
              searchHintText: "Search category",
              enabled: !_isLoadingCategories && _categoryLoadError == null,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            if (_categoryLoadError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    _categoryLoadError!,
                    style: const TextStyle(color: kRedColor, fontSize: 12),
                  ),
                ),
              ),
            if (_categoryLoadError != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _loadCategories,
                    child: const Text('Retry'),
                  ),
                ),
              ),
            Space.vertical(20),
            Text("Important Note", style: context.normal),
            Space.vertical(10),
            CustomTextField(
              controller: _alertNoteController,
              hintText: "Write message",
              hintTextColor: kDarkGreyColor,
              maxLine: 6,
            ),
            Space.vertical(20),
            Text("IAttached file (Optional)", style: context.normal),
            Space.vertical(10),
            CustomTextField(
              controller: _attachmentController,
              hintText: _isUploadingAttachment
                  ? "Uploading image..."
                  : "Tap to upload image",
              hintTextColor: kDarkGreyColor,
              readOnly: true,
              enabled: !_isUploadingAttachment,
              onTap: _isUploadingAttachment ? null : _pickImageFromGallery,
              suffix: _isUploadingAttachment
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.attach_file),
            ),
            if (_attachmentError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    _attachmentError!,
                    style: const TextStyle(color: kRedColor, fontSize: 12),
                  ),
                ),
              ),
            Space.vertical(20),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    text: "Clear",
                    buttonColor: kWhiteColor,
                    textColor: kBlackColor,
                    borderColor: kGreyColor,
                    showBorder: true,
                    onPressed: _clearForm,
                  ),
                ),
                Space.horizontal(10),
                Expanded(
                  child: PrimaryButton(
                    text: "Submit",
                    onPressed: _submitAlert,
                    processing: _isSubmittingAlert,
                    inactive: _isUploadingAttachment,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
