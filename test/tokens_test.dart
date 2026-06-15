import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  group('MitumbaColors', () {
    test('brand green is #3D9A52', () {
      expect(MitumbaColors.green, const Color(0xFF3D9A52));
    });

    test('primary is alias for green', () {
      expect(MitumbaColors.primary, MitumbaColors.green);
    });

    test('earth is #A06235', () {
      expect(MitumbaColors.earth, const Color(0xFFA06235));
    });
  });

  group('MitumbaTypography', () {
    test('font family is Nunito', () {
      expect(MitumbaTypography.fontFamily, 'Nunito');
    });

    test('h1 uses display size and extrabold', () {
      expect(MitumbaTypography.h1.fontSize, 32);
      expect(MitumbaTypography.h1.fontWeight, FontWeight.w800);
    });
  });

  group('MitumbaSpacing', () {
    test('scale matches web tokens', () {
      expect(MitumbaSpacing.xs, 4);
      expect(MitumbaSpacing.base, 12);
      expect(MitumbaSpacing.lg, 16);
      expect(MitumbaSpacing.huge, 48);
    });
  });

  group('MitumbaRadius', () {
    test('md is 8', () {
      expect(MitumbaRadius.md, 8);
    });

    test('full is 9999', () {
      expect(MitumbaRadius.full, 9999);
    });
  });

  group('MitumbaShadows', () {
    test('card has 2 box shadows', () {
      expect(MitumbaShadows.card.length, 2);
    });
  });

  group('MitumbaMotion', () {
    test('fast is 150ms', () {
      expect(MitumbaMotion.fast, const Duration(milliseconds: 150));
    });
  });

  group('MitumbaTheme', () {
    test('light theme uses green as primary', () {
      final theme = MitumbaTheme.light;
      expect(theme.colorScheme.primary, MitumbaColors.green);
    });
  });
}
