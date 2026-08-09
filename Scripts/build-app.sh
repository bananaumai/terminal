#!/bin/zsh
set -euo pipefail

project_dir="${0:A:h:h}"
app_dir="$project_dir/dist/tm.app"
iconset_dir="$project_dir/.build/tm.iconset"

cd "$project_dir"
swift build -c release

if [[ -d "$app_dir" ]]; then
    rm -rf "$app_dir"
fi
mkdir -p "$app_dir/Contents/MacOS" "$app_dir/Contents/Resources" "$iconset_dir"
cp "$project_dir/.build/release/tm" "$app_dir/Contents/MacOS/tm"
/usr/bin/ditto \
    "$project_dir/.build/release/SwiftTerm_SwiftTerm.bundle" \
    "$app_dir/Contents/Resources/SwiftTerm_SwiftTerm.bundle"

for size in 16 32 128 256 512; do
    retina_size=$((size * 2))
    sips -z "$size" "$size" "$project_dir/Resources/AppIcon.png" \
        --out "$iconset_dir/icon_${size}x${size}.png" >/dev/null
    sips -z "$retina_size" "$retina_size" "$project_dir/Resources/AppIcon.png" \
        --out "$iconset_dir/icon_${size}x${size}@2x.png" >/dev/null
done
iconutil -c icns "$iconset_dir" -o "$app_dir/Contents/Resources/AppIcon.icns"

sed "s/@VERSION@/0.1.0/g" "$project_dir/Resources/Info.plist.in" > "$app_dir/Contents/Info.plist"
chmod -R u+w "$app_dir"
xattr -cr "$app_dir"
codesign --force --deep --sign - "$app_dir"
xattr -cr "$app_dir"

echo "Built $app_dir"
