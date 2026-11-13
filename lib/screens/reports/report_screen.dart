import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riskapp/utils/constans/app_colors.dart';
import 'package:riskapp/utils/constans/app_fonts.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  static const List<String> _categories = [
    'Maintenance',
    'Electricity',
    'Cleaning',
    'Furniture',
    'Internet and Networks',
    'Other',
  ];

  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _category;

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  int get _completedFields {
    var count = 0;
    if (_titleController.text.trim().isNotEmpty) count++;
    if (_category != null) count++;
    if (_locationController.text.trim().isNotEmpty) count++;
    if (_descriptionController.text.trim().isNotEmpty) count++;
    return count;
  }

  void _sendReport() {
    // TODO: guardar el reporte en la base de datos
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Report sent')));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final canSend = _completedFields == 4;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado
              Row(
                children: [
                  _backButton(),
                  const SizedBox(width: 16),
                  Text(
                    'New report',
                    style: AppFonts.primary(
                      fontSize: 26,
                      fontWeight: AppColors.fontWeightMedium,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Formulario
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Brief explanation'),
                      _input(_titleController, 'Broken light in hallway'),
                      const SizedBox(height: 24),

                      _label('Category'),
                      _categoryGrid(),
                      const SizedBox(height: 24),

                      _label('Location'),
                      _input(_locationController, 'Building B, room 204'),
                      const SizedBox(height: 24),

                      _label('Description'),
                      _input(
                        _descriptionController,
                        'What happened, and since when?',
                        maxLines: 5,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Pie
              Text(
                '$_completedFields of 4 fields completed. '
                'All fields are required.',
                style: AppFonts.primary(
                  fontSize: 14,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: canSend ? _sendReport : null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.backgroundColor,
                    disabledForegroundColor: AppColors.backgroundColor
                        .withValues(alpha: 0.4),
                    side: BorderSide(
                      color: AppColors.backgroundColor.withValues(
                        alpha: canSend ? 1 : 0.4,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Send report',
                    style: AppFonts.primary(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _backButton() {
    return InkWell(
      onTap: () => context.pop(),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: const Icon(
          CupertinoIcons.chevron_back,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: AppFonts.primary(fontSize: 15, color: AppColors.textMuted),
      ),
    );
  }

  Widget _input(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: (_) => setState(() {}),
      style: AppFonts.primary(fontSize: 17, color: Colors.white),
      cursorColor: AppColors.backgroundColor,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppFonts.primary(fontSize: 17, color: AppColors.textMuted),
        filled: true,
        fillColor: AppColors.cardColor,
        contentPadding: const EdgeInsets.all(16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.backgroundColor),
        ),
      ),
    );
  }

  Widget _categoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        mainAxisExtent: 56,
      ),
      itemBuilder: (context, i) {
        final category = _categories[i];
        final selected = _category == category;
        return InkWell(
          onTap: () => setState(() => _category = category),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: selected
                    ? AppColors.backgroundColor
                    : AppColors.borderColor,
              ),
            ),
            child: Text(
              category,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppFonts.primary(
                fontSize: 16,
                color: selected ? AppColors.backgroundColor : Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
