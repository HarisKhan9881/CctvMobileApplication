import 'package:cctv_app/core/components/search_bar_header.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/network/api_exception.dart';
import 'package:cctv_app/core/network/models/pending_case.dart';
import 'package:cctv_app/core/network/services/user_case_service.dart';
import 'package:cctv_app/core/storage/auth_storage.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/pending/widget/custom_case_container.dart';
import 'package:flutter/material.dart';

class PendingPage extends StatefulWidget {
  const PendingPage({super.key});

  @override
  State<PendingPage> createState() => _PendingPageState();
}

class _PendingPageState extends State<PendingPage> {
  bool _isLoading = true;
  String? _error;
  List<PendingCase> _pendingCases = const [];

  @override
  void initState() {
    super.initState();
    _loadPendingCases();
  }

  Future<void> _loadPendingCases() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final storage = const AuthStorage();
      final accessToken = await storage.readAccessToken();
      final userId = await storage.readUserId();

      if (accessToken == null || accessToken.trim().isEmpty || userId == null) {
        throw const ApiException('Session not found');
      }

      final cases = await UserCaseService().getPendingCases(
        accessToken: accessToken,
        userId: userId,
      );

      if (!mounted) return;
      setState(() {
        _pendingCases = cases;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to load pending cases';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchBarHeader(),
          Space.vertical(12),
          Text("Case Pending", style: context.bold.copyWith(fontSize: 24)),
          Space.vertical(20),
          Expanded(
            child: _buildBody(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: context.normal.copyWith(color: kRedColor),
            ),
            Space.vertical(8),
            TextButton(
              onPressed: _loadPendingCases,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_pendingCases.isEmpty) {
      return Center(
        child: Text(
          'No pending cases found',
          style: context.normal.copyWith(color: kDarkGreyColor),
        ),
      );
    }

    return GridView.builder(
      itemCount: _pendingCases.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        childAspectRatio: 0.56,
      ),
      itemBuilder: (context, index) {
        return CustomCaseContainer(
          pendingCase: _pendingCases[index],
        );
      },
    );
  }
}
