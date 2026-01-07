# ===========================================
# Display PATH entries (Fish-native)
# ===========================================

function show-path --description "Display PATH entries, one per line"
    printf '%s\n' $PATH
end
