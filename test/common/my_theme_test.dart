import 'package:flutter_test/flutter_test.dart';
import 'package:code_streak/common/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  group('MyTheme.dark', () {
    final theme = MyTheme.dark();

    test('brightness is Brightness.dark', () {
      expect(theme.brightness, Brightness.dark);
    });

    test('scaffoldBackgroundColor is correct', () {
      expect(theme.scaffoldBackgroundColor, const Color(0xFF1A1C1E));
    });

    test('primaryColor is correct', () {
      expect(theme.primaryColor, const Color(0xFF75DD7B));
    });

    group('elevatedButtonTheme', () {
      final buttonTheme = theme.elevatedButtonTheme.style;

      test('backgroundColor is correct', () {
        expect(buttonTheme?.backgroundColor?.resolve({}), const Color(0xFF75DD7B));
      });

      test('foregroundColor is correct', () {
        expect(buttonTheme?.foregroundColor?.resolve({}), const Color(0xFF002105));
      });

      test('textStyle fontFamily is correct', () {
        expect(buttonTheme?.textStyle?.resolve({})?.fontFamily, GoogleFonts.spaceGrotesk().fontFamily);
      });

      test('shape is correct', () {
        expect(buttonTheme?.shape?.resolve({}), RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ));
      });
    });

    group('filledButtonTheme', () {
      final buttonTheme = theme.filledButtonTheme.style;

      test('backgroundColor is correct', () {
        expect(buttonTheme?.backgroundColor?.resolve({}), const Color(0xFF75DD7B));
      });

      test('foregroundColor is correct', () {
        expect(buttonTheme?.foregroundColor?.resolve({}), const Color(0xFF002105));
      });

      test('textStyle fontFamily is correct', () {
        expect(buttonTheme?.textStyle?.resolve({})?.fontFamily, GoogleFonts.spaceGrotesk().fontFamily);
      });

      test('shape is correct', () {
        expect(buttonTheme?.shape?.resolve({}), RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ));
      });
    });

    group('outlinedButtonTheme', () {
      final buttonTheme = theme.outlinedButtonTheme.style;

      test('foregroundColor is correct', () {
        expect(buttonTheme?.foregroundColor?.resolve({}), const Color(0xFF75DD7B));
      });

      test('textStyle fontFamily is correct', () {
        expect(buttonTheme?.textStyle?.resolve({})?.fontFamily, GoogleFonts.spaceGrotesk().fontFamily);
      });

      test('shape is correct', () {
        expect(buttonTheme?.shape?.resolve({}), RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ));
      });
    });

    group('textButtonTheme', () {
      final buttonTheme = theme.textButtonTheme.style;

      test('foregroundColor is correct', () {
        expect(buttonTheme?.foregroundColor?.resolve({}), const Color(0xFF75DD7B));
      });

      test('textStyle fontFamily is correct', () {
        expect(buttonTheme?.textStyle?.resolve({})?.fontFamily, GoogleFonts.spaceGrotesk().fontFamily);
      });

      test('shape is correct', () {
        expect(buttonTheme?.shape?.resolve({}), RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ));
      });
    });

    test('appBarTheme backgroundColor is correct', () {
      expect(theme.appBarTheme.backgroundColor, const Color(0xFF1A1C1E));
    });

    test('appBarTheme foregroundColor is correct', () {
      expect(theme.appBarTheme.foregroundColor, const Color(0xFFE2E3E4));
    });

    group('colorScheme', () {
      final colorScheme = theme.colorScheme;

      test('primary is correct', () {
        expect(colorScheme.primary, const Color(0xFF75DD7B));
      });

      test('secondary is correct', () {
        expect(colorScheme.secondary, const Color(0xFFB8CCB3));
      });

      test('surface is correct', () {
        expect(colorScheme.surface, const Color(0xFF1A1C1E));
      });

      test('error is correct', () {
        expect(colorScheme.error, const Color(0xFFFFB4AB));
      });

      test('onPrimary is correct', () {
        expect(colorScheme.onPrimary, const Color(0xFF00390D));
      });

      test('onSurface is correct', () {
        expect(colorScheme.onSurface, const Color(0xFFE2E3E4));
      });
    });
  });

  group('MyTheme.light', () {
    final theme = MyTheme.light();

    test('brightness is Brightness.light', () {
      expect(theme.brightness, Brightness.light);
    });

    test('scaffoldBackgroundColor is correct', () {
      expect(theme.scaffoldBackgroundColor, const Color(0xFFFDFDF5));
    });

    test('primaryColor is correct', () {
      expect(theme.primaryColor, const Color(0xFF006E25));
    });

    group('elevatedButtonTheme', () {
      final buttonTheme = theme.elevatedButtonTheme.style;

      test('backgroundColor is correct', () {
        expect(buttonTheme?.backgroundColor?.resolve({}), const Color(0xFF006E25));
      });

      test('foregroundColor is correct', () {
        expect(buttonTheme?.foregroundColor?.resolve({}), const Color(0xFFFFFFFF));
      });

      test('textStyle fontFamily is correct', () {
        expect(buttonTheme?.textStyle?.resolve({})?.fontFamily, GoogleFonts.spaceGrotesk().fontFamily);
      });

      test('shape is correct', () {
        expect(buttonTheme?.shape?.resolve({}), RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ));
      });
    });

    group('filledButtonTheme', () {
      final buttonTheme = theme.filledButtonTheme.style;

      test('backgroundColor is correct', () {
        expect(buttonTheme?.backgroundColor?.resolve({}), const Color(0xFF006E25));
      });

      test('foregroundColor is correct', () {
        expect(buttonTheme?.foregroundColor?.resolve({}), const Color(0xFFFFFFFF));
      });

      test('textStyle fontFamily is correct', () {
        expect(buttonTheme?.textStyle?.resolve({})?.fontFamily, GoogleFonts.spaceGrotesk().fontFamily);
      });

      test('shape is correct', () {
        expect(buttonTheme?.shape?.resolve({}), RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ));
      });
    });

    group('outlinedButtonTheme', () {
      final buttonTheme = theme.outlinedButtonTheme.style;

      test('foregroundColor is correct', () {
        expect(buttonTheme?.foregroundColor?.resolve({}), const Color(0xFF006E25));
      });

      test('textStyle fontFamily is correct', () {
        expect(buttonTheme?.textStyle?.resolve({})?.fontFamily, GoogleFonts.spaceGrotesk().fontFamily);
      });

      test('shape is correct', () {
        expect(buttonTheme?.shape?.resolve({}), RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ));
      });
    });

    group('textButtonTheme', () {
      final buttonTheme = theme.textButtonTheme.style;

      test('foregroundColor is correct', () {
        expect(buttonTheme?.foregroundColor?.resolve({}), const Color(0xFF006E25));
      });

      test('textStyle fontFamily is correct', () {
        expect(buttonTheme?.textStyle?.resolve({})?.fontFamily, GoogleFonts.spaceGrotesk().fontFamily);
      });

      test('shape is correct', () {
        expect(buttonTheme?.shape?.resolve({}), RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ));
      });
    });

    test('appBarTheme backgroundColor is correct', () {
      expect(theme.appBarTheme.backgroundColor, const Color(0xFFFDFDF5));
    });

    test('appBarTheme foregroundColor is correct', () {
      expect(theme.appBarTheme.foregroundColor, const Color(0xFF1A1C1E));
    });

    group('colorScheme', () {
      final colorScheme = theme.colorScheme;

      test('primary is correct', () {
        expect(colorScheme.primary, const Color(0xFF006E25));
      });

      test('secondary is correct', () {
        expect(colorScheme.secondary, const Color(0xFF52634F));
      });

      test('surface is correct', () {
        expect(colorScheme.surface, const Color(0xFFFDFDF5));
      });

      test('error is correct', () {
        expect(colorScheme.error, const Color(0xFFBA1A1A));
      });

      test('onPrimary is correct', () {
        expect(colorScheme.onPrimary, const Color(0xFFFFFFFF));
      });

      test('onSurface is correct', () {
        expect(colorScheme.onSurface, const Color(0xFF1A1C1E));
      });
    });
  });
}
