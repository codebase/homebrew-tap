class Gnomancer < Formula
  include Language::Python::Virtualenv

  desc "Local, private deep dive into your raw DNA file: haplogroups, traits, ClinVar, PharmCAT"
  homepage "https://gnomancer.com"
  url "https://files.pythonhosted.org/packages/a8/3f/bfc2fbe6e542bda47d64008fb7b199c8cc3b98e4bc19e52ef51b830bd8bf/gnomancer-0.4.2.tar.gz"
  sha256 "3abd2599c3f7cd5c7519d1e20b72d0fc91378af1727bdc39434d72f17c7eab64"
  license "MIT"

  depends_on "openjdk"
  depends_on "python@3.12"

  def install
    venv = virtualenv_create(libexec, "python3.12")
    # Install from PyPI with wheels (pandas, numpy, mcp and friends); the formula pins the gnomancer version above.
    system libexec/"bin/pip", "install", "--no-cache-dir", "gnomancer[mcp]==#{version}", "git+https://github.com/23andMe/yhaplo"
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
