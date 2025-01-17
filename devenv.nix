# { pkgs, lib, config, inputs, ... }:
{ pkgs, ... }:
{
  devenv.debug = false; # https://devenv.sh/reference/options/#devenvdebug
  devenv.flakesIntegration = false; # https://devenv.sh/reference/options/#devenvflakesintegration

  packages = [
    pkgs.azure-cli # https://search.nixos.org/packages?channel=unstable&type=packages&show=azure-cli
  ];

  languages.nix = {
    enable = true; # https://devenv.sh/reference/options/#languagesnixenable
    lsp.package = pkgs.nil; # https://devenv.sh/reference/options/#languagesnixlsppackage
  };

  languages.ruby = {
    enable = true; # https://devenv.sh/reference/options/#languagesrubyenable
    package = pkgs.pkgs.ruby_3_4; # https://devenv.sh/reference/options/#languagesrubypackage
    bundler = {
      enable = true; # https://devenv.sh/reference/options/#languagesrubybundlerenable
      package = pkgs.bundler; # https://devenv.sh/reference/options/#languagesrubybundlerpackage
    };
  };

  enterShell = ''
    echo "Activate https://devenv.sh/ developer environment."
    echo "Nix '$(nix --version | awk '{print $3}')' located in '$(which nix)'."
    echo "Ruby '$(ruby --version | awk '{print $2}')' located in '$(which ruby)'."
    echo "Bundle '$(bundle --version | awk '{print $3}')' located in '$(which bundle)'."
    bundle
    echo ""
  ''; # https://devenv.sh/reference/options/#entershell

  git-hooks.hooks = {
    actionlint.enable = true;
    terraform-format.enable = true; # Note: Using OpenTofu's `fmt`. # https://github.com/cachix/git-hooks.nix/blob/a5a961387e75ae44cc20f0a57ae463da5e959656/README.md#L306
    tflint.enable = true;
    deadnix.enable = true;
    nil.enable = true;
    nixfmt-rfc-style.enable = true;
  }; # https://devenv.sh/reference/options/#git-hooks

  # https://devenv.sh/basics/
  # env.GREET = "devenv";

  # https://devenv.sh/packages/
  # packages = [ pkgs.git ];

  # https://devenv.sh/languages/
  # languages.rust.enable = true;

  # https://devenv.sh/processes/
  # processes.cargo-watch.exec = "cargo-watch";

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/
  # scripts.hello.exec = ''
  #   echo hello from $GREET
  # '';

  # enterShell = ''
  #   hello
  #   git --version
  # '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  # enterTest = ''
  #   echo "Running tests"
  #   git --version | grep --color=auto "${pkgs.git.version}"
  # '';

  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
