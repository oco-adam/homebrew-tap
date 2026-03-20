class Theda < Formula
  desc "CLI for the Theda application platform"
  homepage "https://github.com/oco-adam/theda"
  url "https://github.com/oco-adam/theda.git", tag: "v0.1.4"
  license "MIT"

  depends_on "opam" => :build
  depends_on "ocaml" => :build

  def install
    ENV["OPAMROOT"] = buildpath/".opam"

    # Keep the build hermetic and reuse Homebrew's OCaml instead of compiling
    # another compiler into opam's default switch.
    system "opam", "init", "--bare", "--no-setup", "--disable-sandboxing", "-y"
    system "opam", "switch", "create", ".", "--packages=ocaml-system", "-y"

    # Install dependencies and build against the local switch.
    system "opam", "exec", "--switch=.", "--", "opam", "install", ".", "--deps-only", "-y"
    system "opam", "exec", "--switch=.", "--", "dune", "build", "@install"

    # Install the actual compiled binaries rather than Dune's install-tree aliases.
    bin.install "_build/default/bin/main.exe" => "theda"
    bin.install "_build/default/bin/create_theda_app.exe" => "create-theda-app"
    bin.install "scripts/theda-watch" => "theda-watch"
  end

  test do
    assert_match "usage:", shell_output("#{bin}/theda --help")
    assert_match "Usage: create-theda-app", shell_output("#{bin}/create-theda-app --help")
  end
end
