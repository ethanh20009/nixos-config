{lib, ...}: {
  options.myConfig.tex = {
    enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Install Tex system wide";
    };
  };
}
