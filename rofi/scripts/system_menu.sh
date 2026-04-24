#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# ARCH/HYPRLAND ROFI MENU SYSTEM
# Optimized for Bash 5+ | Dependencies: rofi-wayland, uwsm, kitty, hyprctl, fd, file
# -----------------------------------------------------------------------------

set -uo pipefail

# --- CONFIGURATION ---
readonly SCRIPTS_DIR="${HOME}/.config/rofi/scripts"
readonly HYPR_CONF="${HOME}/.config/hypr"
readonly HYPR_SOURCE="${HYPR_CONF}/source"
readonly SEARCH_DIR="${HOME}/Documents/pensive/linux"

readonly TERMINAL="kitty"
readonly EDITOR="${EDITOR:-nvim}"
readonly FILE_MANAGER="dolphin"

readonly ROFI_CMD=(
    rofi 
    -dmenu 
    -i 
    -theme-str 'window {width: 25%;} listview {lines: 12;}'
)

# --- CORE FUNCTIONS ---

menu() {
    local prompt="$1"
    local options="$2"
    local preselect="${3:-}"
    
    local cmd_args=("${ROFI_CMD[@]}" -p "$prompt")

    if [[ -n "$preselect" ]]; then
        local index
        index=$(printf "%b" "$options" | grep -nxF "$preselect" | cut -d: -f1 || true)
        if [[ -n "$index" ]]; then
            cmd_args+=("-selected-row" "$((index - 1))")
        fi
    fi

    printf "%b" "$options" | "${cmd_args[@]}"
}

run_app() {
    "$@" 
    disown
    exit 0
}

run_term() {
    local class="$1"
    shift
    "$TERMINAL" --class "$class" -e "$@" 
    disown
    exit 0
}

run_term_hold() {
    local class="$1"
    shift
    "$TERMINAL" --hold --class "$class" -e "$@" 
    disown
    exit 0
}

open_editor() {
    local file="$1"
    "$TERMINAL" --class "nvim_config" -e "$EDITOR" "$file" 
    disown
    exit 0
}

# --- MENUS ---

show_main_menu() {
    local selection
    selection=$(menu "Main" "󰀻  Apps\n󱓞  Utils\n  Run\n󰹑  Visuals & Display\n󰛳  Network\n  Config\n󰐉  Power")
    
    case "${selection,,}" in
        *apps*)        run_app rofi -show drun -run-command "uwsm app -- {cmd}" ;; 
        *utils*)       show_utils_menu ;;
        *run*)         rofi -show run -run-command "hyprctl dispatch exec '[float; size 850 680]' kitty {cmd}" ;;
        *visuals*)     show_visuals_menu ;;
        *network*)     show_networking_menu ;;
        *config*)      show_config_menu ;;
        *power*)       run_app rofi -show power-menu -modi "power-menu:$SCRIPTS_DIR/powermenu.sh" ;;
        *)             exit 0 ;;
    esac
}

show_utils_menu() {
    local choice
    choice=$(menu "Utils" "󰖩  Wi-Fi (TUI)\n󰂯  Bluetooth\n󰕾  Audio Mixer\n󰞅  Emoji Picker\n  Screenshot (Swappy)\n󰅇  Clipboard Persistence\n󰉋  File Manager Switch\n󰍽  Mouse Handedness\n󰌌  Wayclick (Key Sounds)")

    case "${choice,,}" in
        *wi-fi*)       run_term "wifitui" wifitui ;;
        *bluetooth*)   run_app blueman-manager ;;
        *audio*)       run_app pavucontrol ;;
        *emoji*)       run_app "$SCRIPTS_DIR/emoji.sh" ;;
        *screenshot*)
            sh -c "slurp | grim -g - - | swappy -f -" &
            disown
            exit 0
            ;;
        *clipboard*)   run_term_hold "clipboard_persistance.sh" "$SCRIPTS_DIR/desktop_apps/clipboard_persistance.sh" ;;
        *file*manager*) run_term_hold "file_manager_switch.sh" "$SCRIPTS_DIR/desktop_apps/file_manager_switch.sh" ;;
        *mouse*)       run_term_hold "mouse_button_reverse.sh" "$SCRIPTS_DIR/desktop_apps/mouse_button_reverse.sh" ;;
        *wayclick*)    run_app "$SCRIPTS_DIR/wayclick/wayclick.sh" ;;
        *)             show_main_menu ;;
    esac
}

show_visuals_menu() {
    local choice
    choice=$(menu "Visuals & Display" "󰸌  Cycle Matugen Theme\n󰸌  Matugen Config\n󰸉  Wallpaper App\n󰸉  Rofi Wallpaper\n󱐋  Animations\n󰃜  Shaders\n󰖨  Hyprsunset Slider\n󰖳  Blur/Opacity/Shadow\n󰍜  Waybar Config\n󰶡  Rotate Screen (CW)\n󰶣  Rotate Screen (CCW)\n󰐕  Scale Up (+)\n󰐖  Scale Down (-)")
    
    case "${choice,,}" in
        *cycle*)            run_app "$SCRIPTS_DIR/theme_matugen/random_theme.sh" ;;
        *matugen*config*)   run_app "$SCRIPTS_DIR/theme_matugen/matugen_config.sh" ;;
        *rofi*wallpaper*)   run_app "$SCRIPTS_DIR/rofi/rofi_wallpaper_selctor.sh" ;;
        *wallpaper*app*)    run_app waypaper ;;
        *animation*)        run_app rofi -show animations -modi "animations:$SCRIPTS_DIR/rofi/hypr_anim.sh" ;;
        *shader*)           run_app "$SCRIPTS_DIR/rofi/shader_menu.sh" ;;
        *sunset*)           run_app "$SCRIPTS_DIR/sliders/hyprsunset_slider.sh" ;;
        *blur*|*opacity*)   run_app "$SCRIPTS_DIR/hypr/hypr_blur_opacity_shadow_toggle.sh" ;;
        *waybar*)           run_term "waybar_swap_config.sh" "$SCRIPTS_DIR/waybar/waybar_swap_config.sh" ;;
        *cw*)               run_app "$SCRIPTS_DIR/hypr/screen_rotate.sh" -90 ;;
        *ccw*)              run_app "$SCRIPTS_DIR/hypr/screen_rotate.sh" +90 ;;
        *up*)               run_app "$SCRIPTS_DIR/hypr/adjust_scale.sh" + ;;
        *down*)             run_app "$SCRIPTS_DIR/hypr/adjust_scale.sh" - ;;
        *)                  show_main_menu ;;
    esac
}

show_system_menu() {
    local choice
    choice=$(menu "System & Drives" "  Fastfetch\n󰋊  Dysk (Disk Space)\n󱂵  Disk IO Monitor\n󰗮  BTRFS Compression Stats")

    case "${choice,,}" in
        *fastfetch*) run_term_hold "fastfetch" fastfetch ;;
        *dysk*)      run_term_hold "dysk" dysk ;;
        *io*)        run_term "io_monitor.sh" "$SCRIPTS_DIR/drives/io_monitor.sh" ;;
        *btrfs*)     run_term_hold "btrfs_zstd_compression_stats.sh" "$SCRIPTS_DIR/drives/btrfs_zstd_compression_stats.sh" ;;
        *)           show_main_menu ;;
    esac
}

show_performance_menu() {
    local choice
    choice=$(menu "Performance" "󰓅  Sysbench Benchmark\n󰃢  Cache Purge\n󰿅  Process Terminator")

    case "${choice,,}" in
        *sysbench*)    run_term_hold "sysbench_benchmark.sh" "$SCRIPTS_DIR/performance/sysbench_benchmark.sh" ;;
        *cache*)       run_term_hold "cache_purge.sh" "$SCRIPTS_DIR/desktop_apps/cache_purge.sh" ;;
        *process*|*terminator*) run_term_hold "performance.sh" "$SCRIPTS_DIR/performance/services_and_process_terminator.sh" ;;
        *)             show_main_menu ;;
    esac
}

show_power_battery_menu() {
    local choice
    choice=$(menu "Power & Battery" "󰶐  Hypridle Timeout\n󰂄  Battery Notification Config\n  Power Saver Mode")

    case "${choice,,}" in
        *hypridle*|*timeout*) run_term "timeout.sh" "$SCRIPTS_DIR/hypridle/timeout.sh" ;;
        *notification*)       run_term "config_bat_notify.sh" "$SCRIPTS_DIR/battery/notify/config_bat_notify.sh" ;;
        *saver*)              run_term_hold "power_saver.sh" "$SCRIPTS_DIR/battery/power_saver.sh" ;;
        *)                    show_main_menu ;;
    esac
}

show_networking_menu() {
    local choice
    choice=$(menu "Networking" "󰖂  Warp VPN Toggle\n󰣀  OpenSSH Setup\n󰖩  WiFi Testing (Airmon)")

    case "${choice,,}" in
        *warp*)   run_app "$SCRIPTS_DIR/networking/warp_toggle.sh" ;;
        *ssh*)    run_term_hold "wifi_testing" sudo "$SCRIPTS_DIR/networking/02_openssh_setup.sh" ;;
        *wifi*|*airmon*) run_term_hold "wifi_testing" sudo "$SCRIPTS_DIR/networking/ax201_wifi_testing.sh" ;;
        *)        show_main_menu ;;
    esac
}

show_config_menu() {
    local choice
    choice=$(menu "Edit Configs" "  Hyprland Main\n󰌌  Keybinds\n󱐋  Animations\n󰖲  Input\n󰍹  Monitors\n  Window Rules\n󰍜  Waybar\n󰒲  Hypridle\n󰌾  Hyprlock")

    case "${choice,,}" in
        *hyprland*)   open_editor "$HYPR_CONF/hyprland.conf" ;;
        *keybind*)    open_editor "$HYPR_SOURCE/keybinds.conf" ;;
        *animation*)  open_editor "$HYPR_SOURCE/animations/active/active.conf" ;;
        *input*)      open_editor "$HYPR_SOURCE/input.conf" ;;
        *monitor*)    open_editor "$HYPR_SOURCE/monitors.conf" ;;
        *window*)     open_editor "$HYPR_SOURCE/window_rules.conf" ;;
        *waybar*)     open_editor "$HOME/.config/waybar/config.jsonc" ;;
        *hypridle*)   open_editor "$HYPR_CONF/hypridle.conf" ;;
        *hyprlock*)   open_editor "$HYPR_CONF/hyprlock.conf" ;;
        *)            show_main_menu ;;
    esac
}

# --- ENTRY POINT ---

if [[ -n "${1:-}" ]]; then
    route_selection "$1"
else
    show_main_menu
fi
