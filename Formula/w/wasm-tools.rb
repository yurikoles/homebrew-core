class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.246.0.tar.gz"
  sha256 "1c9a3f5ecd12f57224907b2efa1a27b7f7ecdebb473f248887466424c159f849"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64bc3ee4a938c9b8a38280ec03e6c6d1e1fba4f3fcf89159a00bc4b1e674c699"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "476187331b8d336a11edf71f665e3b220552ce774ba81a102c19e84ba4670f1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1e947f9cf3a18121ec344a00fd21e890643487945aa0855442d772aff93e464"
    sha256 cellar: :any_skip_relocation, sonoma:        "863262908dd65bd0773a10ca7fe8e10373b3ccafcbf4bf368a355d7864f556a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a80bb458c4ae934959a16066517611f981309d23c6b8910160cc9d7bd34c74f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0328b96bdf620ef16df6b3b928ff03f1ef17e7fefd590f57d5fbbcde2c7c5c41"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"wasm-tools", "completion", shells: [:bash, :fish, :pwsh, :zsh])
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    system bin/"wasm-tools", "validate", testpath/"sum.wasm"

    expected = <<~EOS
      (module
        (type (;0;) (func (param i32 i32) (result i32)))
        (export "sum" (func 0))
        (func (;0;) (type 0) (param i32 i32) (result i32)
          local.get 0
          local.get 1
          i32.add
        )
      )
    EOS
    assert_equal expected, shell_output("#{bin}/wasm-tools print #{testpath}/sum.wasm")
  end
end
