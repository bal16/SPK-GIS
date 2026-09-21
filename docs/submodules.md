# Submodule Update Guide (SPK-GIS)

This repo uses 2 submodules pinned to specific commits, not live branches:

* `backend` -> https://github.com/bal16/nestjs_gis_spk (`main`)
* `frontend` -> https://github.com/bal16/next_gis_spk (`main`)

This means: when `main` in a submodule repo moves forward, `SPK-GIS` **does not follow automatically**. GitHub will show `X commits behind` until the pointer (`gitlink`) is updated manually.

`.gitmodules` is already configured for tracking:

```ini
[submodule "frontend"]
  path = frontend
  url = https://github.com/bal16/next_gis_spk
  branch = main
[submodule "backend"]
  path = backend
  url = https://github.com/bal16/nestjs_gis_spk
  branch = main
```

## 1. Update to latest `origin/main`

```bash
# from SPK-GIS root
git submodule sync
git submodule update --remote --merge backend frontend

# verify what changed
git status -sb
git diff --cached -- backend frontend
git submodule status
```

Expected healthy output:

```
 2b265da backend (heads/main)
 ff58bf2 frontend (heads/main)
```

No `+` prefix (`+` = not staged, `-` = not initialized).

## 2. Commit + push the new pointers

```bash
git add .gitmodules backend frontend
git commit -m "chore: update submodules to latest main"
git push origin main
```

After pushing, the `SPK-GIS` GitHub page will point to the new SHAs.

## 3. Fresh clone / initial setup

```bash
git clone --recurse-submodules https://github.com/bal16/SPK-GIS.git
# if already cloned without the flag:
git submodule update --init --recursive
```

## 4. Troubleshooting

* **Forgot to commit gitlink:** `git status` shows `M backend` / `M frontend` but GitHub still shows the old commit -> you haven't run `add/commit/push` yet.
* **Mixed staged state (`MM backend`):** re-run `git add backend frontend` before committing.
* **Remote is ahead of local:** run `git fetch --recurse-submodules origin` first, then `update --remote`.
* **Check per submodule manually:**
  ```bash
  git -C backend fetch origin && git -C backend log --oneline main..origin/main
  git -C frontend fetch origin && git -C frontend log --oneline main..origin/main
  ```

## Recommended workflow

* Do daily work in the `backend` / `frontend` repos directly.
* Only update pointers in `SPK-GIS` on release / demo / submission, after local tests pass.
