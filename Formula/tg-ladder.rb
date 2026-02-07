class TgLadder < Formula
  desc "Ladder — a Kaypro-inspired ASCII platformer"
  homepage "https://github.com/alextrzyna/termgames"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/alextrzyna/termgames/releases/download/v0.1.2/tg-ladder-aarch64-apple-darwin.tar.xz"
      sha256 "e515dabf8e46be5957e46769e5120e879b591bf8b28e684ac8d2246658ee8035"
    end
    if Hardware::CPU.intel?
      url "https://github.com/alextrzyna/termgames/releases/download/v0.1.2/tg-ladder-x86_64-apple-darwin.tar.xz"
      sha256 "60622dc8026288d7a690d2d110e15dddadab51b10e529ad98ceb750309d2c22f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/alextrzyna/termgames/releases/download/v0.1.2/tg-ladder-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ef129fe317522ba03947fdd9a7e4355d689972a8c6096c737272d919f90274bc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/alextrzyna/termgames/releases/download/v0.1.2/tg-ladder-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8e2414983887fe5a8902151d0f34f0f459b9ab5cc8a79a3e08ff121a1bca4c25"
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
