class WasmBindgen < Formula
  desc "Facilitating high-level interactions between Wasm modules and JavaScript"
  homepage "https://wasm-bindgen.github.io/wasm-bindgen/"
  url "https://github.com/wasm-bindgen/wasm-bindgen/archive/refs/tags/0.2.116.tar.gz"
  sha256 "538d1fdddc0b4334bd3e4c79efdb4404c5f86bc1b6954494a3f74006e6515fdc"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "723905fe498412b910a350e3c46fa3adf10ffdb3345235faa9397c75c01cb24e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70fb104d036f072ae4e04d7286e6d23e59e98f0d1a317484ee6a5c7051ab62d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27dd2f21976392fd12432e25690e26edbd4ae7303585c4679819990978e0b44c"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf0858ab88d8890334bc5b1cc0946058f7efd7782f6a42460cb979baa3048623"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b884c0300c4e9f81a462f61aa95172303c269667ac0be24330eea1d27bd77440"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "152c1c6bb6dfe386cd95ffabd3244cb3bf282cbb74162e9b8f100bf77dbf36dd"
  end

  depends_on "rust" => :build
  depends_on "node" => :test
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wasm-bindgen --version")

    (testpath/"src/lib.rs").write <<~RUST
      use wasm_bindgen::prelude::*;

      #[wasm_bindgen]
      extern "C" {
          fn alert(s: &str);
      }

      #[wasm_bindgen]
      pub fn greet(name: &str) {
          alert(&format!("Hello, {name}!"));
      }
    RUST
    (testpath/"Cargo.toml").write <<~TOML
      [package]
      authors = ["The wasm-bindgen Developers"]
      edition = "2021"
      name = "hello_world"
      publish = false
      version = "0.0.0"

      [lib]
      crate-type = ["cdylib"]

      [dependencies]
      wasm-bindgen = "#{version}"
    TOML
    (testpath/"package.json").write <<~JSON
      {
        "name": "hello_world",
        "version": "0.0.0",
        "type": "module"
      }
    JSON
    (testpath/"index.js").write <<~JS
      globalThis.alert = console.log;
      import { greet } from './pkg/hello_world.js';

      greet('World');
    JS

    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "stable"
    system "rustup", "target", "add", "wasm32-unknown-unknown"

    # Prevent Homebrew/CI AArch64 CPU features from bleeding into wasm32 builds
    ENV.delete "RUSTFLAGS"
    ENV.delete "CARGO_ENCODED_RUSTFLAGS"

    # Explicitly enable reference-types to resolve "failed to find intrinsics" error
    ENV["RUSTFLAGS"] = "-C target-feature=+reference-types"
    system "cargo", "build", "--target", "wasm32-unknown-unknown", "--manifest-path", "Cargo.toml"
    system bin/"wasm-bindgen", "target/wasm32-unknown-unknown/debug/hello_world.wasm",
                              "--out-dir", "pkg", "--reference-types"

    output = shell_output("node index.js")
    assert_match "Hello, World!", output.strip
  end
end
