#!/usr/bin/env bash

# ============================================================
# O1M0 TERMINAL
# Adaptive Boot Sequence
# ============================================================

[[ ! -t 1 ]] && exit 0
[[ -n "$SSH_CONNECTION" ]] && exit 0

# ------------------------------------------------------------
# Colors
# ------------------------------------------------------------

ORANGE='\033[38;2;232;129;60m'
WHITE='\033[38;2;234;234;234m'
GRAY='\033[38;2;110;110;110m'
DARK='\033[38;2;65;65;65m'
RESET='\033[0m'

# ------------------------------------------------------------
# Terminal
# ------------------------------------------------------------

cols=$(tput cols 2>/dev/null || echo 80)
lines=$(tput lines 2>/dev/null || echo 24)

# Cursor
printf '\033[?25l'

cleanup() {
    printf '\033[0m'
    printf '\033[?25h'
}

trap cleanup EXIT INT TERM

# ------------------------------------------------------------
# Helpers
# ------------------------------------------------------------

center() {
    local text="$1"
    local width="$2"

    local padding=$(( (cols - width) / 2 ))

    (( padding < 0 )) && padding=0

    printf "%*s%b\n" "$padding" "" "$text"
}

move_center_vertical() {
    local height="$1"

    local top=$(( (lines - height) / 2 ))

    (( top < 1 )) && top=1

    printf '\033[%d;1H' "$top"
}

# ------------------------------------------------------------
# Logo variants
# ------------------------------------------------------------

logo_large() {
    center "${ORANGE}                 🍠${RESET}" 20
    center "" 1

    center "${WHITE}   ██████╗  ██╗███╗   ███╗ ██████╗ ${RESET}" 39
    center "${WHITE}  ██╔═══██╗███║████╗ ████║██╔═████╗${RESET}" 39
    center "${WHITE}  ██║   ██║╚██║██╔████╔██║██║██╔██║${RESET}" 39
    center "${WHITE}  ██║   ██║ ██║██║╚██╔╝██║████╔╝██║${RESET}" 39
    center "${WHITE}  ╚██████╔╝ ██║██║ ╚═╝ ██║╚██████╔╝${RESET}" 39
    center "${WHITE}   ╚═════╝  ╚═╝╚═╝     ╚═╝ ╚═════╝ ${RESET}" 39

    center "" 1
    center "${GRAY}T E R M I N A L${RESET}" 15
}

logo_medium() {
    center "${ORANGE}        🍠${RESET}" 10
    center "" 1
    center "${WHITE}     O 1 M 0${RESET}" 11
    center "${GRAY}  ─────────────${RESET}" 15
    center "${GRAY}    TERMINAL${RESET}" 12
}

logo_small() {
    center "${ORANGE}🍠  O1M0${RESET}" 8
    center "${GRAY}TERMINAL${RESET}" 8
}

# ------------------------------------------------------------
# Start
# ------------------------------------------------------------

clear

# ============================================================
# PHASE 1
# Wake
# ============================================================

if (( cols >= 100 && lines >= 28 )); then
    move_center_vertical 13
    logo_large

elif (( cols >= 60 && lines >= 18 )); then
    move_center_vertical 7
    logo_medium

else
    move_center_vertical 4
    logo_small
fi

sleep 1.0

# ============================================================
# PHASE 2
# Initializing
# ============================================================

clear

move_center_vertical 8

center "${ORANGE}🍠${RESET}" 2
center "" 1

center "${WHITE}O1M0 SYSTEM${RESET}" 11
center "${DARK}INITIALIZING TERMINAL ENVIRONMENT${RESET}" 33

sleep 0.6

# ============================================================
# PHASE 3
# Modules
# ============================================================

center "" 1

center "${GRAY}SHELL${RESET}      ${ORANGE}●${RESET}" 14
sleep 0.35

center "${GRAY}WSL${RESET}        ${ORANGE}●${RESET}" 14
sleep 0.35

center "${GRAY}GIT${RESET}        ${ORANGE}●${RESET}" 14
sleep 0.35

center "${GRAY}WORKSPACE${RESET}  ${ORANGE}●${RESET}" 14
sleep 0.45

# ============================================================
# PHASE 4
# Loading
# ============================================================

clear

move_center_vertical 6

center "${ORANGE}🍠  O1M0${RESET}" 8
center "" 1

bar_width=$(( cols / 3 ))

(( bar_width > 42 )) && bar_width=42
(( bar_width < 16 )) && bar_width=16

for ((i=0; i<=bar_width; i++)); do

    filled=""
    empty=""

    for ((j=0; j<i; j++)); do
        filled+="━"
    done

    for ((j=i; j<bar_width; j++)); do
        empty+="─"
    done

    percent=$(( i * 100 / bar_width ))

    printf '\r'

    padding=$(( (cols - bar_width - 8) / 2 ))
    (( padding < 0 )) && padding=0

    printf "%*s" "$padding" ""

    printf "${ORANGE}%s${DARK}%s${RESET} %3d%%" \
        "$filled" \
        "$empty" \
        "$percent"

    sleep 0.035
done

printf '\n'

sleep 0.4

# ============================================================
# PHASE 5
# Ready
# ============================================================

clear

move_center_vertical 7

center "${ORANGE}        🍠${RESET}" 10
center "" 1

center "${WHITE}O 1 M 0${RESET}" 7

center "${DARK}─────────────────────${RESET}" 21

center "${ORANGE}READY${RESET}" 5

center "" 1

center "${GRAY}WELCOME BACK${RESET}" 12

sleep 1.0

# ============================================================
# Finish
# ============================================================

clear

printf '\033[?25h'

trap - EXIT INT TERM
