#!/bin/bash

# Check for dialog
if ! command -v dialog >/dev/null 2>&1; then
    echo "Installing 'dialog'..."
    if command -v pacman >/dev/null 2>&1; then
        sudo pacman -Sy --noconfirm dialog
    elif command -v apt >/dev/null 2>&1; then
        sudo apt update && sudo apt install -y dialog
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y dialog
    else
        echo "Unsupported package manager. Please install 'dialog' manually."
        exit 1
    fi
fi

START_DIR="${1:-$HOME}"
SHOW_HIDDEN=false

show_menu() {
    local dir="$1"
    local hidden_flag=$([[ "$SHOW_HIDDEN" == true ]] && echo "-A" || echo "")
    local files=()

    while IFS= read -r line; do
        files+=("$line" "")
    done < <(ls -1 $hidden_flag "$dir")

    files+=(".." "Go up")
    files+=("__cd__" "Change Directory")
    files+=("__quit__" "Exit")

    local choice
    choice=$(dialog --clear --title "📁 Packmana File Browser" \
        --menu "Directory: $dir" 20 60 15 "${files[@]}" 2>&1 >/dev/tty)

    echo "$choice"
}

file_browser() {
    local cwd="$START_DIR"
    
    while true; do
        choice=$(show_menu "$cwd")
        [[ -z "$choice" ]] && break

        if [[ "$choice" == "__quit__" ]]; then
            break
        elif [[ "$choice" == ".." ]]; then
            cwd=$(dirname "$cwd")
            continue
        elif [[ "$choice" == "__cd__" ]]; then
            newdir=$(dialog --inputbox "Enter new directory path:" 10 60 "$cwd" 3>&1 1>&2 2>&3)
            if [ -d "$newdir" ]; then
                cwd="$newdir"
            else
                dialog --msgbox "Invalid directory!" 6 40
            fi
            continue
        fi

        path="$cwd/$choice"

        if [ -d "$path" ]; then
            cwd="$path"
        elif [ -f "$path" ]; then
            dialog --textbox "$path" 30 100
        fi

        action=$(dialog --no-cancel --menu "Action on $choice" 20 50 10 \
            "Open" "View File" \
            "Copy" "Copy File" \
            "Move" "Move File" \
            "Rename" "Rename File" \
            "Delete" "Delete File" \
            "Back" "Go back" \
            "NewDir" "Make New Directory" \
            "ToggleHidden" "Toggle hidden files" \
            3>&1 1>&2 2>&3)

        case $action in
            Open)
                dialog --textbox "$path" 30 100
                ;;
            Copy)
                dest=$(dialog --inputbox "Copy to:" 10 60 "$cwd/" 3>&1 1>&2 2>&3)
                cp "$path" "$dest"
                ;;
            Move)
                dest=$(dialog --inputbox "Move to:" 10 60 "$cwd/" 3>&1 1>&2 2>&3)
                mv "$path" "$dest"
                ;;
            Rename)
                newname=$(dialog --inputbox "New name:" 10 60 "$choice" 3>&1 1>&2 2>&3)
                mv "$path" "$cwd/$newname"
                ;;
            Delete)
                rm -i "$path"
                ;;
            Back)
                ;;
            NewDir)
                dirname=$(dialog --inputbox "New folder name:" 10 60 "" 3>&1 1>&2 2>&3)
                mkdir -p "$cwd/$dirname"
                ;;
            ToggleHidden)
                SHOW_HIDDEN=$([[ "$SHOW_HIDDEN" == true ]] && echo false || echo true)
                ;;
        esac
    done
    clear
}

file_browser
