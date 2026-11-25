class Gnomancer < Formula
  include Language::Python::Virtualenv

  desc "Local, private deep dive into your raw DNA file: haplogroups, traits, ClinVar, PharmCAT"
  homepage "https://gnomancer.com"
  url "https://files.pythonhosted.org/packages/8a/ed/4655cceb11a346098771844fb07dd157dd550a6ecaa3e16cb5d1d64a27b6/gnomancer-0.6.0.tar.gz"
  sha256 "8a18073a0b68c8129125a718fa09f0fec8804ad1e178a79c6f00bf2683309d27"
  license "MIT"

  depends_on "openjdk"
  depends_on "python@3.13"

  def install
    venv = virtualenv_create(libexec, "python3.13")
    # Install from PyPI with wheels (pandas, numpy, mcp and friends); the formula pins the gnomancer version above.
    # Homebrew's venv has no pip binary of its own; run pip through the venv's python (pip comes from python@3.13).
    system libexec/"bin/python", "-m", "pip", "install", "--no-cache-dir", "gnomancer==#{version}", "git+https://github.com/23andMe/yhaplo"
    bin.install_symlink libexec/"bin/gnomancer"
    bin.install_symlink libexec/"bin/gnomancer-mcp"
  end

  def caveats
    <<~EOS
      Run once to download the open-source tools and reference files (~250 MB):
        gnomancer setup
      Then:
        gnomancer ~/Downloads/AncestryDNA.zip
      How to download your raw data: https://gnomancer.com/get-your-data/
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gnomancer --version")
  end
end
