{ ... }:
{
    users = {
        allowNoPasswordLogin = false;
        defaultUserHome = "/home";
        defaultUserShell = "/bin/sh";
        enforceIdUniqueness = true;
        mutableUsers = true;
        groups = { };
    };
}