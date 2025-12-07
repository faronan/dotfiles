# Initialize VSCode configuration for a project
# Usage: vscode-init-project [node|python|base]

function vscode-init-project --description "Initialize VSCode project configuration"
    set -l project_type $argv[1]
    set -l template_dir ~/.config/vscode-templates

    if test -z "$project_type"
        echo "Usage: vscode-init-project [node|python|base]"
        echo ""
        echo "Available templates:"
        echo "  base   - Common base extensions only"
        echo "  node   - Node.js/TypeScript project"
        echo "  python - Python project"
        return 1
    end

    if not test -d $template_dir/$project_type
        echo "Error: Unknown project type '$project_type'"
        echo "Available: base, node, python"
        return 1
    end

    # Create .vscode directory if not exists
    mkdir -p .vscode

    # Copy extensions.json
    if test -f .vscode/extensions.json
        echo "Warning: .vscode/extensions.json already exists"
        read -P "Overwrite? [y/N] " -l confirm
        if test "$confirm" != "y" -a "$confirm" != "Y"
            echo "Aborted."
            return 1
        end
    end

    cp $template_dir/$project_type/extensions.json .vscode/
    echo "Created .vscode/extensions.json for $project_type project"
    echo ""
    echo "Next steps:"
    echo "  1. Open this folder in VSCode"
    echo "  2. VSCode will prompt to install recommended extensions"
    echo "  3. Or run: vscode-install-$project_type"
end
