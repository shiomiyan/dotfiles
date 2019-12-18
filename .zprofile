export PATH="$HOME/.cargo/bin:$PATH"

export PATH=$PATH:/Library/Java/JavaVirtualMachines/jdk-12.0.2.jdk/Contents/Home/bin
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-12.0.2.jdk/Contents/Home

export PATH=$HOME/.nodebrew/current/bin:$PATH

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
alias pyenv="SDKROOT=$(xcrun --show-sdk-path) pyenv"
