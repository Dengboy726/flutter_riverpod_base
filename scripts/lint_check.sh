#!/bin/bash

# Flutter Linter Compliance Check Script
# This script ensures all linter warnings are eliminated

set -e

echo "🔍 Running Flutter Linter Compliance Check..."
echo "=============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_status $RED "❌ Flutter is not installed or not in PATH"
    exit 1
fi

# Check Flutter version
print_status $YELLOW "📱 Flutter Version:"
flutter --version

echo ""
print_status $YELLOW "🔧 Running Flutter Analyze..."
echo ""

# Run flutter analyze with detailed output
if flutter analyze --verbose; then
    print_status $GREEN "✅ All linter checks passed! No warnings found."
else
    print_status $RED "❌ Linter warnings found! Please fix them before committing."
    echo ""
    print_status $YELLOW "💡 Common fixes:"
    echo "   • Remove unused imports: dart fix --apply"
    echo "   • Format code: flutter format ."
    echo "   • Check specific file: flutter analyze <file_path>"
    exit 1
fi

echo ""
print_status $YELLOW "🎨 Running Code Formatting Check..."
echo ""

# Check if code is properly formatted
if flutter format --dry-run --set-exit-if-changed .; then
    print_status $GREEN "✅ Code formatting is correct!"
else
    print_status $YELLOW "⚠️  Code formatting issues found. Running auto-format..."
    flutter format .
    print_status $GREEN "✅ Code has been auto-formatted!"
fi

echo ""
print_status $YELLOW "🔧 Running Dart Fix..."
echo ""

# Run dart fix to auto-fix common issues
if dart fix --dry-run | grep -q "No fixes available"; then
    print_status $GREEN "✅ No auto-fixable issues found!"
else
    print_status $YELLOW "🔧 Auto-fixing common issues..."
    dart fix --apply
    print_status $GREEN "✅ Auto-fixes applied!"
fi

echo ""
print_status $GREEN "🎉 All linter compliance checks passed!"
print_status $GREEN "✅ Code is ready for commit!"
echo ""

# Optional: Run additional quality checks
if command -v dart_code_metrics &> /dev/null; then
    print_status $YELLOW "📊 Running Additional Code Metrics..."
    echo ""
    dart pub global activate dart_code_metrics
    metrics lib --reporter=console --reporter=html --output-directory=metrics_report
    print_status $GREEN "✅ Code metrics report generated in metrics_report/"
fi

echo ""
print_status $GREEN "🚀 Ready to commit your changes!"
