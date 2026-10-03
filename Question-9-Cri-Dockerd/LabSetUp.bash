#!/bin/bash
set -e

# The exam installs a Debian package with dpkg, and cri-dockerd needs a running
# Docker engine. Neither holds on a non-Debian node, and enabling Docker on a live
# containerd node is not something a practice lab should do.
if ! command -v dpkg >/dev/null 2>&1; then
  echo "Skipping: this node has no dpkg (not Debian/Ubuntu). Practise this question on"
  echo "Killercoda; the sysctl part can be studied from SolutionNotes.bash."
  exit 1
fi

# Download CRI Dockerd Debian package to the home directory, matching typical exam setup
wget https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.20/cri-dockerd_0.3.20.3-0.debian-bullseye_amd64.deb -O "$HOME/cri-dockerd.deb"

echo "CRI Dockerd package downloaded to $HOME/cri-dockerd.deb"
