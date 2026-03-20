class Ingress2gateway < Formula
  desc "Convert Kubernetes Ingress resources to Kubernetes Gateway API resources"
  homepage "https://github.com/kubernetes-sigs/ingress2gateway"
  url "https://github.com/kubernetes-sigs/ingress2gateway/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "741f21ed50470f531d474e35253b8ba5aff6fc13e1ad8ca64049ece5cf1faae1"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/ingress2gateway.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19f1d9a3652f55e3469d0a6b6fdcc5a59e62fdb0591797e6c541e347535fd6ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19f1d9a3652f55e3469d0a6b6fdcc5a59e62fdb0591797e6c541e347535fd6ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19f1d9a3652f55e3469d0a6b6fdcc5a59e62fdb0591797e6c541e347535fd6ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "fda5b0dea1e86df82a07f08cc65f37e5ce8089b92e608272406a3b0551c21f6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31a12392fde4047e27597340d74968a952054c0a0316b82e165cd04e80ea049a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "837f74795b0f866473130c6aae03f2b829ea23b17fcc5d51eef45394912db239"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubernetes-sigs/ingress2gateway/pkg/i2gw.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ingress2gateway", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"test.yml").write <<~YAML
      apiVersion: networking.k8s.io/v1
      kind: Ingress
      metadata:
        name: foo
        namespace: bar
        annotations:
          cert-manager.io/cluster-issuer: "letsencrypt-prod"
        labels:
          name: foo
      spec:
        ingressClassName: nginx
        rules:
        - host: foo.bar
          http:
            paths:
            - pathType: Prefix
              path: "/"
              backend:
                service:
                  name: foo-bar
                  port:
                    number: 443
    YAML

    expected = <<~YAML
      apiVersion: gateway.networking.k8s.io/v1
      kind: Gateway
      metadata:
        annotations:
          gateway.networking.k8s.io/generator: ingress2gateway-#{version}
        name: nginx
        namespace: bar
      spec:
        gatewayClassName: nginx
        listeners:
        - hostname: foo.bar
          name: foo-bar-http
          port: 80
          protocol: HTTP
      ---
      apiVersion: gateway.networking.k8s.io/v1
      kind: HTTPRoute
      metadata:
        annotations:
          gateway.networking.k8s.io/generator: ingress2gateway-#{version}
        name: foo-foo-bar
        namespace: bar
      spec:
        hostnames:
        - foo.bar
        parentRefs:
        - name: nginx
        rules:
        - backendRefs:
          - name: foo-bar
            port: 443
          matches:
          - path:
              type: PathPrefix
              value: /
          name: rule-0
      status:
        parents: []
    YAML

    output = shell_output("#{bin}/ingress2gateway print --providers ingress-nginx --input-file #{testpath}/test.yml")
    assert_equal expected.chomp, output.chomp
  end
end
