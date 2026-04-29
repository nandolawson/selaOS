{ configuration, lib, ... }:
{
    services.xserver = {
      exportConfiguration = true;
      videoDrivers =
        (lib.optionals (configuration.hardware "gpuAmd") [ "amdgpu" ])
        ++ (lib.optionals (configuration.hardware "gpuNvidia") [ "nvidia" ])
        ++ [ "modesetting" ];
      xkb = {
        layout = "de";
        variant = "";
      };
    };
}