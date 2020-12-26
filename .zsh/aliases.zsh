# aliases
alias ..="cd .."
alias vi="vim"
alias python="python3"
alias pip="pip3"
alias exa="exa --group-directories-first"

case "$OSTYPE" in
  drawin*)
    alias pbc="pbcopy"
    alias sortlaunchpad="defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock"
    #NOTE: https://iscinumpy.gitlab.io/post/omp-on-high-sierra/
    function gcc() {
      if [[ $1 == "-fopenmp" ]]; then
          command gcc -Xpreprocessor -fopenmp -lomp -I"$(brew --prefix libomp)/include" -L"$(brew --prefix libomp)/lib" "${@:2:($#-1)}"
      else
          command gcc "$@"
      fi
    }
  ;;
  linux*)
  ;;
esac
