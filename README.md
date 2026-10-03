# CKA Practice (Simple Edition)

Straightforward CKA practice labs derived from the CKA-PREP playlist. Every question lives in its own folder with bash files:

**Note:** This is a living repo and may still contain bugs or rough edges. If you spot an issue—especially in lab setup or validation scripts—please open an issue or PR so it can be fixed.  This is a best effort repo and PR/Issue merges will be addressed as time permits!

**Exam prep note:** These questions are designed to be similar to the CKA exam, but they are not meant be exact matches. Learn the underlying concepts in depth and try different scenarios so you can solve variations under exam conditions.

- `LabSetUp.bash` — set up the environment for the question.
- `Questions.bash` — the scenario text plus the YouTube link for the walkthrough.
- `SolutionNotes.bash` — a step-by-step solution when you need a hint.
- `validate.bash` — automatic validation checks to confirm your solution is correct.
- `cleanup.bash` — clean up and remove resources created during the question.

---

## How to Use

1. Launch the [Killercoda CKA playground]([https://killercoda.com/cka](https://killercoda.com/playgrounds/scenario/cka) or your own cluster.
2. Clone this repo inside the environment:
   ```bash
   git clone https://github.com/markdjones82/CKA-PREP-2025-v2.git ~/CKA-PREP-2025-v2
   cd ~/CKA-PREP-2025-v2
   ```
3. Run a question setup by number:
   ```bash
   scripts/run-question.sh 5
   ```
4. Work through the task, then consult `SolutionNotes.bash` if you need help.
5. Validate your solution:
   ```bash
   scripts/validate-question.sh 5
   ```
6. Clean up resources when done:
   ```bash
   scripts/cleanup-question.sh 5
   ```

---

## Validating Your Solutions

Each question has a `validate.bash` script that runs automated checks against your cluster to confirm the solution is correct.

### Validate a single question
```bash
# By question number
scripts/validate-question.sh 5

# By directory name
scripts/validate-question.sh Question-5-HPA
```

### Validate all questions
```bash
scripts/validate-question.sh all
```

The script outputs `PASS` or `FAIL` for each check, with a final score summary. Exit code is `0` if all checks pass, non-zero otherwise.

---

## Running on Your Own Multi-Node kubeadm Cluster

The labs were written for Killercoda (`controlplane` + `node01`, logged in as root). They
also run on a self-managed kubeadm cluster as a non-root user with sudo, with these
adjustments built in:

- Run the scripts as your normal user with a working `~/.kube/config`. Do not prefix them
  with `sudo`: root usually has no kubeconfig, and the labs call `sudo` themselves where they
  need it. Files the questions ask you to save go to `~` (which is `/root` on Killercoda).
- Question 10 targets `node01` when it exists, otherwise
  the last node by name. Set `CKA_NODE=<node>` to choose explicitly; setup prints the choice.
- Question 5 reuses an existing metrics-server and only removes one it installed itself.
- Questions 8 and 9 run as written. Question 8 assumes Cilium on Killercoda with a worker
  named `node01`, and its cleanup deletes the Calico CRDs; Question 9 needs Debian/Ubuntu
  (`dpkg`) and Docker. Run them on a cluster you are prepared to rebuild.
- Question 15 breaks kube-apiserver on the node you run it from. With several control planes
  the others keep serving, so inspect that node with `crictl` and its manifest. Validate checks
  that node's apiserver, and cleanup restores `/root/kube-apiserver.yaml.bak` if the manifest
  is still broken. Take an etcd snapshot first if the cluster matters to you.
- Question 1 works without a StorageClass. Question 2 needs `helm`; Question 12 needs an
  ingress controller to make the curl work (validate does not check it); Question 11 leaves
  the Gateway API CRDs installed.
- `validate-question.sh all` and `cleanup-question.sh all` cover every question directory.

---

## Simulated Exam Desktop (VSCodium)

You can use **VSCodium** (an open-source VS Code build) inside the Killercoda simulated desktop to edit files in a familiar IDE environment, similar to what is available in the real CKA exam.

> **NOTE: A paid Killercoda subscription is required** for the simulated desktop environment.
> Without it, the desktop GUI is not available and VSCodium cannot be launched graphically.

### Install VSCodium
```bash
scripts/install-codium.sh
```

### Launch VSCodium
Once installed, open it from inside your repo:
```bash
cd ~/CKA-PREP-2025-v2
codium --no-sandbox --user-data-dir .
```

This opens VSCodium in the current directory, allowing you to browse and edit all question files directly.

---

## Available Questions

| # | Topic | Video |
|---|-------|-------|
| 1 | MariaDB — Persistent Volume | https://youtu.be/aXvvc1EB1zg |
| 2 | ArgoCD — Install via Helm (no CRDs) | https://youtu.be/e0YGRSjb8CU |
| 3 | Sidecar Container | https://youtu.be/3xraEGGQJDY |
| 4 | Resource Allocation | https://youtu.be/ZqGDdETii8c |
| 5 | HPA — HorizontalPodAutoscaler | https://youtu.be/YGkARVFKtmM |
| 6 | CRDs — cert-manager | https://youtu.be/SA1DzLQaDJs |
| 7 | PriorityClass | https://youtu.be/CZzxGyF6OHc |
| 8 | CNI & Network Policy | https://youtu.be/Uc04Ui4x3EM |
| 9 | cri-dockerd | https://youtu.be/ybzo1vXiqjU |
| 10 | Taints & Tolerations | https://youtu.be/oy6Mdqt1-jk |
| 11 | Gateway API | https://youtu.be/G9zispvOCHE |
| 12 | Ingress | https://youtu.be/sy9zABvDedQ |
| 13 | Network Policy | https://youtu.be/rA8mXYTU0W8 |
| 14 | Storage Class | https://youtu.be/di7X7OHn2fc |
| 15 | Etcd Fix | https://youtu.be/IL448T6r8H4 |
| 16 | NodePort Service | — |
| 17 | TLS Config | — |
| 18 | kubectl patch — Resource Limits | — |
| 19 | Resource Allocation v2 — Pod Scheduling | — |
