# Returns a helper that clones a git repo (and configures extra remotes) during
# home-manager activation, idempotently.
{ lib, pkgs }:
{
  repoDir,
  cloneUrl,
  remotes ? { },
}:
lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  mkdir -p "$(dirname "${repoDir}")"

  if [ ! -e "${repoDir}" ]; then
    GIT_SSH_COMMAND="${pkgs.openssh}/bin/ssh" ${pkgs.git}/bin/git clone "${cloneUrl}" "${repoDir}"
  elif [ ! -d "${repoDir}/.git" ]; then
    echo "home-manager: ${repoDir} exists but is not a git repo" >&2
    exit 1
  fi

  cd "${repoDir}"
  ${lib.concatStringsSep "\n" (
    lib.mapAttrsToList (name: url: ''
      if ${pkgs.git}/bin/git remote get-url ${name} >/dev/null 2>&1; then
        ${pkgs.git}/bin/git remote set-url ${name} "${url}"
      else
        ${pkgs.git}/bin/git remote add ${name} "${url}"
      fi
    '') remotes
  )}
''
