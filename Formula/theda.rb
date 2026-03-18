class Theda < Formula
  desc "CLI for the Theda application platform"
  homepage "https://github.com/oco-adam/theda"
  url "https://github.com/oco-adam/theda.git", tag: "v0.1.1"
  license "MIT"

  depends_on "opam" => :build
  depends_on "ocaml" => :build

  def install
    # Initialize opam if needed
    system "opam", "init", "--no-setup", "--disable-sandboxing", "-y" unless Dir.exist?(File.expand_path("~/.opam"))

    # Install dependencies and build
    system "opam", "exec", "--", "opam", "install", ".", "--deps-only", "-y"
    system "opam", "exec", "--", "dune", "build", "@install"

    # Install the binaries
    bin.install "_build/install/default/bin/theda"
    bin.install "_build/install/default/bin/create-theda-app"
    bin.install "scripts/theda-watch" => "theda-watch"
  end

  test do
    assert_match "usage:", shell_output("#{bin}/theda --help")
  end
end
