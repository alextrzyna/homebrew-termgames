class TgLadder < Formula
  desc "Ladder — a Kaypro-inspired ASCII platformer"
  homepage "https://github.com/alextrzyna/termgames"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/alextrzyna/termgames/releases/download/v0.1.0/tg-ladder-aarch64-apple-darwin.tar.xz"
      sha256 "f67e6b45683744bbf872211739911bff2c90daf11d7ecf737a10e8d7cdd4cec5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/alextrzyna/termgames/releases/download/v0.1.0/tg-ladder-x86_64-apple-darwin.tar.xz"
      sha256 "f955bccf234ce7e976341168e5b346752f1f7589e16e3a9771cb8393fd444ec0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/alextrzyna/termgames/releases/download/v0.1.0/tg-ladder-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "604840a6eb30d1334efd1cfb4d496c7d5a3a606125ebcaf4aa2918b019bce7ab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/alextrzyna/termgames/releases/download/v0.1.0/tg-ladder-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3b90508e73e45ad7124ffcc0cc104ec1cf1461553c31678d7cfbb3c27eb7e9b4"
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
