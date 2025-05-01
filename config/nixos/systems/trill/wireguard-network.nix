{ ... }:
let
  # This peer's IPv4 and IPv6 addresses
  wgIpv4 = "10.4.1.4";
  # wgIpv6 = "1:2:3:4::";

  # Variables controlling connection marks and routing tables IDs. You probably
  # don't need to touch this.
  wgFwMark = 5241;
in
{
  systemd.network = {
    enable = true;
    netdevs."15-wgbrum0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wgbrum0";
        MTUBytes = "1420";
      };
      wireguardConfig = {
        PrivateKeyFile = "/wireguard-trill-private";
        FirewallMark = wgFwMark;
        RouteTable = "off";
      };
      wireguardPeers = [
        {
          wireguardPeerConfig = {
            PublicKey = "ST3pNe+2TOrZuqC9e92h8+LkeXuhoBWRYjdSOyytTmk=";
            # Depending on the connection, add a pre-shared key file
            # PresharedKeyFile = "/path/to/preshared-key";
            Endpoint = "r.dyn.uint.one:51820";
            AllowedIPs = [ "10.0.0.0/8" ];
            PersistentKeepalive = 25;
            RouteTable = "main";
          };
        }
      ];
    };
    networks."15-wgbrum0" = {
      matchConfig.Name = "wgbrum0";
      # Set to this peer's assigned Wireguard address
      address = [
        "${wgIpv4}/32"
        # "${wgIpv6}/128"
      ];
      networkConfig = {
        # If DNS requests should go to a specific nameserver when the tunnel is
        # established, uncomment this line and set it to the address of that
        # nameserver. But see the note at the bottom of this page.
        DNS = "1.0.0.1";
      };
      linkConfig = {
        ActivationPolicy = "manual";
        RequiredForOnline = false;
      };
    };
  };

  networking.nftables = {
    enable = true;
    # iifname != "wgbrum0" ip6 daddr ${wgIpv6} fib saddr type != local drop
    ruleset = ''
      table inet wg-wgbrum0 {
        chain preraw {
          type filter hook prerouting priority raw; policy accept;
          iifname != "wgbrum0" ip daddr ${wgIpv4} fib saddr type != local drop
        }
        chain premangle {
          type filter hook prerouting priority mangle; policy accept;
          meta l4proto udp meta mark set ct mark
        }
        chain postmangle {
          type filter hook postrouting priority mangle; policy accept;
          meta l4proto udp meta mark ${toString wgFwMark} ct mark set meta mark
        }
      }
    '';
  };
}
