{ hardware, lib, ... }:
{
    services.xserver = {
      exportConfiguration = true;
      videoDrivers =
        (lib.optionals (hardware "gpuAmd") [ "amdgpu" ])
        ++ (lib.optionals (hardware "gpuNvidia") [ "nvidia" ])
        ++ [ "modesetting" ];
      xkb = {
        layout = "de";
        variant = "";
      };
    };
}