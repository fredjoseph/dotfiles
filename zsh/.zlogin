(
  # Function to determine the need of a zcompile. If the .zwc file
  # does not exist, or the base file is newer, we need to compile.
  # These jobs are asynchronous, and will not impact the interactive shell
  zcompare() {
    if [[ -s ${1} && ( ! -s ${1}.zwc || ${1} -nt ${1}.zwc) ]]; then
      zcompile ${1}
    fi
  }

  setopt LOCAL_OPTIONS EXTENDED_GLOB

  # zcompile the completion cache; siginificant speedup.
  for file in ${ZDOTDIR:-${HOME}}/.zcomp^(*.zwc)(.); do
    zcompare ${file}
  done
  
) &!

# Activate "autocutsel" only if X server detected
if pgrep Xorg >&/dev/null; then
  autocutsel -selection PRIMARY -fork
  autocutsel -fork
fi