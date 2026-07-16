{ config, lib, pkgs, ... }:
let
  email = "youwontforgetthis@gmail.com";
  # Public key only — safe to commit. The matching private key
  # (~/.ssh/id_ed25519) is a secret and is never stored in this repo.
  sshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILTurm2ONYlzVmFhscmeSHPI4o4JZWM2yL+mYA87uotY youwontforgetthis@gmail.com";
  privateKeyPath = "${config.home.homeDirectory}/.ssh/id_ed25519";
  allowedSigners = "${config.home.homeDirectory}/.config/git/allowed_signers";
in
{
  programs.git = {
    enable = true;

    # Sign every commit and tag with SSH, reusing the ed25519 key.
    signing = {
      format = "ssh";
      key = privateKeyPath;
      signByDefault = true;
    };

    settings = {
      user.name = "Max Edwards";
      user.email = email;
      init.defaultBranch = "main";
      tag.gpgSign = true;
      # Lets `git log --show-signature` / `git verify-commit` validate locally.
      gpg.ssh.allowedSignersFile = allowedSigners;
    };
  };
  # Maps the committer email to the signing public key for local verification.
  home.file.".config/git/allowed_signers".text = ''
    ${email} ${sshPublicKey}
  '';
}
