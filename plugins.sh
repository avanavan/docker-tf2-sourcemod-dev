#!/bin/bash

set -e

EXTERNAL_DIR="/external"
TF2_DIR="$HOME/hlserver/tf2/tf"
SOURCEMOD_DIR="$TF2_DIR/addons/sourcemod"

layer_directory() {
    local external_path="$1"
    local target_path="$2"
    
    [ ! -d "$external_path" ] && return
    [ ! "$(ls -A "$external_path" 2>/dev/null)" ] && return
    
    echo "Layering: $external_path -> $target_path"
    mkdir -p "$target_path"
    
    for file in "$external_path"/*; do
        if [ -e "$file" ]; then
            local filename=$(basename "$file")
            local target_file="$target_path/$filename"
            
            [ -L "$target_file" ] && rm "$target_file"
            ln -sf "$file" "$target_file"
        fi
    done
}

process_directory() {
    local external_path="$1"
    local dir_name=$(basename "$external_path")
    
    [ ! -d "$external_path" ] && return
    
    if [ "$dir_name" = "addons" ]; then
        for subdir in "$external_path"/*; do
            [ ! -d "$subdir" ] && continue
            local subdir_name=$(basename "$subdir")
            
            if [ "$subdir_name" = "sourcemod" ]; then
                for sm_subdir in "$subdir"/*; do
                    [ -d "$sm_subdir" ] && layer_directory "$sm_subdir" "$SOURCEMOD_DIR/$(basename "$sm_subdir")"
                done
            else
                layer_directory "$subdir" "$TF2_DIR/addons/$subdir_name"
            fi
        done
    else
        case "$dir_name" in
            plugins|configs|gamedata|extensions|translations|data|logs|scripting)
                layer_directory "$external_path" "$SOURCEMOD_DIR/$dir_name"
                ;;
            *)
                layer_directory "$external_path" "$TF2_DIR/$dir_name"
                ;;
        esac
    fi
}

if [ -d "$EXTERNAL_DIR" ]; then
    for external_path in "$EXTERNAL_DIR"/*; do
        [ -d "$external_path" ] && process_directory "$external_path"
    done
else
    echo "No external directory found at $EXTERNAL_DIR"
fi

