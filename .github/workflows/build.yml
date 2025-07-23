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

      - name: Set PATH for Theos
        run: echo "/tmp/theos/bin" >> $GITHUB_PATH

      - name: Install Homebrew dependencies
        run: |
          brew update
          brew install ldid dpkg make unzip zip

      - name: Clone Theos if missing
        run: |
          if [ ! -d "$THEOS" ]; then
            git clone --recursive https://github.com/theos/theos.git "$THEOS"
          else
            echo "Theos already cloned"
          fi

      - name: Build tweak with Theos
        shell: bash
        run: |
          source "$THEOS/setup.sh"
          make clean
          make

      - name: Debug: List built files
        run: ls -al ./obj/iphoneos/OfflineCatalogApp.app

      - name: Run build script to package app
        run: |
          chmod +x ./build.sh
          ./build.sh

      - name: Upload build artifact
        uses: actions/upload-artifact@v4
        with:
          name: OfflineCatalogApp.ipa
          path: OfflineCatalogApp.ipa
