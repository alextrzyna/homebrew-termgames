class TgLadder < Formula
  desc "Ladder — a Kaypro-inspired ASCII platformer"
  homepage "https://github.com/Tesseric/termgames"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Tesseric/homebrew-termgames/releases/download/v0.1.5/tg-ladder-aarch64-apple-darwin.tar.xz"
      sha256 "c39deea8cb233cceb3e3daf86b5d91c9b42482bb35ee4a6cfb5315f297bf3814"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Tesseric/homebrew-termgames/releases/download/v0.1.5/tg-ladder-x86_64-apple-darwin.tar.xz"
      sha256 "2f52c129b77fbbd7c11004da10d01cf27f59ddf0e8053e3d0716fa766aef6fe1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Tesseric/homebrew-termgames/releases/download/v0.1.5/tg-ladder-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "862007a66b16f2321c7b62cfcfc0cfe22160a93910b2e2d8df039348a9916422"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Tesseric/homebrew-termgames/releases/download/v0.1.5/tg-ladder-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1002387c012cc78ca7eabff7e24f784f0a7361c321930184f0b2e80ff6597725"
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
