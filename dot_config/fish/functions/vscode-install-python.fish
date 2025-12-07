# Install VSCode Python extensions (Hybrid workflow)
# Reads from ~/.config/vscode-templates/python/extensions.json (source of truth)
# Extensions are installed but should be DISABLED globally.
#
# Usage: vscode-install-python

function vscode-install-python --description "Install Python extensions (disabled globally)"
    set -l json_file ~/.config/vscode-templates/python/extensions.json

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

    echo "Installing Python extensions..."
    echo "(Source: $json_file)"
    echo ""

    for ext in $extensions
        echo "  Installing $ext..."
        code --install-extension $ext --force 2>/dev/null
    end

    echo ""
    echo "=================================="
    echo "IMPORTANT: Hybrid Workflow"
    echo "=================================="
    echo ""
    echo "Installed "(count $extensions)" extensions."
    echo "These should be DISABLED globally, then ENABLED per workspace."
    echo ""
    echo "Step 1: Open VSCode → Extensions (Cmd+Shift+X)"
    echo "Step 2: For each extension: gear icon → Disable"
    echo "Step 3: In Python projects: gear icon → Enable (Workspace)"
end
