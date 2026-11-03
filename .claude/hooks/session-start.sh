#!/bin/bash
# Installs the Jekyll gems at the start of Claude Code cloud sessions so
# `bundle exec jekyll build` works straight away.
set -euo pipefail

# Only run in cloud sessions; local machines manage their own Ruby setup.
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "${CLAUDE_PROJECT_DIR:-.}"

gem_dir="$(ruby -e 'print Gem.dir')"
gem_bindir="$(ruby -e 'print Gem.bindir')"

# Install only when the Gemfile, lockfile or this script changed since the
# last successful install. The hash file sits in the gem directory, so it
# disappears together with the gems if the container is rebuilt.
hashes="$gem_dir/.kerrycanoeclub-session-start.sha256"
if ! sha256sum --check --status "$hashes" 2>/dev/null; then
  # Remove old hashes first, so a failed install runs again next time
  rm -f "$hashes"
  bundle install
  if command -v rbenv >/dev/null; then
    rbenv rehash
  fi
  sha256sum .claude/hooks/session-start.sh Gemfile Gemfile.lock > "$hashes" || rm -f "$hashes"
fi

# The gem executables folder (where `jekyll` lives) is not on PATH by
# default, which makes `bundle exec jekyll` report "command not found".
if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  echo "export PATH=\"$gem_bindir:\$PATH\"" >> "$CLAUDE_ENV_FILE"
fi
