{ pkgs, modulesPath, ... }: {
  imports = [ "${modulesPath}/virtualisation/amazon-image.nix" ];
  ec2.hvm = true;

  networking.hostName = "TestConfig";
  environment.systemPackages = [ pkgs.neovim ];


  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.defaultSession = "none+xmonad";
  services.xserver.windowManager = {       # Open configuration for the window manager.
    #dwm.enable = true;                  # Enable xmonad.
    xmonad.enable = true;                  # Enable xmonad.
    xmonad.enableContribAndExtras = true;  # Enable xmonad contrib and extras.
    xmonad.extraPackages = hpkgs: [        # Open configuration for additional Haskell packages.
      hpkgs.xmonad-contrib                 # Install xmonad-contrib.
      hpkgs.xmonad-extras                  # Install xmonad-extras.
      hpkgs.xmonad                         # Install xmonad itself.
      hpkgs.dbus
      hpkgs.monad-logger
    ];
    #xmonad.config = ./config/xmonad/config.hs;                # Enable xmonad.
    #xmonad.config = ./.config/config.hs;                # Enable xmonad.
    #xmonad.config = ./config.hs;                # Enable xmonad.
  };

  services.syncthing = {
    enable = true;
    overrideDevices = true;     # overrides any devices added or deleted through the WebUI
    overrideFolders = true;     # overrides any folders added or deleted through the WebUI
    devices = {
      "homePc" = { id = "C2CLAGA-4AZMGF4-QI75BRD-2QVIXUE-RK6PXFI-LCBV6L7-KXS22SU-EBIPDA7";
 };
      "workPc" = { id = "IKII2EG-O2YCQ64-6RI2ADV-VHXWB7P-XKNN4HH-5H3PJG5-B7AV44K-LTWGCQG";
 };
    };
    #folders = {
    #  "Documents" = {        # Name of folder in Syncthing, also the folder ID
    #    path = "/home/myusername/Documents";    # Which folder to add to Syncthing
    #    devices = [ "device1" "device2" ];      # Which devices to share the folder with
    #  };
    #  "Example" = {
    #    path = "/home/myusername/Example";
    #    devices = [ "device1" ];
    #    ignorePerms = false;     # By default, Syncthing doesn't sync file permissions. This line enables it for this folder.
    #  };
    #};
  };
}

