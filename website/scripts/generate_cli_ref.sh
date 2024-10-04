#!/usr/bin/env bash
set -euo pipefail

sorbet_orig="$1"

cat <<'EOF'
---
id: cli-ref
title: Command Line Reference
sidebar_label: CLI Reference
---

<!-- DO NOT EDIT. This file is autogenerated.    -->
<!--                                             -->
<!-- To update the help output, run              -->
<!--                                             -->
<!--     bazel run //website:update_cli_ref      -->
<!--                                             -->
<!-- To update the preamble or formatting, edit  -->
<!--                                             -->
<!--     website/scripts/generate_cli_ref.sh     -->
<!--                                             -->
<!-- and then run the above command.             -->

This page shows the `srb tc --help` output for the latest version of Sorbet.

- See [Command Line Quickstart](cli.md) for an overview of some of the more
  common options and workflows.

- See `srb tc --help` to see the help options for your version of Sorbet. (New
  options are added and changed all the time.)

## Usage

```plaintext
EOF

# Uses script + stty to make the output appear like it's 90 columns,
# which is the largest we can get and not have scrollbars appear when viewing
# the docs site on a desktop browser with a large screen.
script -q /dev/null bash -c "stty cols 90 && \"$sorbet_orig\" --help" 2>&1 | \
  # I have no idea what's making this get into the output
  sed -e $'s/^\^D\x08\x08//' | \
  # It seems like when the output is to a tty, lines end with \r\n
  # (... and sometimes more than one `\r` ??)
  sed -e $'s/\\\r\\\r*$//' | \
  # Get rid of trailing spaces to make it look nice when reading the markdown
  sed -e 's/ *$//' | \
  # CI has different number of cores, so the `--max-threads` help output changes
  sed -e 's/^\( *\)[1-9][0-9]*)/\1number of cores on the system)/' | \
  # Convert help sections into markdown sections
  sed -e $'s/^ \\([A-Z].* options\\):/```\\\n\\\n## \\1\\\n\\\n```plaintext/'

cat <<'EOF'
```
EOF

