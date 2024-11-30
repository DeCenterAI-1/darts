#!/bin/sh
# shellcheck shell=dash

set -u

GITHUB_ORG=DecenterAI-1
GITHUB_REPO=darts

PRE_RELEASE=${PRE_RELEASE:=false}
DARTS_HTTP_REQUEST_CLI=${DARTS_HTTP_REQUEST_CLI:="curl"}

version=${version:="v0.204.0"}

getLatestRelease() {

    # /latest ignores pre-releases, see https://docs.github.com/en/rest/releases/releases#get-the-latest-release
    # local tag_regex='v[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9]+)*)' # not cactching -alpha.1
    local tag_regex='v[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)*)*'
    
    if [ "$PRE_RELEASE" = "true" ]; then
        echo "Installing most recent pre-release version..."
        local dartsReleaseUrl="https://api.github.com/repos/${GITHUB_ORG}/${GITHUB_REPO}/releases?per_page=1"
    else
        local dartsReleaseUrl="https://api.github.com/repos/${GITHUB_ORG}/${GITHUB_REPO}/releases/latest"
    fi
    local latest_release=""

    echo "darts release url $dartsReleaseUrl"

    if [ "$DARTS_HTTP_REQUEST_CLI" = "curl" ]; then
        echo "using curl"
        latest_release=$(curl -s $dartsReleaseUrl  | grep \"tag_name\" | grep -E -i "\"$tag_regex\"" | awk 'NR==1{print $2}' | sed -n 's/\"\(.*\)\",/\1/p')
    else
        echo "using wget"
        latest_release=$(wget -q --header="Accept: application/json" -O - $dartsReleaseUrl | grep \"tag_name\" | grep -E -i "^$tag_regex$" | awk 'NR==1{print $2}' |  sed -n 's/\"\(.*\)\",/\1/p')
    fi
    echo "latest release is $latest_release"
    version=${latest_release}
    echo "$latest_release"
}

detect_os_info() {
  OSARCH=$(uname -m | awk '{if ($0 ~ /arm64|aarch64/) print "arm64"; else if ($0 ~ /x86_64|amd64/) print "amd64"; else print "unsupported_arch"}') && export OSARCH
  OSNAME=$(uname -s | awk '{if ($1 == "Darwin") print "darwin"; else if ($1 == "Linux") print "linux"; else print "unsupported_os"}') && export OSNAME;

  if  [ "$OSNAME" = "unsupported_os" ] || [ "$OSARCH" = "unsupported_arch" ]; then
    echo "Unsupported OS or architecture"
    echo "Checkout if our latest releases support $OSARCH_$OSNAME: https://github.com/DecenterAI-1/darts/releases/latest"
    exit 1
  fi
 
} 

install_darts() {
  DARTS_LOC=${DARTS_LOC:-"/tmp/darts"}
  getLatestRelease
  echo "installing darts:$version"
    rurl=https://github.com/DecenterAI-1/darts/releases/download/$version/darts-$OSNAME-$OSARCH
  
  echo "release url=$rurl"
  curl -sSL -o $DARTS_LOC $rurl
  chmod +x $DARTS_LOC
  # $DARTS_LOC version
#  read -p "Do you want to install darts? (y/n): " choice
#    case "$choice" in
#      y|Y )
#        cp darts /usr/local/bin/
#        ;;
#      n|N )
#        echo "darts installation canceled."
#        ;;
#      * )
#        echo "Invalid choice. Please enter y or n."
#        ;;
#    esac
  cp $DARTS_LOC /usr/local/bin/

  if command -v darts >/dev/null 2>&1; then
    echo "Installed darts successfully!"
  else
    echo "Darts installation failed or not found in /usr/local/bin"
  fi


  # if curl -sSL -o $DARTS_LOC.tar.gz "$rurl"; then
  #   echo "Download successful!"
    
  #   # Extract the downloaded file
  #   tar -xzf $DARTS_LOC.tar.gz -C /tmp
    
  #   # Make the extracted binaries executable (assuming they are in $DARTS_LOC)
  #   chmod +x $DARTS_LOC/*
    
  #   echo "Files extracted and made executable."
  # else
  #     echo "Error: Failed to download the file from $rurl" >&2
  #     exit 1
  # fi

}

install_bacalhau() {
#  bVersion=v1.2.1
#  wget https://github.com/bacalhau-project/bacalhau/releases/download/$bVersion/bacalhau_$bVersion_$OSNAME-$OSARCH.tar.gz
#  tar xfv bacalhau_$bVersion_$OSNAME-$OSARCH.tar.gz
#  mv bacalhau /usr/local/bin

  # Install bacalhau using curl

  curl -sL https://get.bacalhau.org/install.sh | BACALHAU_VERSION=v1.2.3 bash > /dev/null 2>&1

  ln -s /usr/local/bin/bacalhau /usr/local/bin/b

  echo "aliased b=bacalhau"
}

main() {
  detect_os_info

  if [ "$#" -eq 0 ]; then
    echo "Usage: $0 [all|bacalhau|darts]"
    exit 1
  fi

  if [ "$1" = "all" ]; then
    install_darts &
    install_bacalhau & 
    wait
  elif [ "$1" = "bacalhau" ]; then
    install_bacalhau
  elif [ "$1" = "darts" ]; then
    install_darts
  else
    echo "Usage: $0 [all|bacalhau|darts]"
    exit  1
  fi

  cat << EOF
        _______ _    _          _   _ _  __ __     ______  _    _
        |__   __| |  | |   /\   | \ | | |/ / \ \   / / __ \| |  | |
          | |  | |__| |  /  \  |  \| |   /   \ \_/ / |  | | |  | |
          | |  |  __  | / /\ \ |     |  <     \   /| |  | | |  | |
          | |  | |  | |/ ____ \| |\  |   \     | | | |__| | |__| |
          |_|  |_|  |_/_/    \_\_| \_|_|\_\    |_|  \____/ \____/

      Thanks for installing Darts! We're hoping to unlock an new world of more efficient AI Applications, and would really love to hear from you on how we can improve.

      - ⭐️ Give us a star on GitHub (https://github.com/DecenterAI-1/darts)
      - 🧑‍💻 Request a feature! (https://github.com/DecenterAI-1/darts/issues/new)
      - 🐛 File a bug! (https://github.com/DecenterAI-1/darts/issues/new)
      - ❓ Join our Community! (https://t.me/decenterai)
      - 📰 Checkout our docs! (https://decenter-ai.gitbook.io/)

      Thanks again!
      ~ Team DecenterAI
EOF
}


main "$@" || exit  1
