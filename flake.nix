{
  description = "Nix Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Ruby environment with bundler
        rubyEnv = pkgs.ruby_3_3;

        # Build tools for native extensions
        buildInputs = with pkgs; [
          rubyEnv
          bundler
          git

          # Build tools for native gem extensions
          gcc
          gnumake
          pkg-config

          # Additional dependencies that gems might need
          zlib
          libxml2
          libxslt
          libyaml
          readline
          openssl
        ];

      in
      {
        devShells.default = pkgs.mkShell {
          inherit buildInputs;

          shellHook = ''
            echo "🚀 Jekyll development environment activated!"
            echo "📦 Ruby version: ${rubyEnv.version}"
            echo ""

            # Configure bundler to install gems locally
            export BUNDLE_PATH=vendor/bundle
            export GEM_HOME=$PWD/vendor/bundle/ruby/${rubyEnv.rubyVersion}
            export GEM_PATH=$GEM_HOME
            export PATH=$GEM_HOME/bin:$PATH

            # Build configuration for native extensions
            export BUNDLE_BUILD__JSON="--with-cflags=-Wno-error=implicit-function-declaration"
            export MAKE="make -j$NIX_BUILD_CORES"

            # Ensure bundle is available
            if [ ! -f "Gemfile.lock" ]; then
              echo "📥 Installing gems for the first time..."
              bundle install
            else
              echo "💡 Run 'bundle install' to install/update gems"
              echo "💡 Run 'bundle exec jekyll serve' to start the development server"
            fi
            echo ""
          '';
        };

        # Optional: Add a package output for building the site
        packages.default = pkgs.stdenv.mkDerivation {
          name = "sheeeng-github-io";
          src = ./.;

          nativeBuildInputs = buildInputs;

          buildPhase = ''
            export HOME=$TMPDIR
            export BUNDLE_PATH=vendor/bundle
            export GEM_HOME=$TMPDIR/gems
            export GEM_PATH=$GEM_HOME

            bundle config set --local path 'vendor/bundle'
            bundle install
            bundle exec jekyll build
          '';

          installPhase = ''
            mkdir -p $out
            cp -r _site/* $out/
          '';
        };
      }
    );
}
