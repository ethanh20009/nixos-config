{lib, ...}: {
  options.myConfig.nvf = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable NVF configuration";
    };
    companionLocal = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable local companion (Claude Code) settings";
    };
    companion = lib.mkOption {
      default = "gemini";
      type = lib.types.enum ["gemini" "claude"];
      description = "Which code companion to use. Available: gemini, claude";
    };
  };
}
