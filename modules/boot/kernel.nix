{ ... }:
{
    kernel = {
      enable = true;
      randstructSeed = "";
      sysctl = {
        "kernel.sched_autogroup_enabled" = 0;
        "kernel.sched_cfs_bandwidth_slice_us" = 3000;
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.core.default_qdisc" = "fq";
        "net.core.mem_max" = null;
        "net.core.wmem_max" = null;
        "vm.dirty_background_ratio" = 5;
        "vm.dirty_ratio" = 10;
        "vm.swappiness" = 180;
        "vm.vfs_cache_pressure" = 50;
      };
      sysfs = { };
    };
}