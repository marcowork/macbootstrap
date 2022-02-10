

if ! command -v brew install coreutils &> /dev/null
    then brew install coreutils
    exit
else echo "coreutils is already installed"
fi