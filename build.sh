name: Build OfflineCatalogApp

on:
  push:
    branches:
      - main
  pull_request:

jobs:
  build:
    runs-on: macos-14

    env:
      THEOS: /tmp/theos

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Install Homebrew dependencies
        run: |
          brew update
          brew install ldid dpkg make unzip zip
          echo "$(brew --prefix)/bin" >> $GITHUB_PATH

      - name: Clone Theos if missing
        run: |
          if [ ! -d "$THEOS" ]; then
            git clone --recursive https://github.com/theos/theos.git "$THEOS"
          else
            echo "Theos directory already exists, skipping clone"
          fi

      - name: Set PATH for Theos binaries
        run: echo "/tmp/theos/bin" >> $GITHUB_PATH

      - name: Debug: Show installed tools versions
        run: |
          echo "ldid version:"
          ldid -v
          echo "dpkg version:"
          dpkg --version
          echo "make version:"
          make --version

      - name: Build tweak with Theos
        shell: bash
        run: |
          source "$THEOS/setup.sh"
          make clean
          make

      - name: Run build.sh to package IPA
        run: |
          chmod +x ./build.sh
          ./build.sh

      - name: Upload IPA artifact
        uses: actions/upload-artifact@v4
        with:
          name: OfflineCatalogApp.ipa
          path: OfflineCatalogApp.ipa

      - name: Confirm artifact upload
        run: echo "OfflineCatalogApp.ipa has been uploaded successfully"
