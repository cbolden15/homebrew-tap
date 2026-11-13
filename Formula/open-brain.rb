class OpenBrain < Formula
  desc "Local-first capture, search, and portable export"
  homepage "https://github.com/cbolden15/open-brain"
  url "https://github.com/cbolden15/open-brain/releases/download/v0.2.4/open-brain-component-manifest-v1.txt",
      using: :nounzip
  sha256 "d4d0d6b52de16a49b6b4bf2c57213b0d9291ef9fa6a7f2becb8a7be6cf92f62b"
  license "Apache-2.0"

  on_macos do
    depends_on arch: :arm64
    resource "base" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.2.4/open-brain-0.2.4-macos-arm64.tar.gz"
      sha256 "7e902a49f713b9429e5b837f4ec1888bc3c36093ec8d3897f51714ca1454d747"
    end
    resource "graphify" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.2.4/open-brain-graphify-0.2.4-macos-arm64.tar.gz"
      sha256 "d292eb5c01ead2ddc0a5ca92bf726860881dddcd1908ab0555f9d74edc351a39"
    end
    resource "harness" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.2.4/open-brain-harness-0.2.4-macos-arm64.tar.gz"
      sha256 "37c4d0a2b57a018968bf79dcc0e9f81b838c008d2462cc7424328bc01a529b0d"
    end
  end

  on_linux do
    depends_on arch: :x86_64
    resource "base" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.2.4/open-brain-0.2.4-linux-x86_64.tar.gz"
      sha256 "e8907e17132d48d1bfec638a0b4da3006e6c808d3478868709ad0f6bacac066e"
    end
    resource "graphify" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.2.4/open-brain-graphify-0.2.4-linux-x86_64.tar.gz"
      sha256 "127b3cb33901e9ead7fabaf834476537a583768fc795d33213f34fa100b7641c"
    end
    resource "harness" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.2.4/open-brain-harness-0.2.4-linux-x86_64.tar.gz"
      sha256 "a1dfd75efd3e35fe3a9d49cce9b4b33f88e014b8c8ee365893da10d5ea300267"
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
