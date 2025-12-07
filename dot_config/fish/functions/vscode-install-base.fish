# Install VSCode common base extensions
# Reads from ~/.config/vscode-templates/base/extensions.json (source of truth)
#
# Usage: vscode-install-base

function vscode-install-base --description "Install VSCode common base extensions"
    set -l json_file ~/.config/vscode-templates/base/extensions.json

    if not test -f $json_file
        echo "Error: $json_file not found"
        return 1
    end

    # Parse JSON (strip comments with sed, extract with jq)
    set -l extensions (sed 's|//.*||g' $json_file | jq -r '.recommendations[]' 2>/dev/null)

    if test -z "$extensions"
        echo "Error: Failed to parse extensions from $json_file"
        return 1
    end

    echo "Installing VSCode common base extensions..."
    echo "(Source: $json_file)"
    echo ""

    for ext in $extensions
        echo "  Installing $ext..."
        code --install-extension $ext --force 2>/dev/null
    end

    echo ""
    echo "Done! Installed "(count $extensions)" extensions (globally enabled)."
end
