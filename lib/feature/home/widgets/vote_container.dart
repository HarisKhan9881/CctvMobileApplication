import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class VotingResultExample extends StatelessWidget {
  const VotingResultExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Example votes
    final int votesA = 72;
    final int votesB = 28;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildVoteOption(
            label: 'A.',
            text: 'Dennis Callis',
            isWinner: votesA > votesB,
          ),
        ),
        SizedBox(width: 1.w),
        Expanded(
          child: _buildVoteOption(
            label: 'B.',
            text: 'Katie Sims',
            isWinner: votesB > votesA,
          ),
        ),
      ],
    );
  }

  Widget _buildVoteOption({
    required String label,
    required String text,
    required bool isWinner,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isWinner ? const Color(0xFF007BFF) : Colors.black26,
          width: 1.5,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isWinner ? const Color(0xFF007BFF) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isWinner ? const Color(0xFF007BFF) : Colors.black26,
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: isWinner ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isWinner) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.check, size: 16, color: Colors.white),
                ],
              ],
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: isWinner ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
