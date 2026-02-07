class TgLadder < Formula
  desc "Ladder — a Kaypro-inspired ASCII platformer"
  homepage "https://github.com/Tesseric/termgames"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Tesseric/homebrew-termgames/releases/download/v0.1.6/tg-ladder-aarch64-apple-darwin.tar.xz"
      sha256 "2b15678d3efc5e76031311fd5e9504b6495243fdb0e3f89f6324085a6e7c58a5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Tesseric/homebrew-termgames/releases/download/v0.1.6/tg-ladder-x86_64-apple-darwin.tar.xz"
      sha256 "4ba1c8ac87acd26a7a09c77173f0fdfe2bb4e1461f7ad3a53ef734e5baffb150"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Tesseric/homebrew-termgames/releases/download/v0.1.6/tg-ladder-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "acfeb1a788041b52658c16c90d52267ffefbd804729ded6282ad71849d08a531"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Tesseric/homebrew-termgames/releases/download/v0.1.6/tg-ladder-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "23954dba37b540e262e9783191e003b7d9f9b62c67e8105c2714a03db21065b2"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "tg-ladder" if OS.mac? && Hardware::CPU.arm?
    bin.install "tg-ladder" if OS.mac? && Hardware::CPU.intel?
    bin.install "tg-ladder" if OS.linux? && Hardware::CPU.arm?
    bin.install "tg-ladder" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
