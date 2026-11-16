class Gnomancer < Formula
  include Language::Python::Virtualenv

  desc "Local, private deep dive into your raw DNA file: haplogroups, traits, ClinVar, PharmCAT"
  homepage "https://gnomancer.com"
  url "https://files.pythonhosted.org/packages/83/8b/9c0b8ac6b6eee0b1fa27e6719637376f64c4f384fa3e512a3f6c74bac3b3/gnomancer-0.5.3.tar.gz"
  sha256 "ff32d69a02d29722732961bad60559d5ba3539f6a4a55838d4b99d8a2dd25868"
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
