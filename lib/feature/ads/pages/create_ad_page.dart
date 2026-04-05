import 'package:cctv_app/core/components/app_alert.dart';
import 'package:cctv_app/core/components/custom_textfield.dart';
import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/network/api_exception.dart';
import 'package:cctv_app/core/network/models/ads_category.dart';
import 'package:cctv_app/core/network/services/application_cloud_service.dart';
import 'package:cctv_app/core/network/services/ads_service.dart';
import 'package:cctv_app/core/storage/auth_storage.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateAdPage extends StatefulWidget {
  const CreateAdPage({super.key});

  @override
  State<CreateAdPage> createState() => _CreateAdPageState();
}

class _CreateAdPageState extends State<CreateAdPage> {
  final AdsService _adsService = AdsService();
  final ApplicationCloudService _applicationCloudService =
      const ApplicationCloudService();
  final TextEditingController _headingController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _coverPhotoController = TextEditingController();
  List<AdsCategory> _categories = const [];
  AdsCategory? _selectedCategory;
  bool _isLoadingCategories = false;
  String? _categoryError;
  bool _isUploadingCoverPhoto = false;
  String? _coverPhotoError;
  int? _coverPhotoMetaId;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _headingController.dispose();
    _noteController.dispose();
    _coverPhotoController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoadingCategories = true;
      _categoryError = null;
    });

    try {
      final accessToken = await const AuthStorage().readAccessToken();
      if (accessToken == null || accessToken.trim().isEmpty) {
        throw const ApiException('Session token not found');
      }

      final categories = await _adsService.getAdsCategory(
        accessToken: accessToken,
      );

      if (!mounted) return;
      setState(() {
        _categories = categories.where((category) => category.isActive).toList();
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _categoryError = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _categoryError = 'Failed to load ad categories';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoadingCategories = false;
      });
    }
  }

  AdsCategory? _findCategoryBySlug(String? slug) {
    if (slug == null) return null;
    for (final category in _categories) {
      if (category.slug == slug) {
        return category;
      }
    }
    return null;
  }

  Future<void> _pickCoverPhoto() async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(source: ImageSource.gallery);
      if (file == null || !mounted) return;

      final accessToken = await const AuthStorage().readAccessToken();
      if (accessToken == null || accessToken.trim().isEmpty) {
        throw const ApiException('Session token not found');
      }

      setState(() {
        _isUploadingCoverPhoto = true;
        _coverPhotoError = null;
        _coverPhotoController.text = 'Uploading image...';
      });

      final uploadedMedia = await _applicationCloudService.uploadImage(
        accessToken: accessToken,
        filePath: file.path,
        fileName: file.name,
        fileBytes: await file.readAsBytes(),
      );

      if (!mounted) return;
      setState(() {
        _coverPhotoMetaId = uploadedMedia.metaId;
        _coverPhotoController.text = file.name;
      });

      AppAlert.showSuccess(
        context,
        'Cover photo uploaded. Meta ID: ${uploadedMedia.metaId}',
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _coverPhotoError = e.message;
        _coverPhotoController.clear();
      });
      AppAlert.showError(context, e.message);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _coverPhotoError = 'Failed to upload cover photo';
        _coverPhotoController.clear();
      });
      AppAlert.showError(context, 'Failed to upload cover photo: $e');
    } finally {
      if (!mounted) return;
      setState(() {
        _isUploadingCoverPhoto = false;
      });
    }
  }

  void _clearForm() {
    setState(() {
      _selectedCategory = null;
      _coverPhotoMetaId = null;
      _coverPhotoError = null;
    });
    _headingController.clear();
    _noteController.clear();
    _coverPhotoController.clear();
  }

  Future<void> _submitAd() async {
    final title = _headingController.text.trim();
    final note = _noteController.text.trim();

    if (_selectedCategory == null) {
      AppAlert.showWarning(context, 'Please select a category');
      return;
    }
    if (title.isEmpty) {
      AppAlert.showWarning(context, 'Please enter ad title');
      return;
    }
    if (note.isEmpty) {
      AppAlert.showWarning(context, 'Please enter ad note');
      return;
    }
    if (_coverPhotoMetaId == null) {
      AppAlert.showWarning(context, 'Please upload a cover photo first');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final accessToken = await const AuthStorage().readAccessToken();
      if (accessToken == null || accessToken.trim().isEmpty) {
        throw const ApiException('Session token not found');
      }

      await _adsService.createAd(
        accessToken: accessToken,
        businessId: 0,
        categoryId: _selectedCategory!.id,
        title: title,
        note: note,
        destinationUrl: '',
        coverMetaId: _coverPhotoMetaId!,
        status: 'draft',
        rotationOrder: 1,
        displayIntervalSeconds: 30,
        isGlobal: true,
      );

      if (!mounted) return;
      AppAlert.showSuccess(context, 'Ad created successfully');
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      AppAlert.showError(context, e.message);
    } catch (e) {
      if (!mounted) return;
      AppAlert.showError(context, 'Failed to create ad: $e');
    } finally {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        title: const Text("Create new ads"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Select category", style: context.semiBold),
              Space.vertical(6),
              DropdownButtonFormField<String>(
                value: _selectedCategory?.slug,
                dropdownColor: kWhiteColor,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                ),
                hint: Text(
                  _isLoadingCategories ? "Loading..." : "Select",
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category.slug,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: _isLoadingCategories
                    ? null
                    : (value) {
                        setState(() {
                          _selectedCategory = _findCategoryBySlug(value);
                        });
                      },
              ),
              if (_categoryError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _categoryError!,
                          style: context.normal.copyWith(color: kRedColor),
                        ),
                      ),
                      TextButton(
                        onPressed: _loadCategories,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              Space.vertical(20),
              Text("Heading", style: context.semiBold),
              Space.vertical(10),
              CustomTextField(
                controller: _headingController,
                maxLine: 5,
                hintText: "Write heading",
              ),
              Space.vertical(20),
              Text("Important note", style: context.semiBold),
              Space.vertical(10),
              CustomTextField(
                controller: _noteController,
                maxLine: 5,
                hintText: "Write message",
              ),
              Space.vertical(20),
              Text("Upload cover photo", style: context.semiBold),
              Space.vertical(10),
              CustomTextField(
                controller: _coverPhotoController,
                hintText: _isUploadingCoverPhoto ? "Uploading..." : "Upload",
                readOnly: true,
                enabled: !_isUploadingCoverPhoto,
                onTap: _isUploadingCoverPhoto ? null : _pickCoverPhoto,
                suffix: _isUploadingCoverPhoto
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.attach_file),
              ),
              if (_coverPhotoError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _coverPhotoError!,
                    style: context.normal.copyWith(color: kRedColor),
                  ),
                ),
              if (_coverPhotoMetaId != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Stored cover photo meta_id: $_coverPhotoMetaId',
                    style: context.normal.copyWith(color: kDarkGreyColor),
                  ),
                ),
              Space.vertical(20),
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      text: "Clear",
                      textColor: kBlackColor,
                      borderColor: kPrimaryColor,
                      buttonColor: kWhiteColor,
                      showBorder: true,
                      onPressed: _isSubmitting ? () {} : _clearForm,
                      inactive: _isSubmitting || _isUploadingCoverPhoto,
                    ),
                  ),
                  Space.horizontal(10),
                  Expanded(
                    child: PrimaryButton(
                      text: "Boots now",
                      onPressed: _submitAd,
                      processing: _isSubmitting,
                      inactive: _isUploadingCoverPhoto,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
