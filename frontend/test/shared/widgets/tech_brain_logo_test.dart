import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/config/theme/app_colors.dart';
import 'package:techbrain/shared/widgets/tech_brain_logo.dart';

List<InlineSpan> _extractSpans(RichText text) {
  final TextSpan root = text.text as TextSpan;
  if (root.children?.length == 1 && root.children!.first is TextSpan) {
    final TextSpan inner = root.children!.first as TextSpan;
    if (inner.children != null && inner.children!.isNotEmpty) {
      return inner.children!;
    }
  }
  return root.children ?? <InlineSpan>[];
}

void main() {
  testWidgets('muestra la marca entre llaves', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: TechBrainLogo())),
    );

    final RichText text = tester.widget<RichText>(find.byType(RichText));
    expect(text.text.toPlainText(), '{tech/brain}');
  });

  testWidgets('pinta las llaves en lavanda y la palabra en texto principal', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: TechBrainLogo())),
    );

    final RichText text = tester.widget<RichText>(find.byType(RichText));
    final List<InlineSpan> spans = _extractSpans(text);
    expect(spans, hasLength(3));
    expect(spans[0].style!.color, AppColors.accentLavender);
    expect(spans[1].style!.color, AppColors.textMain);
    expect(spans[2].style!.color, AppColors.accentLavender);
  });

  testWidgets('se anuncia como TechBrain', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: TechBrainLogo())),
    );

    expect(find.bySemanticsLabel('TechBrain'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('respeta el fontSize recibido', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: TechBrainLogo(fontSize: 32))),
    );

    final RichText text = tester.widget<RichText>(find.byType(RichText));
    final List<InlineSpan> spans = _extractSpans(text);
    expect(spans[1].style!.fontSize, 32.0);
  });
}
