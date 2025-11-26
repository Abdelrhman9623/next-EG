# Localization Setup

This app supports multiple languages: **English** and **Arabic** with full RTL (Right-to-Left) support.

## Configuration

### Supported Languages
- English (en) - Default
- Arabic (ar) - RTL support

### Files Structure
```
lib/
├── l10n/
│   ├── app_en.arb          # English translations
│   ├── app_ar.arb          # Arabic translations
│   └── app_localizations.dart  # Generated file (auto-generated)
└── core/
    └── localization/
        └── app_localization.dart  # Helper utilities
```

## Usage

### 1. Using Translations in Widgets

```dart
import 'package:next_app/l10n/app_localizations.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Text(l10n.welcome); // "Welcome" or "مرحباً"
  }
}
```

### 2. Available Translation Keys

From `app_en.arb` and `app_ar.arb`:
- `appTitle` - Application title
- `welcome` - Welcome message
- `hello` - Hello greeting
- `loading` - Loading text
- `error` - Error message
- `retry` - Retry button
- `cancel` - Cancel button
- `ok` - OK button
- `save` - Save button
- `delete` - Delete button
- `edit` - Edit button

### 3. Adding New Translations

1. **Add to English file** (`lib/l10n/app_en.arb`):
```json
{
  "newKey": "New Translation",
  "@newKey": {
    "description": "Description of the translation"
  }
}
```

2. **Add to Arabic file** (`lib/l10n/app_ar.arb`):
```json
{
  "newKey": "ترجمة جديدة"
}
```

3. **Regenerate**:
```bash
flutter gen-l10n
```

4. **Use in code**:
```dart
Text(AppLocalizations.of(context)!.newKey)
```

### 4. Changing Language Programmatically

```dart
import 'package:flutter/material.dart';
import 'package:next_app/core/localization/app_localization.dart';

// Change to Arabic
final newLocale = const Locale('ar', '');
MaterialApp(
  locale: newLocale,
  // ... other config
);

// Change to English
final newLocale = const Locale('en', '');
```

### 5. Detecting Current Language

```dart
final locale = Localizations.localeOf(context);
final isArabic = locale.languageCode == 'ar';
final isRTL = AppLocalization.isRTL(locale);
```

### 6. RTL Support

RTL is automatically handled:
- Text direction switches automatically
- Widgets align correctly for Arabic
- Icons and layouts mirror appropriately

### 7. Using in Cubit/Bloc

```dart
class MyCubit extends Cubit<MyState> {
  void showMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Use l10n.welcome, l10n.error, etc.
  }
}
```

## Best Practices

1. **Always use translations** - Don't hardcode strings
2. **Add descriptions** - Help translators understand context
3. **Keep keys descriptive** - Use clear, meaningful key names
4. **Test both languages** - Verify RTL layout works correctly
5. **Regenerate after changes** - Run `flutter gen-l10n` after editing ARB files

## Example: Language Switcher

```dart
class LanguageSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    
    return DropdownButton<Locale>(
      value: currentLocale,
      items: [
        DropdownMenuItem(
          value: const Locale('en', ''),
          child: Text('English'),
        ),
        DropdownMenuItem(
          value: const Locale('ar', ''),
          child: Text('العربية'),
        ),
      ],
      onChanged: (locale) {
        if (locale != null) {
          // Update app locale (you'll need a state management solution)
          // For example, using a provider or bloc
        }
      },
    );
  }
}
```

## Notes

- Generated files are in `.dart_tool/flutter_gen/gen_l10n/` (don't edit manually)
- ARB files are the source of truth
- Always run `flutter gen-l10n` after editing ARB files
- RTL support is automatic - no extra code needed

