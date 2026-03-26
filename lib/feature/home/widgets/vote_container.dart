import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class VotingResultExample extends StatelessWidget {
  final String leftLabel;
  final String leftText;
  final String rightLabel;
  final String rightText;
  final VoidCallback? onLeftTap;
  final VoidCallback? onRightTap;
  final bool isSubmitting;
  final String? selectedOption;
  final int leftVotes;
  final int rightVotes;

  const VotingResultExample({
    super.key,
    this.leftLabel = 'A.',
    this.leftText = 'Dennis Callis',
    this.rightLabel = 'B.',
    this.rightText = 'Katie Sims',
    this.onLeftTap,
    this.onRightTap,
    this.isSubmitting = false,
    this.selectedOption,
    this.leftVotes = 0,
    this.rightVotes = 0,
  });

  @override
  Widget build(BuildContext context) {
    final totalVotes = leftVotes + rightVotes;
    final leftProgress = totalVotes == 0 ? 0.0 : leftVotes / totalVotes;
    final rightProgress = totalVotes == 0 ? 0.0 : rightVotes / totalVotes;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildVoteOption(
            label: leftLabel,
            text: leftText,
            progress: leftProgress,
            isSelected: selectedOption == 'owner',
            isWinner: leftVotes > rightVotes,
            onTap: onLeftTap,
          ),
        ),
        SizedBox(width: 1.w),
        Expanded(
          child: _buildVoteOption(
            label: rightLabel,
            text: rightText,
            progress: rightProgress,
            isSelected: selectedOption == 'defendant',
            isWinner: rightVotes > leftVotes,
            onTap: onRightTap,
          ),
        ),
      ],
    );
  }

  Widget _buildVoteOption({
    required String label,
    required String text,
    required double progress,
    required bool isSelected,
    required bool isWinner,
    required VoidCallback? onTap,
  }) {
    final isActive = isSelected || isWinner;
    final fillColor = isActive
        ? const Color(0xFF007BFF)
        : const Color(0xFF007BFF).withValues(alpha: 0.18);
    final borderColor = isActive ? const Color(0xFF007BFF) : Colors.black26;
    final foregroundColor = isActive ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: isSubmitting ? null : onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final fillWidth = constraints.maxWidth * progress;

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Positioned.fill(child: Container(color: Colors.white)),
                  if (fillWidth > 0)
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      width: fillWidth,
                      child: Container(color: fillColor),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Row(
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            color: foregroundColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          ),
                        ] else if (isSubmitting && isActive) ...[
                          const SizedBox(width: 6),
                          const SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                        ],
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            text,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: foregroundColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
