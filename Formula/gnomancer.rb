class Gnomancer < Formula
  include Language::Python::Virtualenv

  desc "Local, private deep dive into your raw DNA file: haplogroups, traits, ClinVar, PharmCAT"
  homepage "https://gnomancer.com"
  url "https://files.pythonhosted.org/packages/d5/40/319f2afdf4ef9d4f0190cc9faa07f4959cedace846eadfa27069d5ae0907/gnomancer-0.5.0.tar.gz"
  sha256 "03ff3856ee850e126399a99a1438143d84f44d136349535d5f343c3f340d4e55"
  license "MIT"

  depends_on "openjdk"
  depends_on "python@3.13"

  def install
    venv = virtualenv_create(libexec, "python3.13")
    # Install from PyPI with wheels (pandas, numpy, mcp and friends); the formula pins the gnomancer version above.
    # Homebrew's venv has no pip binary of its own; run pip through the venv's python (pip comes from python@3.13).
    system libexec/"bin/python", "-m", "pip", "install", "--no-cache-dir", "gnomancer[mcp]==#{version}", "git+https://github.com/23andMe/yhaplo"
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
