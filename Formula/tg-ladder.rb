class TgLadder < Formula
  desc "Ladder — a Kaypro-inspired ASCII platformer"
  homepage "https://github.com/Tesseric/termgames"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Tesseric/termgames/releases/download/v0.1.1/tg-ladder-aarch64-apple-darwin.tar.xz"
      sha256 "62529f0fe71282a9f2bc7a4398163c0fbdf14f82a19c7f2aad048ced564f3a29"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Tesseric/termgames/releases/download/v0.1.1/tg-ladder-x86_64-apple-darwin.tar.xz"
      sha256 "2696eca3af348a8173daca3dce56189adce0193928f3b415dbd71ae69801ca1f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Tesseric/termgames/releases/download/v0.1.1/tg-ladder-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "30d3a09548ec834f88df062e6e07c36d34ccba48728ace01acb6418744c8f9f1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Tesseric/termgames/releases/download/v0.1.1/tg-ladder-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "dc3dee8c891dadedced675d6de164158b0032f1f8f2667a50e08d0c948c14580"
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
