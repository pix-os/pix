[4mnixos-rebuild[24m(8)                                                    System Manager's Manual                                                    [4mnixos-rebuild[24m(8)

[1mNAME[0m
       nixos-rebuild - reconfigure a NixOS machine

[1mSYNOPSIS[0m
       [4mnixos-rebuild[24m  [--verbose]  [--quiet] [--max-jobs MAX_JOBS] [--cores CORES] [--log-format LOG_FORMAT] [--keep-going] [--keep-failed] [--fallback] [--re‐
       pair] [--option OPTION OPTION] [--builders BUILDERS] [--include INCLUDE]
            [--print-build-logs] [--show-trace] [--accept-flake-config] [--refresh] [--impure] [--offline] [--no-net] [--recreate-lock-file] [--no-update-lock-
       file] [--no-write-lock-file] [--no-registries] [--commit-lock-file]
            [--update-input UPDATE_INPUT] [--override-input OVERRIDE_INPUT OVERRIDE_INPUT] [--no-build-output] [--use-substitutes] [--help]  [--debug]  [--file
       FILE] [--attr ATTR] [--flake [FLAKE]] [--no-flake] [--install-bootloader]
            [--profile-name  PROFILE_NAME]  [--specialisation  SPECIALISATION] [--rollback] [--upgrade] [--upgrade-all] [--json] [--ask-sudo-password] [--sudo]
       [--no-reexec]
            [--build-host BUILD_HOST] [--target-host TARGET_HOST] [--no-build-nix] [--image-variant IMAGE_VARIANT]
            [{switch,boot,test,build,edit,repl,dry-build,dry-run,dry-activate,build-image,build-vm,build-vm-with-bootloader,list-generations}]

[1mDESCRIPTION[0m
       This command updates the system so that it corresponds to the configuration specified in /etc/nixos/configuration.nix, /etc/nixos/flake.nix or the  file
       and  attribute  specified  by  the  [1m--file  [22mand/or [1m--attr [22moptions. Thus, every time you modify the configuration or any other NixOS module, you must run
       [1mnixos-rebuild [22mto make the changes take effect. It builds the new system in /nix/store, runs its activation script, and stop and  (re)starts  any  system
       services if needed. Please note that user services need to be started manually as they aren't detected by the activation script at the moment.

       This command has one required argument, which specifies the desired operation. It must be one of the following:

       [1mswitch[0m
           Build  and  activate  the  new configuration, and make it the boot default. That is, the configuration is added to the GRUB boot menu as the default
           menu entry, so that subsequent reboots will boot the system into the new configuration. Previous configurations activated with nixos-rebuild  switch
           or nixos-rebuild boot remain available in the GRUB menu.

           Note that if you are using specializations, running just nixos-rebuild switch will switch you back to the unspecialized, base system — in that case,
           you might want to use this instead:

               $ nixos-rebuild switch --specialisation your-specialisation-name

           This command will build all specialisations and make them bootable just like regular nixos-rebuild switch does — the only thing different is that it
           will  switch  to  given  specialisation instead of the base system; it can be also used to switch from the base system into a specialised one, or to
           switch between specialisations.

       [1mboot[0m
           Build the new configuration and make it the boot default (as with [1mnixos-rebuild switch[22m), but do not activate it. That is, the  system  continues  to
           run the previous configuration until the next reboot.

       [1mtest[0m
           Build and activate the new configuration, but do not add it to the GRUB boot menu. Thus, if you reboot the system (or if it crashes), you will auto‐
           matically revert to the default configuration (i.e. the configuration resulting from the last call to [1mnixos-rebuild switch [22mor [1mnixos-rebuild boot[22m).

           Note  that  if you are using specialisations, running just nixos-rebuild test will activate the unspecialised, base system — in that case, you might
           want to use this instead:

               $ nixos-rebuild test --specialisation your-specialisation-name

           This command can be also used to switch from the base system into a specialised one, or to switch between specialisations.

       [1mbuild[0m
           Build the new configuration, but neither activate it nor add it to the GRUB boot menu. It leaves a symlink named result in  the  current  directory,
           which points to the output of the top-level “system” derivation. This is essentially the same as doing

               $ nix-build /path/to/nixpkgs/nixos -A system

           Note that you do not need to be root to run [1mnixos-rebuild build[22m.

       [1mdry-build[0m
           Show what store paths would be built or downloaded by any of the operations above, but otherwise do nothing.

       [1mdry-activate[0m
           Build  the new configuration, but instead of activating it, show what changes would be performed by the activation (i.e. by [1mnixos-rebuild [22mtest). For
           instance, this command will print which systemd units would be restarted. The list of changes is not guaranteed to be complete.

       [1medit[0m
           Opens [4mconfiguration.nix[24m in the default editor.

       [1mrepl[0m
           Opens the configuration in [1mnix repl[22m.

       [1mbuild-image[0m
           Build a disk-image variant, pre-configured for the given platform/provider. Select a variant with the [1m--image-variant [22moption or run without any  op‐
           tions to get a list of available variants.

               $ nixos-rebuild build-image --image-variant proxmox

       [1mbuild-vm[0m
           Build  a  script that starts a NixOS virtual machine with the desired configuration. It leaves a symlink [4mresult[24m in the current directory that points
           (under ‘result/bin/run-[4mhostname[24m-vm’) at the script that starts the VM. Thus, to test a NixOS configuration in a virtual machine, you should  do  the
           following:

               $ nixos-rebuild build-vm && ./result/bin/run-*-vm

           The  VM  is  implemented using the ‘qemu’ package. For best performance, you should load the ‘kvm-intel’ or ‘kvm-amd’ kernel modules to get hardware
           virtualisation.

           The VM mounts the Nix store of the host through the 9P file system. The host Nix store is read-only, so Nix commands that modify the Nix store  will
           not  work  in  the  VM. This includes commands such as [1mnixos-rebuild[22m; to change the VM’s configuration, you must halt the VM and re-run the commands
           above.

           The VM has its own ext3 root file system, which is automatically created when the VM is first started, and is persistent across reboots of  the  VM.
           It is stored in ‘./[4mhostname[24m.qcow2’.

       [1mbuild-vm-with-bootloader[0m
           Like  build-vm,  but  boots using the regular boot loader of your configuration (e.g. GRUB 1 or 2), rather than booting directly into the kernel and
           initial ramdisk of the system. This al‐ lows you to test whether the boot loader works correctly. However, it does not  guarantee  that  your  NixOS
           configuration  will boot successfully on the host hardware (i.e., after running [1mnixos-rebuild switch[22m), because the hardware and boot loader configu‐
           ration in the VM are different. The boot loader is installed on an automatically generated virtual disk containing a /boot partition.

       [1mlist-generations [--json][0m
           List the available generations in a similar manner to the boot loader menu. It shows the generation number, build date and time, NixOS version, ker‐
           nel version and the configuration revi‐ sion. There is also a json version of output available.

[1mOPTIONS[0m
       [1m--upgrade, --upgrade-all[0m
           Update the root user's channel named ‘nixos’ before rebuilding the system.

           In addition to the ‘nixos’ channel, the root user's channels which have a file named ‘.update-on-nixos-rebuild’ in their base directory will also be
           updated.

           Passing [1m--upgrade-all [22mupdates all of the root user's channels.

       [1m--install-bootloader[0m
           Causes the boot loader to be (re)installed on the device specified by the relevant configuration options.

       [1m--no-reexec[0m
           Normally, [1mnixos-rebuild [22mfirst finds and builds itself from the [4mconfig.system.build.nixos-rebuild[24m attribute from the current user  channel  or  flake
           and  exec into it. This allows [1mnixos-rebuild [22mto run with the latest bug-fixes. This option disables it, using the current [1mnixos-rebuild [22minstance in‐
           stead.

       [1m--rollback[0m
           Instead of building a new configuration as specified by [4m/etc/nixos/configuration.nix[24m, roll back to the previous configuration. (The previous config‐
           uration is defined as the one before the “current” generation of the Nix profile [4m/nix/var/nix/profiles/system[24m.)

       [1m--builders [4m[22mbuilder-spec[0m
           Allow ad-hoc remote builders for building the new system. This requires the user executing [1mnixos-rebuild  [22m(usually  root)  to  be  configured  as  a
           trusted  user  in the Nix daemon. This can be achieved by using the [4mnix.settings.trusted-users[24m NixOS option. Examples values for that option are de‐
           scribed in the “Remote builds” chapter in the Nix manual, (i.e. ‘--builders "ssh://bigbrother x86_64-linux"’). By specifying an empty string  exist‐
           ing builders specified in /etc/nix/machines can be ignored: ‘--builders ""’ for example when they are not reachable due to network connectivity.

       [1m--profile-name [4m[22mname[24m, [1m-p [4m[22mname[0m
           Instead of using the Nix profile [4m/nix/var/nix/profiles/system[24m to keep track of the current and previous system configurations, use [4m/nix/var/nix/pro‐[0m
           [4mfiles/system-profiles/name[24m. When you use GRUB 2, for every system profile created with this flag, NixOS will create a submenu named “NixOS - Profile
           [4mname[24m” in GRUB's boot menu, containing the current and previous configurations of this profile.

           For instance, if you want to test a configuration file named [4mtest.nix[24m without affecting the default system profile, you would do:

               $ nixos-rebuild switch -p test -I nixos-config=./test.nix

           The new configuration will appear in the GRUB 2 submenu “NixOS - Profile ‘test’”.

       [1m--specialisation [4m[22mname[24m, [1m-c [4m[22mname[0m
           Activates given specialisation; when not specified, switching and testing will activate the base, unspecialised system.

       [1m--image-variant [4m[22mvariant[0m
           Selects  an  image  variant to build from the [4mconfig.system.build.images[24m attribute of the given configuration. A list of variants is printed if this
           option remains unset.

       [1m--build-host [4m[22mhost[0m
           Instead of building the new configuration locally, use the specified host to perform the build. The host needs to be accessible with ssh,  and  must
           be able to perform Nix builds. If the option [1m--target-host [22mis not set, the build will be copied back to the local machine when done.

           You can include a remote user name in the host name ([4muser@host[24m). You can also set ssh options by defining the NIX_SSHOPTS environment variable.

       [1m--target-host [4m[22mhost[0m
           Specifies  the  NixOS target host. By setting this to something other than an empty string, the system activation will happen on the remote host in‐
           stead of the local machine. The remote host needs to be accessible over [1mssh[22m, and for the commands [1mswitch[22m, [1mboot [22mand [1mtest [22myou need root access.

           If [1m--build-host [22mis not explicitly specified or empty, building will take place locally.

           You can include a remote user name in the host name ([4muser@host[24m). You can also set ssh options by defining the NIX_SSHOPTS environment variable.

           Note that [1mnixos-rebuild [22mhonors the [4mnixpkgs.crossSystem[24m setting of the given configuration but disregards the true architecture of the  target  host.
           Hence the [4mnixpkgs.crossSystem[24m setting has to match the target platform or else activation will fail.

       [1m--use-substitutes[0m
           When  set, nixos-rebuild will add [1m--use-substitutes [22mto each invocation of [4mnix[24m [4mcopy[24m. This will only affect the behavior of nixos-rebuild if [1m--target-[0m
           [1mhost [22mor [1m--build-host [22mis also set. This is useful when the target-host connection to cache.nixos.org is faster than the connection between hosts.

       [1m--sudo[0m
           When set, [1mnixos-rebuild [22mprefixes activation commands with sudo. Setting this option allows deploying as a non-root user.

       [1m--ask-sudo-password[22m, [1m-S[0m
           When set, [1mnixos-rebuild [22mwill ask for sudo password for remote activation (i.e.: on [1m--target-host[22m) at the start of the build process. Implies [1m--sudo[22m.

       [1m--file [4m[22mpath[24m, [1m-f [4m[22mpath[0m
           Enable and build the NixOS system from the specified file. The file must evaluate to an attribute set, and it must contain a valid NixOS  configura‐
           tion  at  attribute  [4mattrPath[24m.  This  is useful for building a NixOS system from a nix file that is not a flake or a NixOS configuration module. At‐
           tribute set a with valid NixOS configuration can be made using [4mnixos[24m function in nixpkgs or importing  and  calling  nixos/lib/eval-config.nix  from
           nixpkgs. If specified without [1m--attr [22moption, builds the configuration from the top-level attribute of the file.

       [1m--attr [4m[22mattrPath[24m, [1m-A [4m[22mattrPath[0m
           Enable  and build the NixOS system from nix file and use the specified attribute path from file specified by the [1m--file [22moption. If specified without
           [1m--file [22moption, uses [4mdefault.nix[24m in current directory.

       [1m--flake [4m[22mflake-uri[#name][24m, [1m-F [4m[22mflake-uri[#name][0m
           Build the NixOS system from the specified flake. It defaults to the directory containing the target of the symlink [4m/etc/nixos/flake.nix[24m, if  it  ex‐
           ists. The flake must contain an output named ‘nixosConfigurations.name’. If name is omitted, it default to the current host name.

       [1m--no-flake[0m
           Do  not  imply  [1m--flake [22mif [4m/etc/nixos/flake.nix[24m [4mexists[24m. With this option, it is possible to build non-flake NixOS configurations even if the current
           NixOS systems uses flakes.

       In addition, [1mnixos-rebuild [22maccepts following options from nix commands that the tool calls:

       Flake-related options:

       [1m--accept-flake-config[22m, [1m--refresh[22m, [1m--impure[22m, [1m--offline[22m,  [1m--no-net  --recreate-lock-file[22m,  [1m--no-update-lock-file[22m,  [1m--no-write-lock-file[22m,  [1m--no-registries[22m,
       [1m--commit-lock-file[22m, [1m--update-input [4m[22minput-path[24m, [1m--override-input [4m[22minput-path[24m [4mflake-url[0m

       Builder options:

       [1m--verbose,   -v[22m,   [1m--quiet[22m,   [1m--log-format[22m,  [1m--no-build-output[22m, [1m-Q[22m, [1m--no-link[22m, [1m--max-jobs[22m, [1m-j[22m, [1m--cores[22m, [1m--keep-going[22m, [1m-k[22m, [1m--keep-failed[22m, [1m-K[22m, [1m--fallback[22m,
       [1m--include[22m, [1m-I[22m, [1m--option[22m, [1m--repair[22m, [1m--builders[22m, [1m--print-build-logs[22m, [1m-L[22m, [1m--show-trace[0m

       See the Nix manual, [1mnix flake lock --help [22mor [1mnix-build --help [22mfor details.

[1mENVIR