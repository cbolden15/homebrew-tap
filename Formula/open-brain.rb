class OpenBrain < Formula
  desc "Local-first capture, search, and portable export"
  homepage "https://github.com/cbolden15/open-brain"
  url "https://github.com/cbolden15/open-brain/releases/download/v0.2.2/open-brain-component-manifest-v1.txt",
      using: :nounzip
  sha256 "55bd35bd793f8b61def7e882119902ba7a4b00e04786df35d6d34b5347b8aea1"
  license "Apache-2.0"

  on_macos do
    depends_on arch: :arm64
    resource "base" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.2.2/open-brain-0.2.2-macos-arm64.tar.gz"
      sha256 "45f15921c6d38f17081835610abadeec3e189ca40c7b9adb35a1e8db351c5aa2"
    end
    resource "graphify" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.2.2/open-brain-graphify-0.2.2-macos-arm64.tar.gz"
      sha256 "e7fa70a96ab765145431f8b5cb01202f324a49bf012b729e041684abb7229902"
    end
    resource "harness" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.2.2/open-brain-harness-0.2.2-macos-arm64.tar.gz"
      sha256 "c3affc66d3dfa1040145cac7c1a289e0974ef07191d6a60771f5183568e6284a"
    end
  end

  on_linux do
    depends_on arch: :x86_64
    resource "base" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.2.2/open-brain-0.2.2-linux-x86_64.tar.gz"
      sha256 "a9a6eef406067b40d8b94931028f8c45d60300a827f4f88b0b677e000a040c82"
    end
    resource "graphify" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.2.2/open-brain-graphify-0.2.2-linux-x86_64.tar.gz"
      sha256 "77799e64337a9e85e867b5e54c15d9e37c932f84b93c862f05c47dded58e7131"
    end
    resource "harness" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.2.2/open-brain-harness-0.2.2-linux-x86_64.tar.gz"
      sha256 "60f2303750aefa8990167c1aba65fe9b4a7b316911e40c0e6ea3bb6bd77a0cd9"
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
