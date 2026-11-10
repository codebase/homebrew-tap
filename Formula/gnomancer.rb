class Gnomancer < Formula
  include Language::Python::Virtualenv

  desc "Local, private deep dive into your raw DNA file: haplogroups, traits, ClinVar, PharmCAT"
  homepage "https://gnomancer.com"
  url "https://files.pythonhosted.org/packages/f1/fe/ac3d122fb601898c2d79a41bf1a02b3374d0057ccab59f38b10085cd9b1f/gnomancer-0.5.2.tar.gz"
  sha256 "8835e26cc7fc53feca8cb3b67705e6b9dbd00dba102e1972f0c3a2fada59b5e3"
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
