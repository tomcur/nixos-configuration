self: super:
{
    mqttcli = super.buildGoPackage rec {
        name = "mqttcli-unstable-${version}";
        version = "2018-08-16";
        rev = "57273dc97a2e44f5c1bc0e469d47393bc3ed04e9";

        goPackagePath = "github.com/shirou/mqttcli";

        src = super.fetchgit {
            inherit rev;
            url = "https://github.com/shirou/mqttcli";
            sha256 = "0smkdcqr7iqmjh66kmnac4xxg0fk1kp6a43libl06fdznsd1jfhd";
        };

        goDeps = ./deps.nix;
        meta = {
           description = "MQTT shell client"; 
           exec = "mqttcli";
        };
    };
}
