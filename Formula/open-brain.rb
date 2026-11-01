class OpenBrain < Formula
  desc "Local-first capture, search, and portable export"
  homepage "https://github.com/cbolden15/open-brain"
  url "https://github.com/cbolden15/open-brain/releases/download/v0.2.0/open-brain-component-manifest-v1.txt",
      using: :nounzip
  sha256 "2f2c91953bbe447f88e96b3e541d3ed3bc303ba123bbc0fa6ca27b15554ffd36"
  license "Apache-2.0"

  on_macos do
    depends_on arch: :arm64
    resource "base" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.2.0/open-brain-0.2.0-macos-arm64.tar.gz"
      sha256 "c7bbf84488445347ae65904c7569c9168d0cda0bb888eef49922431e8623d754"
    end
    resource "graphify" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.2.0/open-brain-graphify-0.2.0-macos-arm64.tar.gz"
      sha256 "6b1bcd06d77fea66fd89148e645f13585fcf19061ec38e713c5cb04f683dd5ff"
    end
    resource "harness" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.2.0/open-brain-harness-0.2.0-macos-arm64.tar.gz"
      sha256 "692c1f778151ed4f0d6d5c5f85f80d73ae3931205bfa9d376cd90da8ff458ef5"
    end
  end

  on_linux do
    depends_on arch: :x86_64
    resource "base" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.2.0/open-brain-0.2.0-linux-x86_64.tar.gz"
      sha256 "5cbd0927f0a015e1a08b359939b57a7d4551eeb48e40d59e85b656d7f95df64e"
    end
    resource "graphify" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.2.0/open-brain-graphify-0.2.0-linux-x86_64.tar.gz"
      sha256 "1eade24b16949744ffb64dc4e1f9a294773232972b5e8b03b8b8877c0ceca728"
    end
    resource "harness" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.2.0/open-brain-harness-0.2.0-linux-x86_64.tar.gz"
      sha256 "5ddea62a9250308c921c988d262025d2c05f6f72f2624fd260586945209ad5ec"
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
