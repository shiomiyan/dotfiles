export PATH="/usr/local/bin:$PATH"

# Java path
export PATH=$PATH:/Library/Java/JavaVirtualMachines/jdk-12.0.2.jdk/Contents/Home/bin
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-12.0.2.jdk/Contents/Home

export PATH=$HOME/.nodebrew/current/bin:$PATH

# cargo path
export PATH="$HOME/.cargo/bin:$PATH"

# binutils
export PATH="/usr/local/opt/binutils/bin:$PATH"

# laravel path setting
export PATH="$HOME/.composer/vendor/bin:$PATH"

# Open MPI: Version 2.0.4 path configuration
export PATH="$HOME/opt/usr/local/bin/:$PATH"

# AWS CLI configuration
export PATH="$HOME/.local/bin:$PATH"

# cloud_sql_proxy (GCP)
export PATH="$HOME/:$PATH"

# Go lang
export GOPATH="$HOME/go/"
export PATH="$GOPATH/bin:$PATH"

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# llvm
export PATH="/usr/local/opt/llvm/bin:$PATH"

# gcc - g++
export PATH=$PATH:/usr/local/bin
