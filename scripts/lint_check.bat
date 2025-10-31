@echo off
REM Flutter Linter Compliance Check Script for Windows
REM This script ensures all linter warnings are eliminated

echo 🔍 Running Flutter Linter Compliance Check...
echo ==============================================

REM Check if Flutter is installed
where flutter >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo ❌ Flutter is not installed or not in PATH
    exit /b 1
)

REM Check Flutter version
echo 📱 Flutter Version:
flutter --version

echo.
echo 🔧 Running Flutter Analyze...
echo.

REM Run flutter analyze
flutter analyze --verbose
if %ERRORLEVEL% neq 0 (
    echo ❌ Linter warnings found! Please fix them before committing.
    echo.
    echo 💡 Common fixes:
    echo    • Remove unused imports: dart fix --apply
    echo    • Format code: flutter format .
    echo    • Check specific file: flutter analyze ^<file_path^>
    exit /b 1
) else (
    echo ✅ All linter checks passed! No warnings found.
)

echo.
echo 🎨 Running Code Formatting Check...
echo.

REM Check if code is properly formatted
flutter format --dry-run --set-exit-if-changed .
if %ERRORLEVEL% neq 0 (
    echo ⚠️  Code formatting issues found. Running auto-format...
    flutter format .
    echo ✅ Code has been auto-formatted!
) else (
    echo ✅ Code formatting is correct!
)

echo.
echo 🔧 Running Dart Fix...
echo.

REM Run dart fix to auto-fix common issues
dart fix --dry-run | findstr "No fixes available" >nul
if %ERRORLEVEL% neq 0 (
    echo 🔧 Auto-fixing common issues...
    dart fix --apply
    echo ✅ Auto-fixes applied!
) else (
    echo ✅ No auto-fixable issues found!
)

echo.
echo 🎉 All linter compliance checks passed!
echo ✅ Code is ready for commit!
echo.

REM Optional: Run additional quality checks
where dart_code_metrics >nul 2>nul
if %ERRORLEVEL% equ 0 (
    echo 📊 Running Additional Code Metrics...
    echo.
    dart pub global activate dart_code_metrics
    metrics lib --reporter=console --reporter=html --output-directory=metrics_report
    echo ✅ Code metrics report generated in metrics_report/
)

echo.
echo 🚀 Ready to commit your changes!
