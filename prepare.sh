#!/usr/bin/env bash
set -euo pipefail

# color
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
RESET="\033[0m"

info()      { echo -e "${BLUE}[INFO]${RESET} $1"; }
success()   { echo -e "${GREEN}[OK]${RESET}   $1"; }
warn()      { echo -e "${YELLOW}[WARN]${RESET} $1"; }
error()     { echo -e "${RED}[ERR]${RESET}  $1"; }

QEMU_URL="https://download.qemu.org/qemu-7.2.21.tar.bz2"
LINUX_URL="https://www.kernel.org/pub/linux/kernel/v5.x/linux-5.15.196.tar.xz"

download_and_extract() {
  local url="$1"
  local prefix="$2"
  local fname="${url##*/}"

  # download
  info ">>> Downloading $url ..."
  if [ -f "$fname" ]; then
    warn "  File $fname already exists — skip download."
  else
    wget "$url"
  fi

  # extract tar
  info ">>> Extracting $fname ..."
  case "$fname" in
    *.tar.bz2)
      tar xjf "$fname"
      ;;
    *.tar.gz)
      tar xzf "$fname"
      ;;
    *.tar.xz)
      tar xJf "$fname"
      ;;
    *)
      error "Unknown archive format: $fname"
      return 1
      ;;
  esac

  # remove tar
  info ">>> Remove $fname ..."
  rm -f "$fname"

  orig_dir=$(tar tf "fname" 2>/dev/null | head -1 | cut -d/ -f1 || true)

  if [ -z "$orig_dir" ]; then
      orig_dir="${fname%.tar.*}"
  fi

  new_dir="$prefix"

  # rename
  info ">>> Rename $orig_dir -> $new_dir ..."
  rm -rf "$new_dir"
  mv "$orig_dir" "$new_dir"

  success ">>> Done with $new_dir."
}

download_and_extract "$QEMU_URL" "qemu"
download_and_extract "$LINUX_URL" "linux"

success "All done."

