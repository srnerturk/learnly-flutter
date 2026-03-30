import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../models/create_session.dart';
import '../../providers/create_session_provider.dart';

class InputMethodStep extends ConsumerWidget {
  const InputMethodStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(createSessionProvider);
    final notifier = ref.read(createSessionProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('İçeriğini Nasıl Ekleyeceksin?',
              style: AppTextStyles.displayMedium),
          const Gap(6),
          Text('Öğrenmek istediğin materyali seç',
              style: AppTextStyles.bodyMedium),
          const Gap(24),
          _MethodSelector(
            selected: session.inputMethod,
            onSelect: (m) => notifier.setInputMethod(m),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            child: session.inputMethod != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: _InputArea(
                      key: ValueKey(session.inputMethod),
                      method: session.inputMethod!,
                      content: session.inputContent,
                      onContentChanged: notifier.setInputContent,
                    ).animate().fadeIn(duration: 250.ms).slideY(
                          begin: 0.06,
                          end: 0,
                          curve: Curves.easeOutCubic,
                        ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _MethodSelector extends StatelessWidget {
  final InputMethod? selected;
  final ValueChanged<InputMethod> onSelect;

  const _MethodSelector({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MethodChip(
                method: InputMethod.text,
                icon: Icons.text_fields_rounded,
                label: 'Metin Yapıştır',
                color: const Color(0xFF00CFFF),
                selected: selected == InputMethod.text,
                onTap: () => onSelect(InputMethod.text),
              ),
            ),
            const Gap(10),
            Expanded(
              child: _MethodChip(
                method: InputMethod.document,
                icon: Icons.description_rounded,
                label: 'Döküman Yükle',
                color: const Color(0xFFFF7A00),
                selected: selected == InputMethod.document,
                onTap: () => onSelect(InputMethod.document),
              ),
            ),
          ],
        ),
        const Gap(10),
        Row(
          children: [
            Expanded(
              child: _MethodChip(
                method: InputMethod.camera,
                icon: Icons.camera_alt_rounded,
                label: 'Kamera',
                color: const Color(0xFF00E676),
                selected: selected == InputMethod.camera,
                onTap: () => onSelect(InputMethod.camera),
              ),
            ),
            const Gap(10),
            Expanded(
              child: _MethodChip(
                method: InputMethod.gallery,
                icon: Icons.photo_library_rounded,
                label: 'Galeri',
                color: const Color(0xFFFFCC00),
                selected: selected == InputMethod.gallery,
                onTap: () => onSelect(InputMethod.gallery),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MethodChip extends StatelessWidget {
  final InputMethod method;
  final IconData icon;
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _MethodChip({
    required this.method,
    required this.icon,
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.12)
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? color : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? color : AppColors.textTertiary, size: 20),
            const Gap(8),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: selected ? color : AppColors.textSecondary,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputArea extends ConsumerWidget {
  final InputMethod method;
  final String? content;
  final ValueChanged<String> onContentChanged;

  const _InputArea({
    super.key,
    required this.method,
    required this.content,
    required this.onContentChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (method) {
      InputMethod.text => _TextInputArea(
          content: content,
          onChanged: onContentChanged,
        ),
      InputMethod.document => const _DocumentUploadArea(),
      InputMethod.camera => const _PhotoCaptureArea(isCamera: true),
      InputMethod.gallery => const _PhotoCaptureArea(isCamera: false),
    };
  }
}

class _TextInputArea extends StatefulWidget {
  final String? content;
  final ValueChanged<String> onChanged;

  const _TextInputArea({this.content, required this.onChanged});

  @override
  State<_TextInputArea> createState() => _TextInputAreaState();
}

class _TextInputAreaState extends State<_TextInputArea> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.content ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.text_snippet_rounded,
                size: 16, color: AppColors.primary),
            const Gap(6),
            Text('Metni Buraya Yapıştır', style: AppTextStyles.titleSmall),
          ],
        ),
        const Gap(10),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            controller: _controller,
            maxLines: 8,
            minLines: 5,
            onChanged: widget.onChanged,
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textPrimary, height: 1.6),
            decoration: InputDecoration(
              hintText:
                  'Öğrenmek istediğin metni buraya yapıştır...\n\nÖrn: Ders notları, makale, Wikipedia içeriği, blog yazısı vb.',
              hintStyle: AppTextStyles.bodyMedium.copyWith(height: 1.6),
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
        const Gap(8),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${_controller.text.length} karakter',
            style: AppTextStyles.labelSmall,
          ),
        ),
      ],
    );
  }
}

class _DocumentUploadArea extends StatelessWidget {
  const _DocumentUploadArea();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.upload_file_rounded,
                size: 16, color: Color(0xFF38BDF8)),
            const Gap(6),
            Text('Döküman Yükle', style: AppTextStyles.titleSmall),
          ],
        ),
        const Gap(10),
        GestureDetector(
          onTap: () {/* TODO: file picker */},
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 36),
            decoration: BoxDecoration(
            color: const Color(0xFFFF7A00).withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFFF7A00).withValues(alpha: 0.3),
              style: BorderStyle.solid,
              width: 1.5,
            ),
            ),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF7A00).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.description_rounded,
                      color: Color(0xFFFF7A00), size: 28),
                ),
                const Gap(12),
                Text('Dosya Seçmek İçin Dokun',
                    style: AppTextStyles.titleSmall
                        .copyWith(color: const Color(0xFFFF7A00))),
                const Gap(4),
                Text('PDF, DOCX, TXT desteklenir',
                    style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PhotoCaptureArea extends StatelessWidget {
  final bool isCamera;

  const _PhotoCaptureArea({required this.isCamera});

  @override
  Widget build(BuildContext context) {
    final color =
        isCamera ? const Color(0xFF00E676) : const Color(0xFFFFCC00);
    final icon =
        isCamera ? Icons.camera_alt_rounded : Icons.photo_library_rounded;
    final title = isCamera ? 'Fotoğraf Çek' : 'Galeriden Seç';
    final subtitle = isCamera
        ? 'Kamerayı aç ve sayfayı fotoğrafla'
        : 'Galerinizden bir görsel seçin';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const Gap(6),
            Text(title, style: AppTextStyles.titleSmall),
          ],
        ),
        const Gap(10),
        GestureDetector(
          onTap: () {/* TODO: image picker */},
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 36),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: color.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const Gap(12),
                Text(title,
                    style: AppTextStyles.titleSmall.copyWith(color: color)),
                const Gap(4),
                Text(subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
