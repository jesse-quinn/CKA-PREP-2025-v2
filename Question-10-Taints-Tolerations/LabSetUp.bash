#!/bin/bash
source "$(dirname "${BASH_SOURCE[0]}")/../scripts/lib.sh"

echo "# No setup needed on Killercoda."
echo "# Target node for this question: $(cka_target_node)"
echo "# (node01 when it exists, otherwise the last node by name; override with CKA_NODE)"
