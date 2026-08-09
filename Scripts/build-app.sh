#!/bin/zsh
set -euo pipefail

project_dir="${0:A:h:h}"
app_dir="$project_dir/dist/BTerm.app"

cd "$project_dir"
swift build -c release

mkdir -p "$app_dir/Contents/MacOS" "$app_dir/Contents/Resources"
cp "$project_dir/.build/release/BTerm" "$app_dir/Contents/MacOS/BTerm"
/usr/bin/ditto \
    "$project_dir/.build/release/SwiftTerm_SwiftTerm.bundle" \
    "$app_dir/Contents/Resources/SwiftTerm_SwiftTerm.bundle"

sed "s/@VERSION@/0.1.0/g" "$project_dir/Resources/Info.plist.in" > "$app_dir/Contents/Info.plist"
chmod -R u+w "$app_dir"
xattr -cr "$app_dir"
codesign --force --deep --sign - "$app_dir"

echo "Built $app_dir"
