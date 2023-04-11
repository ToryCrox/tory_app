import 'package:common/common.dart';
import 'package:flutter/material.dart';

import 'alloo_gradient_button.dart';
import 'multi_data_picker_widget.dart';

class AllooPickerDialog extends StatefulWidget {
  final MultiDataPickerAdapter adapter;
  final String? title;
  final String? subtitle;
  final Widget? icon;
  final AlignmentGeometry? titleAlignment;
  final ConfirmChecker confirmChecker;

  static bool _defaultConfirmChecker() {
    return true;
  }

  const AllooPickerDialog({
    super.key,
    required this.adapter,
    this.icon,
    this.title,
    this.subtitle,
    this.titleAlignment,
    this.confirmChecker = _defaultConfirmChecker,
  });

  @override
  _AllooPickerDialogState createState() => _AllooPickerDialogState();

  static Future<SinglePickerItem?> showSinglePicker({
    required BuildContext context,
    required List<SinglePickerItem> items,
    int? selectedIndex,
    String? title,
    String? subtitle,
    Widget? icon,
  }) async {
    final adapter =
        SinglePickerAdapter(data: items, selectedIndex: selectedIndex);
    final result = await showModalBottomSheet<bool>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return AllooPickerDialog(
            adapter: adapter,
            title: title,
            subtitle: subtitle,
            icon: icon,
          );
        });
    if (result == true) {
      return adapter.getSelectedItem();
    }
    return null;
  }

  static Future<Pair<T, T>?> showTweenPicker<T>({
    required BuildContext context,
    required TweenRelationPickerAdapter<T> adapter,
    String? title,
    String? subtitle,
    Widget? icon,
    AlignmentGeometry? titleAlignment,
  }) async {
    final result = await showModalBottomSheet<bool>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return AllooPickerDialog(
            adapter: adapter,
            title: title,
            subtitle: subtitle,
            icon: icon,
            titleAlignment: titleAlignment,
            confirmChecker: adapter.isEnableConfirm,
          );
        });
    if (result == true && adapter.selectedSubItem != null) {
      return Pair(adapter.selectedMainItem, adapter.selectedSubItem!);
    }
    return null;
  }
}

class _AllooPickerDialogState extends State<AllooPickerDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        color: Colors.white,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            if (widget.icon != null)
              Container(
                width: 52,
                height: 32,
                margin: const EdgeInsetsDirectional.only(start: 20, bottom: 10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Color(0xFFF5F5F5),
                ),
                alignment: Alignment.center,
                child: widget.icon,
              ),
            if (widget.title != null)
              Container(
                padding: const EdgeInsetsDirectional.only(start: 20, end: 20),
                alignment: widget.titleAlignment ?? AlignmentDirectional.centerStart,
                child: Text(
                  widget.title ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF313131),
                  ),
                ),
              ),
            if (widget.subtitle != null)
              Container(
                padding: const EdgeInsetsDirectional.only(
                    start: 20, end: 20, top: 8),
                child: Text(
                  widget.subtitle ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF949494),
                  ),
                ),
              ),
            const SizedBox(height: 14),
            MultiPicker(
              controller: widget.adapter,
              height: 200,
              margin: const EdgeInsets.symmetric(horizontal: 16),
            ),
            const SizedBox(height: 20),
            AllooButton.gradient(
              text: '确定',
              margin: const EdgeInsets.symmetric(horizontal: 20),
              onTap: () {
                if (widget.confirmChecker()) {
                  Navigator.of(context).pop(true);
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

typedef ConfirmChecker = bool Function();
