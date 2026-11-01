class OpenBrain < Formula
  desc "Local-first capture, search, and portable export"
  homepage "https://github.com/cbolden15/open-brain"
  url "https://github.com/cbolden15/open-brain/releases/download/v0.2.1/open-brain-component-manifest-v1.txt",
      using: :nounzip
  sha256 "e8fdd969c65dc770cbe14b495af0bce4394667ddac0c53ad144ade6cf0d918af"
  license "Apache-2.0"

  on_macos do
    depends_on arch: :arm64
    resource "base" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.2.1/open-brain-0.2.1-macos-arm64.tar.gz"
      sha256 "2135b3d03e4b9eb3e843da68a67c29704440ed2b669d65f440b0c2f44d1c54bf"
    end
    resource "graphify" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.2.1/open-brain-graphify-0.2.1-macos-arm64.tar.gz"
      sha256 "3b0602919bfe93003667630c32bbab477676c6ef567e0d94e0ec776cfd08b6ed"
    end
    resource "harness" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.2.1/open-brain-harness-0.2.1-macos-arm64.tar.gz"
      sha256 "6284caf76935d217a1da6c51ce9630a4eb9b57911a67b9c38b64885f5e133199"
    end
  end

  on_linux do
    depends_on arch: :x86_64
    resource "base" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.2.1/open-brain-0.2.1-linux-x86_64.tar.gz"
      sha256 "4277cff472cee9334250ed4514cee05fa5ef9c612effa5a28a7371baec96445c"
    end
    resource "graphify" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.2.1/open-brain-graphify-0.2.1-linux-x86_64.tar.gz"
      sha256 "adbec8edbfbe5afa01112a0040a10e7f838b1a38415169c889152c1e0d47c697"
    end
    resource "harness" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.2.1/open-brain-harness-0.2.1-linux-x86_64.tar.gz"
      sha256 "2757f0994fd2731491ecb4b9d42eccc4dfa68cbaf5298c36d4345a5280d70fb0"
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
