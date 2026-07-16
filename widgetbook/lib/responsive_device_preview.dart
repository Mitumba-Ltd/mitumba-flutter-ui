import 'package:flutter/material.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

class ResponsiveDevicePreview extends StatelessWidget {
  const ResponsiveDevicePreview({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, BoxConstraints constraints) builder;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mobile Frame
          _DeviceFrame(
            title: 'Mobile (iPhone 13 - 390x844)',
            width: 390,
            height: 844,
            child: builder,
          ),
          const SizedBox(width: 32),
          // Tablet Frame
          _DeviceFrame(
            title: 'Tablet (iPad Air - 820x1180)',
            width: 820,
            height: 1180,
            child: builder,
          ),
          const SizedBox(width: 32),
          // Desktop Frame
          _DeviceFrame(
            title: 'Desktop (Laptop - 1280x800)',
            width: 1280,
            height: 800,
            child: builder,
          ),
        ],
      ),
    );
  }
}

class _DeviceFrame extends StatelessWidget {
  const _DeviceFrame({
    required this.title,
    required this.width,
    required this.height,
    required this.child,
  });

  final String title;
  final double width;
  final double height;
  final Widget Function(BuildContext context, BoxConstraints constraints) child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: MitumbaColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: MitumbaColors.divider, width: 4),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return child(context, constraints);
            },
          ),
        ),
      ],
    );
  }
}
