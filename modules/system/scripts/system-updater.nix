{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  environment.etc = {
    "scripts/nix-diff.sh" = {
      text = ''
        #!/usr/bin/env nix-shell
        #! nix-shell -i bash
        #! nix-shell -p bash nvd coreutils
        #! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz
        
        gen=$(readlink /nix/var/nix/profiles/system | cut -d- -f2)
        oldgen=$(($gen - 1))
        nvd diff /nix/var/nix/profiles/system-{$oldgen,$gen}-link
     '';
      mode = "0555";
    };
  };
}
