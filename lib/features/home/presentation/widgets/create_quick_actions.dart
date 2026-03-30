import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../create/models/create_session.dart';
import '../../../create/presentation/create_bottom_sheet.dart';

class CreateQuickActions extends StatelessWidget {
  const CreateQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text('Oluştur', style: AppTextStyles.titleLarge),
              const Spacer(),
              GestureDetector(
                onTap: () => showCreateBottomSheet(context),
                child: Text(
                  'Tümünü Gör →',
                  style: AppTextStyles.labelMedium
                      .copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        const Gap(14),
        SizedBox(
          height: 112,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: const [
              _ActionCard(
                icon: Icons.text_fields_rounded,
                label: 'Metin\nYapıştır',
                method: InputMethod.text,
              ),
              Gap(10),
              _ActionCard(
                icon: Icons.description_outlined,
                label: 'Döküman\nYükle',
                method: InputMethod.document,
              ),
              Gap(10),
              _ActionCard(
                icon: Icons.camera_alt_outlined,
                label: 'Kamera\nile Çek',
                method: InputMethod.camera,
              ),
              Gap(10),
              _ActionCard(
                icon: Icons.photo_library_outlined,
                label: 'Galeriden\nYükle',
                method: InputMethod.gallery,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final InputMethod method;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.method,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showCreateBottomSheet(context, initialMethod: method),
      child: Container(
        width: 104,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(icon, color: AppColors.textSecondary, size: 19),
            ),
            const Spacer(),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textPrimary,
                height: 1.35,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
