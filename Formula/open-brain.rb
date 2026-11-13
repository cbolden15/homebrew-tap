class OpenBrain < Formula
  desc "Local-first capture, search, and portable export"
  homepage "https://github.com/cbolden15/open-brain"
  url "https://github.com/cbolden15/open-brain/releases/download/v0.2.3/open-brain-component-manifest-v1.txt",
      using: :nounzip
  sha256 "470836bad07bbbb315da37aa97960a3a94bac3c6b988dedba86fdc472e11df36"
  license "Apache-2.0"

  on_macos do
    depends_on arch: :arm64
    resource "base" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.2.3/open-brain-0.2.3-macos-arm64.tar.gz"
      sha256 "90a8a9e7c7955737102d504dfaad80476c7c1d8e28bb8ad895710b306f37c386"
    end
    resource "graphify" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.2.3/open-brain-graphify-0.2.3-macos-arm64.tar.gz"
      sha256 "9e087dae212f0f655eaab9cb7b42d9e11140da6e391c1e1ad9a667b806a737d7"
    end
    resource "harness" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.2.3/open-brain-harness-0.2.3-macos-arm64.tar.gz"
      sha256 "42c37cbeb4e91425dc05d8a7a886da3410e42737016a40738c6d3041849807f6"
    end
  end

  on_linux do
    depends_on arch: :x86_64
    resource "base" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.2.3/open-brain-0.2.3-linux-x86_64.tar.gz"
      sha256 "4859433cd04b9fc8f6a2e0537d6f49ab874531dff3898155b4e3a25489ef02bb"
    end
    resource "graphify" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.2.3/open-brain-graphify-0.2.3-linux-x86_64.tar.gz"
      sha256 "3212004f174e8c4f851761178fec678bdb63d202e4a978a11789b51aad7ec58e"
    end
    resource "harness" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.2.3/open-brain-harness-0.2.3-linux-x86_64.tar.gz"
      sha256 "6a9d31ec191de2af8413ba61907c6d5738a31d30407a9b7204b8eab5870b11dd"
    end
  end

  def install
    resource("base").stage do
      libexec.install "open-brain"
      (pkgshare/"obsidian-plugin").install Dir["obsidian-plugin/*"]
    end
    bin.install_symlink libexec/"open-brain/open-brain"
    resource("graphify").stage do
      libexec.install "open-brain" => "open-brain-graphify"
      (pkgshare/"licenses/graphify").install Dir["licenses/graphify/*"]
    end
    resource("harness").stage do
      libexec.install "open-brain-harness"
      (pkgshare/"harness").install Dir["harness/*"]
    end
  end

  test do
    assert_match "open-brain #{version}", shell_output("#{bin}/open-brain --version")
    assert_path_exists pkgshare/"obsidian-plugin/main.js"
    assert_match "open-brain-graphify-helper-v1", shell_output("#{libexec}/open-brain-graphify --capabilities")
    assert_path_exists pkgshare/"harness/harness-hook.mjs"
    assert_match "harness", shell_output("#{libexec}/open-brain-harness/open-brain-harness harness --help")
  end
end
