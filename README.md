# codebase/homebrew-tap

```
brew install codebase/tap/gnomancer
gnomancer setup
```

Formula for [gnomancer](https://gnomancer.com), local raw-DNA analysis. Bumps track PyPI releases.

## Known issue (macOS 26.2, November 2026)

Homebrew's `python@3.12` and `python@3.13` bottles currently link `pyexpat` against a newer system libexpat than
macOS 26.2 ships, so inside Homebrew's build environment Python cannot read the OS version and pip cannot resolve
wheels (`ValueError: invalid literal for int() with base 10: ''`). This breaks every Homebrew Python formula on
such a Mac, not just this one. Until Apple's next point release lands, use the installer instead:

```
curl -fsSL https://gnomancer.com/install.sh | bash      # or: pipx install gnomancer && gnomancer setup
```
