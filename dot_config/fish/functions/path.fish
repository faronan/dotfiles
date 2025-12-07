# ===========================================
# Display PATH entries (Fish-native)
# ===========================================

function path --description "Display PATH entries, one per line"
    printf '%s\n' $PATH
end
