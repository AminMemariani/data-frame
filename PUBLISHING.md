# Publishing data_frame to pub.dev

## Package Information

- **Package Name**: `data_frame`
- **Version**: 1.0.0
- **Repository**: https://github.com/AminMemariani/data-frame
- **License**: MIT

## Pre-Publication Checklist

✅ **Package validated** - All pub.dev requirements met  
✅ **Tests passing** - 87/87 tests (100%)  
✅ **Code quality** - Zero analyzer issues  
✅ **Documentation** - README, CHANGELOG, LICENSE, TEST_COVERAGE  
✅ **Git state** - All changes committed  
✅ **Repository URLs** - Updated to correct GitHub repo  
✅ **Code cleanup** - Removed pandas-specific terminology from code docs  

## How to Publish

### Step 1: Run the publish command

```bash
dart pub publish
```

### Step 2: Review the package contents

The command will show you what will be published:
- Source code (lib/)
- Tests (test/)
- Documentation (README.md, CHANGELOG.md, LICENSE)
- Configuration (pubspec.yaml)
- Example (bin/dadata.dart)

Total size: ~35 KB

### Step 3: Confirm publication

When prompted:
```
Do you want to publish data_frame 1.0.0 to https://pub.dev (y/N)?
```

Type `y` and press Enter.

### Step 4: Authenticate

A browser window will open asking you to:
1. Sign in with your Google account
2. Authorize pub.dev to publish packages on your behalf
3. Complete the OAuth flow

### Step 5: Success!

Once authenticated and uploaded, you'll see:
```
Successfully uploaded package.
```

Your package will be live at: **https://pub.dev/packages/data_frame**

## After Publishing

### Package will be available via:

**Command line installation:**
```bash
dart pub add data_frame
# or
flutter pub add data_frame
```

**Manual installation:**
```yaml
dependencies:
  data_frame: ^1.0.0
```

**Import in code:**
```dart
import 'package:data_frame/data_frame.dart';
```

### Package Listing

Your package will appear on pub.dev with:
- Pub Points score (based on quality metrics)
- Popularity score (based on downloads)
- Like count
- All your badges and documentation

### Verification

After publishing, verify at:
- Main page: https://pub.dev/packages/data_frame
- Documentation: https://pub.dev/documentation/data_frame/latest/
- Versions: https://pub.dev/packages/data_frame/versions
- Changelog: https://pub.dev/packages/data_frame/changelog

## Known Validation Warnings

The `dart pub publish` dry-run may show analyzer warnings about the bin/ directory. This is a **false positive** that can be safely ignored:

- ✅ The code runs correctly (`dart run bin/dadata.dart` works)
- ✅ Regular `dart analyze` shows no issues
- ✅ All tests pass

These warnings don't prevent publication and won't affect your package score.

## Important Notes

⚠️ **Publishing is permanent**
- Once published, a version cannot be unpublished
- You can only mark it as discontinued
- You can publish new versions to fix issues

✅ **Version updates**
- After initial publication, you can publish updates
- Follow semantic versioning (MAJOR.MINOR.PATCH)
- Update CHANGELOG.md for each version

## Troubleshooting

If you encounter issues:

1. **Authentication fails**: Make sure you're signed in to pub.dev
2. **Package name taken**: The name `data_frame` should be available
3. **Validation errors**: Run `dart analyze` locally first
4. **Network issues**: Check your internet connection

## Post-Publication Tasks

1. **Push to GitHub**:
   ```bash
   git push origin main
   ```

2. **Create a release tag**:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

3. **Monitor package**:
   - Check pub points: https://pub.dev/packages/data_frame/score
   - Respond to issues on GitHub
   - Consider adding topics/tags on pub.dev

## Contact

For package issues, open an issue at:
https://github.com/AminMemariani/data-frame/issues

---

**Ready to publish? Run:** `dart pub publish`

