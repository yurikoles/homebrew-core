class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify/"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-14.2.4.tgz"
  sha256 "2fd867f654d78518c9a312e473961abd8c6535d3d7d853a7f132d81243f6f220"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "174bfe5c88330990fd4d198b9fa5c62ebf75691c64d51913b507a20fc421cbc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "174bfe5c88330990fd4d198b9fa5c62ebf75691c64d51913b507a20fc421cbc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "174bfe5c88330990fd4d198b9fa5c62ebf75691c64d51913b507a20fc421cbc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d461fb1ad77cd77c8f920fe99a5d979ebe08633f490508a2e19e85c7d2df4c77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "174bfe5c88330990fd4d198b9fa5c62ebf75691c64d51913b507a20fc421cbc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d461fb1ad77cd77c8f920fe99a5d979ebe08633f490508a2e19e85c7d2df4c77"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    unless Hardware::CPU.intel?
      rm_r "#{libexec}/lib/node_modules/@aws-amplify/cli-internal/node_modules" \
           "/@aws-amplify/amplify-frontend-ios/resources/amplify-xcode"
    end

    # Remove non-native libsqlite4java files
    os = OS.kernel_name.downcase
    if Hardware::CPU.intel?
      arch = if OS.mac?
        "x86_64"
      else
        "amd64"
      end
    elsif OS.mac? # apple silicon
      arch = "aarch64"
    end
    node_modules = libexec/"lib/node_modules/@aws-amplify/cli-internal/node_modules"
    (node_modules/"amplify-dynamodb-simulator/emulator/DynamoDBLocal_lib").glob("libsqlite4java-*").each do |f|
      rm f if f.basename.to_s != "libsqlite4java-#{os}-#{arch}"
    end
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    require "open3"

    Open3.popen3(bin/"amplify", "status", "2>&1") do |_, stdout, _|
      assert_match "No Amplify backend project files detected within this folder.", stdout.read
    end

    assert_match version.to_s, shell_output("#{bin}/amplify version")
  end
end
