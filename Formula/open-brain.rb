class OpenBrain < Formula
  desc "Local-first capture, search, and portable export"
  homepage "https://github.com/cbolden15/open-brain"
  url "https://github.com/cbolden15/open-brain/releases/download/v0.1.0/open-brain-component-manifest-v1.txt",
      using: :nounzip
  sha256 "7434b680420c9bbfdec036a146a5f7567f52357d0a27a868ea65a1b65e4704fb"
  license "Apache-2.0"

  on_macos do
    depends_on arch: :arm64
    resource "base" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.1.0/open-brain-0.1.0-macos-arm64.tar.gz"
      sha256 "8ef7def341e383cdf0e33d70d6ae14601a034038923b4bdb690702e4d9cb39ce"
    end
    resource "graphify" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.1.0/open-brain-graphify-0.1.0-macos-arm64.tar.gz"
      sha256 "20c71c81fba3c358cf49de22f645ad298aea77e8fff122e13f12aff1515e0c19"
    end
  end

  on_linux do
    depends_on arch: :x86_64
    resource "base" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.1.0/open-brain-0.1.0-linux-x86_64.tar.gz"
      sha256 "3f44f5c9e5ff06807958b92cd00bd92b35fe0e83eca297b7711b7bde7f93d293"
    end
    resource "graphify" do
      url "https://github.com/cbolden15/open-brain/releases/download/v0.1.0/open-brain-graphify-0.1.0-linux-x86_64.tar.gz"
      sha256 "bb5f3d59b2f905b692a0416919d6a241dcef86ada4cd40e139117edc204ee265"
    end
  end

  def install
    resource("base").stage do
      bin.install "open-brain"
      (pkgshare/"obsidian-plugin").install Dir["obsidian-plugin/*"]
    end
    resource("graphify").stage do
      libexec.install "open-brain" => "open-brain-graphify"
      (pkgshare/"licenses/graphify").install Dir["licenses/graphify/*"]
    end
  end

  test do
    assert_match "open-brain #{version}", shell_output("#{bin}/open-brain --version")
    assert_path_exists pkgshare/"obsidian-plugin/main.js"
    assert_match "open-brain-graphify-helper-v1", shell_output("#{libexec}/open-brain-graphify --capabilities")
  end
end
