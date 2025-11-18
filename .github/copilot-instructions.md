# GitHub Copilot Instructions for `openwrt-node-packages`

You are an AI contributor working **inside the repository `ranas-mukminov/openwrt-node-packages`** on GitHub.  
Owner: **@ranas-mukminov**.  
This repository is a **feed of OpenWrt packages for Node.js and Node.js ecosystem modules**. It is a fork of upstream OpenWrt Node.js feed and should stay compatible with OpenWrt buildroot and feeds.

Your main goals:
- Keep this feed **buildable in OpenWrt** and compatible with current OpenWrt branches.
- Help **add or maintain specific Node.js packages** for OpenWrt.
- Make **small, reviewable pull requests**, never push directly to the default branch.

---

## 0. Repository context

- Type: OpenWrt feed for **Node.js** and **Node.js-native / ecosystem packages**.
- Upstream structure: one directory per package (`node-<name>`), each containing a standard OpenWrt `Makefile` and patches.
- This fork: `OpenWrt Project Node.js packages. v10.x LTS and v12.x LTS` (description in the repo).

Assume:
- OpenWrt build system is used (`./scripts/feeds`, `make menuconfig`, etc.).
- Node.js versions and targets must match **supported OpenWrt architectures** (no random unsupported combo).

Never:
- Introduce non-OpenWrt build systems (no plain `docker build` that bypasses OpenWrt).
- Add cloud services or external hosted build logic.
- Hardcode user-specific paths or credentials.

---

## 1. Branch, commit, and PR workflow

When I ask you to modify this repo:

1. **Create a feature branch** from the default branch:
   - Naming pattern: `copilot/openwrt-node-<short-goal>`
   - Examples:
     - `copilot/openwrt-node-readme-update`
     - `copilot/openwrt-node-add-node-noble`
     - `copilot/openwrt-node-sync-upstream`

2. **Never commit directly** to `master` or `main`.

3. **Commit messages**:
   - First line imperative, <= 72 chars.
   - Examples:
     - `Add OpenWrt usage notes to README`
     - `Update node-mdns package to latest upstream`
   - Optional body: why + short technical details.

4. **Open a Pull Request** from your feature branch into the default branch and then **stop**.  
   Do **not** merge. The PR is for **@ranas-mukminov** to review.

---

## 2. Allowed change types and priorities

Default priorities:

### Priority 1 – Documentation and metadata

- Improve `README.md` and/or `README.<lang>.md`:
  - Brief explanation what this feed is:
    - OpenWrt feed for Node.js LTS and selected native modules.
  - Show how to add the feed to `feeds.conf`:
    - `src-git node https://github.com/ranas-mukminov/openwrt-node-packages.git`
  - Show basic usage:
    - `./scripts/feeds update node`
    - `./scripts/feeds install -a -p node`
    - `make menuconfig`
  - Mention supported architectures in general (aarch64, arm, x86_64) based on upstream, without promising unsupported platforms.
- If needed, add **`docs/`** or **`examples/`** with:
  - Example `feeds.conf.default` snippet.
  - Example minimal build procedure.

Do not:
- Promise Node.js versions or OpenWrt support that are not actually present in this fork.

### Priority 2 – Package maintenance / addition

- For existing `node-<package>` directories:
  - Keep OpenWrt `Makefile` structure and style consistent with upstream.
  - Update:
    - `PKG_VERSION`
    - `PKG_HASH`
    - `PKG_SOURCE_URL`
    - `NODEJS_VERSION`/`NODEJS_PKGS` variables if present
  - Ensure `DEPENDS` is correct and minimal.
- When adding a new package:
  - Use standard OpenWrt Node package pattern from existing packages in this repo or upstream.
  - Directory name: `node-<npm-name>` (lowercase, hyphenated).
  - `Makefile` must:
    - Set `PKG_NAME`, `PKG_VERSION`, `PKG_RELEASE`.
    - Use the correct `PKG_SOURCE`, `PKG_SOURCE_URL`, `PKG_HASH`.
    - Use the correct Node.js build class (`nodejs-packages` or similar, matching existing packages).
- Add package to `README` **only after** the Makefile is correct.

Do not:
- Invent custom build logic if an existing pattern in this repo can be reused.

### Priority 3 – Version alignment / sync with upstream

Only if requested:
- Propose how to align this fork's Node.js versions with upstream `nxhack/openwrt-node-packages` (v18/v20/v22 LTS) but:
  - Do not mass-upgrade everything automatically.
  - Start with documentation and a small subset of packages.
  - Clearly document any breaking changes.

---

## 3. Constraints and safety

- Keep **OpenWrt conventions**:
  - Tabs (not spaces) in Makefiles.
  - Standard variables (`PKG_NAME`, `PKG_VERSION`, `PKG_RELEASE`, `PKG_SOURCE_URL`, `PKG_HASH`, `PKG_LICENSE`, `PKG_MAINTAINER`, etc.).
- Do not:
  - Add non-OpenWrt build tools (like yarn-only builds) unless strictly needed and documented.
  - Assume toolchain features that are not standard in OpenWrt.
- If architecture-specific flags are needed:
  - Reuse patterns from existing packages in this repo or upstream.
  - Document them in comments.

If something is uncertain, prefer:
- Minimal changes.
- Documentation over silent assumptions.

---

## 4. Validation and build checks

Before opening a PR, prepare a **Testing** section with concrete commands the user can run in OpenWrt buildroot. Even if commands cannot be executed in this environment, they must be logically correct.

Examples:

```bash
# 1. Add feed
echo 'src-git node https://github.com/ranas-mukminov/openwrt-node-packages.git' >> feeds.conf

# 2. Update and install
./scripts/feeds update node
./scripts/feeds install node-<package-name>

# 3. Build single package
make package/node-<package-name>/compile V=sc
```

If you changed multiple packages, provide a short list:

```
Tested packages:
- node-foo: `make package/node-foo/compile V=sc`
- node-bar: `make package/node-bar/compile V=sc`
```

If you cannot verify some things:
- Explicitly say so under ## Testing.
- Do not claim tests were run.

---

## 5. Pull Request format

Every PR description must include these sections:

### Summary
- Short description of what was changed.
- What problem this solves for OpenWrt users.

### Changes
- Bullet list of key changes (files, packages, docs).

### Testing
- Exact commands to build and/or validate packages.
- Note clearly if tests have not been executed in CI.

### Compatibility / Risk
- Does this change affect existing packages?
- Any possible breakages (Node.js version bump, changed dependencies, etc.).

### Notes for @ranas-mukminov
- Open questions.
- Things that may require manual decision (e.g. default Node.js LTS version for new packages).

PR title examples:
- `Document usage of openwrt-node-packages feed`
- `Add node-foo package for OpenWrt`
- `Update node-bar to latest upstream release`

---

## 6. Copilot Chat behaviour

When I ask Copilot something for this repo, it should:

1. **First answer with a short plan** (3–6 bullets):
   - Which files it will touch.
   - Whether it will update docs, Makefiles, or both.

2. **Propose**:
   - Branch name to use (`copilot/openwrt-node-...`).
   - Scope of the planned PR.

3. **Then generate or modify files** according to these instructions and finally output:
   - The diff or full file contents.
   - The recommended PR title and body (with the sections from above).

Prefer:
- Small, atomic changes.
- Explicit commands and paths.
- OpenWrt-style Makefiles and build steps.
