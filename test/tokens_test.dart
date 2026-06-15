import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  test('MitumbaColors.primary is brand green', () {
    expect(MitumbaColors.primary, const Color(0xFF3D9A52));
  });
}
