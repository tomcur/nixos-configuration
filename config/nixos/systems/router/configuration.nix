{ config, pkgs, ... }:
let
  # Physical interface mappings
  if_wan = "enp1s0f3";
  if_lan = "enp1s0f2";
  if_laniptv = "enp1s0f1";
  secret = import ./secret.nix;
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.ip_forward" = 1;
    "net.ipv6.conf.all.use_tempaddr" = 2;
    "net.ipv6.conf.all.accept_ra" = 1;
  };
  # boot.extraModulePackages = [ config.boot.kernelPackages.wireguard ];

  age.secrets.wireguard-router-private = {
    file = ../../../../secrets/wireguard-router-private.age;
    owner = "root";
    group = "systemd-network";
    mode = "0440";
  };

  networking.hostName = "router";
  networking.domain = "home.arpa";
  networking.nameservers = [ "1.1.1.1" ];
  networking.useDHCP = false;

  services.resolved.enable = false;
  systemd.network = {
    enable = true;
    netdevs = {
      "20-wan" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "wan";
          MTUBytes = "1508"; # allow for baby jumbo frames
          Description = "Internet";
        };
        vlanConfig.Id = 6;
      };
      "21-waniptv" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "waniptv";
          Description = "Wan IPTV";
        };
        vlanConfig.Id = 4;
      };
      "22-languest" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "languest";
          Description = "Guest network";
        };
        vlanConfig.Id = 100;
      };
      "23-lansecure" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "lansecure";
          Description = "Secure network";
        };
        vlanConfig.Id = 200;
      };
      "24-wg0" = {
        netdevConfig = {
          Kind = "wireguard";
          MTUBytes = "1300";
          Name = "wg0";
        };
        extraConfig = ''
          [WireGuard]
          PrivateKeyFile=/run/agenix/wireguard-router-private
          ListenPort=51820

          [WireGuardPeer]
          # castor
          PublicKey=FIfmo6T2wwr9D1bP6lksDHEY5tRGzMm4Yj3Bq6F15ls=
          AllowedIPs=10.4.1.1

          [WireGuardPeer]
          # pollux
          PublicKey=/0gO1Thob6JSd9ryTtHpXCDiFgFYT6QiQ7FCgpk120U=
          AllowedIPs=10.4.1.2

          [WireGuardPeer]
          # op3
          PublicKey=TxkX5E9dGaocs501n6nEfLjOY0gHZCYNacjEusF2mVg=
          AllowedIPs=10.4.1.3
        '';
      };
    };
    networks = {
      "30-lan" = {
        matchConfig.Name = if_lan;
        address = [
          "10.0.0.1/16"
        ];
        networkConfig = {
          IPForward = "yes";
          LinkLocalAddressing = "no";
        };
        linkConfig = {
          RequiredForOnline = "routable";
        };
        vlan = [ "languest" "lansecure" ];
      };
      "30-wan" = {
        matchConfig.Name = if_wan;
        linkConfig = {
          RequiredForOnline = "carrier";
          MTUBytes = "1512"; # allow for baby jumbo frames + vlan overhead
        };
        vlan = [ "wan" "waniptv" ];
      };
      "30-ppp0" = {
        matchConfig.Name = "ppp0";
        networkConfig = {
          IPForward = "yes";
          LinkLocalAddressing = "no";
          DefaultRouteOnDevice = "yes";
        };
        linkConfig = {
          RequiredForOnline = "carrier";
        };
      };
      "31-waniptv" = {
        matchConfig.Name = "waniptv";
        networkConfig = {
          IPForward = "yes";
          DHCP = "ipv4";
          LinkLocalAddressing = "no";
        };
        dhcpV4Config = {
          UseDNS = false;
          UseRoutes = true;
          VendorClassIdentifier = "IPTV_RG";
          RequestOptions = [ 1 3 28 121 ];
        };
        linkConfig = {
          RequiredForOnline = "routable";
        };
      };
      "32-laniptv" = {
        matchConfig.Name = if_laniptv;
        address = [
          "10.2.0.1/16"
        ];
        networkConfig = {
          IPForward = "yes";
          LinkLocalAddressing = "no";
        };
        # linkConfig = {
        #   RequiredForOnline = "routable";
        # };
      };
      "33-wg0" = {
        matchConfig.Name = "wg0";
        address = [
          "10.4.0.1/16"
        ];
        networkConfig = {
          IPForward = "yes";
        };
        extraConfig = ''
        '';
      };
    };
  };

  services.pppd = {
    enable = true;
    peers = {
      isp = {
        autostart = true;
        enable = true;
        config = ''
          plugin rp-pppoe.so wan

          name "88-D2-74-BF-DA-7E@internet"
          password "internet"

          +ipv6
          ipv6cp-accept-local
          noipdefault
          usepeerdns
          defaultroute
          defaultroute6

          mtu 1500
          mru 1500

          lcp-echo-interval 20
          lcp-echo-failure 3

          persist
          maxfail 0
          holdoff 5
        '';
      };
    };
  };

  services.dnsmasq = {
    enable = true;
    settings.server = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    extraConfig = ''
      interface=${if_lan},${if_laniptv},wg0

      no-hosts
      domain=dyn.home.arpa

      # Default gateway
      dhcp-option=${if_lan},3,10.0.0.1
      dhcp-option=${if_lan},6,10.0.0.1
      # dhcp-option=${if_lan},121,0.0.0.0/0,10.0.0.1
      
      dhcp-option=${if_laniptv},3,10.2.0.1
      dhcp-option=${if_laniptv},6,10.2.0.1
      dhcp-option=${if_laniptv},28,10.2.255.255
      dhcp-option=${if_laniptv},60,"IPTV_RG"
      dhcp-option=${if_laniptv},121,10.2.0.0/16,10.2.0.1

      dhcp-option=wg0,3,10.4.0.1
      dhcp-option=wg0,6,10.4.0.1
      # dhcp-option=wg0,121,0.0.0.0/0,10.4.0.1

      dhcp-range=interface:${if_lan},10.0.2.1,10.0.255.254,12h
      dhcp-range=interface:${if_laniptv},10.2.2.1,10.2.255.254,12h
      dhcp-host=1c:87:2c:b6:e5:14,10.0.1.1
      dhcp-host=9c:b6:d0:da:5c:61,10.0.1.2
      host-record=router,router.home.arpa,10.0.0.1
      host-record=castor,castor.home.arpa,10.0.1.1
      host-record=pollux,pollux.home.arpa,10.0.1.2
    '';
  };

  # services.avahi = {
  #   enable = true;
  #   nssmdns = true;
  #   interfaces = [ if_lan ];
  # };

  networking.nat.enable = false;
  networking.firewall.enable = false;
  networking.nftables = {
    enable = true;
    # This is the initial ruleset to block everything.
    # This goes up during network-pre.target.
    ruleset = ''
      table inet filter {
        chain output {
          type filter hook output priority 100; policy accept;
        }

        chain input {
          type filter hook input priority filter; policy drop;

          iif lo accept
          iif != lo ip daddr 127.0.0.1/8 counter drop comment "drop connections to loopback not coming from loopback"

          # Allow LAN to access the router
          iifname "${if_lan}" counter accept

          # Allow DHCPv6 packets
          iifname "ppp0" udp dport dhcpv6-client accept
        }

        chain forward {
          type filter hook forward priority filter; policy drop;
        }
      }
    '';
  };

  systemd.services.nftables-router = {
    wantedBy = [
      "multi-user.target"
      "sys-devices-virtual-net-ppp0.device"
    ];
    bindsTo = [
      "sys-devices-virtual-net-ppp0.device"
    ];
    after = [
      "sys-devices-virtual-net-ppp0.device"
    ];
    description = "nftables router firewall";
    reloadIfChanged = true;
    serviceConfig =
      let
        conf = pkgs.writeText "nftables-ruleset.conf" ''
          table inet filter {
            # enable flow offloading for better throughput
            flowtable f {
              hook ingress priority filter;
              devices = { ${if_lan}, ${if_laniptv}, wg0, ppp0, waniptv }
              # flags offload
            }

            chain output {
              type filter hook output priority 100; policy accept;
            }

            chain input {
              type filter hook input priority filter; policy drop;

              # Allow established traffic
              iif ppp0 ct state { established, related } counter accept
              iif waniptv ct state { established, related } counter accept

              iif lo accept
              iif != lo ip daddr 127.0.0.1/8 counter drop comment "drop connections to loopback not coming from loopback"

              # Allow DHCPv6 packets
              iif ppp0 udp dport dhcpv6-client accept

              # Allow Wireguard connections
              udp dport 51820 accept

              # Allow SSH connections
              tcp dport 22 accept

              # ICMP
              ip protocol icmp icmp type echo-request limit rate 10/second accept
              icmpv6 type echo-request limit rate 10/second accept
              icmpv6 type { nd-neighbor-advert, nd-neighbor-solicit, nd-router-advert } ip6 hoplimit 255 limit rate 5/second accept

              # Reject (don't drop) inbound traceroute packets
              udp dport { 33434-33474 } reject

              # Allow trusted networks to access the router
              iif {
                ${if_lan}, ${if_laniptv}, wg0
              } counter accept

              # Allow iptv to access the router
              iif waniptv ip protocol { icmp, igmp } accept
            }

            chain forward_established {
              accept
            }

            chain forward_new {
              # Allow LANs WAN access
              iif {
                ${if_lan}, ${if_laniptv}, wg0
              } oif ppp0 counter accept comment "Allow trusted LAN to WAN"

              iif ${if_lan} accept
              iif wg0 accept

              # Connect IPTV interfaces
              iif waniptv oif ${if_laniptv} accept
              iif ${if_laniptv} oif waniptv accept

              ct status dnat accept
            }

            chain forward {
              type filter hook forward priority filter; policy drop;

              # ip protocol { tcp, udp } flow add @f
              # ip6 nexthdr { tcp, udp } flow add @f

              tcp flags syn tcp option maxseg size set rt mtu
              # ip protocol tcp tcp flags syn tcp option maxseg size set ${builtins.toString(1500 - 20 - 20)}

              # tcp flags syn tcp option maxseg size set ${builtins.toString(1500 - 20 - 20 - 8 - 40)}
              ct status dnat accept

              ct state vmap {
                established : jump forward_established,
                related : jump forward_established,
                new : jump forward_new
              }
            }
          }

          table ip nat {
            chain prerouting {
              type nat hook prerouting priority -100; policy accept;

              iif ppp0 tcp dport { http, https, 2222 } dnat to 10.0.1.1
              iif ${ if_lan } ip daddr != 10.0.0.1 tcp dport { http, https, 2222 } fib daddr type local dnat to 10.0.1.1
            }

            chain postrouting {
              type nat hook postrouting priority 100; policy accept;

              iif ${ if_lan } oif ${ if_lan } masquerade
              oif ppp0 masquerade
              oif waniptv masquerade
            }
          }
        '';
        rulesScript = pkgs.writeScript "nftables-router" ''
          #! ${pkgs.nftables}/bin/nft -f
          flush ruleset
          include "${conf}"
        '';
      in
      {
        Type = "oneshot";
        RemainAfterExit = true;
        # ExecStartPre = "${pkgs.busybox}/bin/sleep 5";
        ExecStart = rulesScript;
        ExecReload = rulesScript;
      };
  };

  systemd.services.igmpproxy = {
    wantedBy = [ "multi-user.target" ];
    # after = [ "network-online.target" ];
    after = [
      "network-online.target"
      "nftables-router.service"
    ];
    description = "IGMP proxying";
    serviceConfig =
      let
        conf = pkgs.writeText "igmpproxy.conf" ''
          # Enable Quickleave Mode
          quickleave

          # Disabled interfaces
          phyint wan disabled
          phyint lansecure disabled
          phyint languest disabled
          phyint ${if_lan} disabled
          phyint ${if_wan} disabled
          phyint wg0 disabled
          phyint ppp0 disabled

          # Downstream
          phyint ${if_laniptv} downstream ratelimit 0 threshold 1

          # Upstream
          phyint waniptv upstream ratelimit 0 threshold 1
          altnet 0.0.0.0/0
        '';
      in
      {
        Type = "forking";
        ExecStart = "${pkgs.igmpproxy}/bin/igmpproxy ${conf}";
      };
  };

  systemd.services.dhcpcd = {
    wantedBy = [
      "multi-user.target"
      "sys-devices-virtual-net-ppp0.device"
    ];
    bindsTo = [
      "sys-devices-virtual-net-ppp0.device"
    ];
    after = [
      "sys-devices-virtual-net-ppp0.device"
    ];
    description = "IPv6 DHCP";
    serviceConfig =
      let
        conf = pkgs.writeText "dhcpcd.conf" ''
          clientid
          option rapid_commit
          option interface_mtu
          require dhcp_server_identifier
          noipv6rs
          ipv6only
          waitip 6

          interface ppp0
            iaid 1
            ia_pd 1 ${if_lan}/0/64
            ia_pd 1 ${if_lan}/1/64
        '';
      in
      {
        Type = "forking";
        ExecStart = "${pkgs.dhcpcd}/bin/dhcpcd -f ${conf}";
      };
  };

  systemd.services.radvd = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    description = "IPv6 RA";
    serviceConfig =
      let
        conf = pkgs.writeText "radvd.conf" ''
          interface enp1s0f2 {
            AdvSendAdvert on;
            MinRtrAdvInterval 3;
            MaxRtrAdvInterval 10;
            prefix ${secret.ip6_prefix}:0::/64 {
              AdvOnLink on;
              AdvAutonomous on;
              AdvRouterAddr on;
            };
          };
        '';
      in
      {
        Type = "forking";
        ExecStart = "${pkgs.radvd}/bin/radvd -C ${conf}";
      };
  };

  environment.systemPackages = with pkgs; [
    git
    git-crypt
    neovim
    wget
    htop
    ppp
    ethtool
    tcpdump
    conntrack-tools
    igmpproxy
    dhcpcd
    radvd
    wireguard-tools
  ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  programs.gnupg = {
    agent.enable = true;
  };

  # Configure tmux.
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    clock24 = true;
    escapeTime = 10;
    historyLimit = 5000;
    keyMode = "vi";
    extraConfig = ''
      set -ga terminal-overrides ",alacritty:Tc,*-256col*:Tc"
      set -g status-style "fg=colour8 bg=colour3 dim"
      set -g message-style "fg=colour3 bg=colour8"
    '';
  };
  # Configure zshell.
  programs.zsh.enable = true;
  programs.zsh.promptInit = ''
    if [ "$TERM" != dumb ]; then
      autoload -Uz add-zsh-hook

      setprompt() {
        setopt noxtrace localoptions
        local prompt_newline
        local p_user p_host
        local base_prompt_count base_prompt_path_count prompt_length space_left
        local base_prompt path_prompt cont_prompt

        prompt_newline=$'\n%{\r%}'
        p_user='%(!.%F{red}%n%f.%F{yellow}%n%f)'

        if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then 
          p_host='%F{cyan}%M%f'
        else
          p_host='%F{yellow}%M%f'
        fi

        if [[ -n "$IN_NIX_SHELL" ]]; then
          p_nix_shell=' (nix)'
        else
          p_nix_shell='''
        fi

        # Base prompt without colors.
        base_prompt_count=$(print -P "%n@%M")
        # Base prompt with path without colors.
        base_prompt_path_count=$(print -P "%n@%M %~ >")

        # Length of expanded base prompt with path.
        prompt_length=''${#base_prompt_path_count}

        base_prompt="''${p_user}%F{yellow}@%f''${p_host}''${p_nix_shell}"
        cont_prompt=""
        if [[ $prompt_length -lt 40 ]]; then
          path_prompt="%B%~%b"
          cont_prompt="$base_prompt $path_prompt"
        else
          # Truncate path if neccesary. Ensure to keep distance
          # to right margin of shell window.
          # Place a newline after the path.
          space_left=$(( $COLUMNS - $#base_prompt_count - 1 ))
          path_prompt="%B%F{white}%''${space_left}<...<%~%<<%f%b$prompt_newline"
        fi

        PS1="$base_prompt $path_prompt %B%F{white}%#%f%b "
        PS2="$cont_prompt %B%F{white}%_>%f%b "
        PS3="$cont_prompt %B%F{white}?#%f%b "
        PS4=" %B%F{white}+%f%b "
      }
      add-zsh-hook precmd setprompt
    fi
  '';
  programs.zsh.shellAliases = {
    vi = "nvim";
    ns = "nix-shell --command zsh";
  };
  programs.zsh.histSize = 40000;
  programs.zsh.syntaxHighlighting.enable = true;
  programs.zsh.autosuggestions.enable = true;
  programs.zsh.autosuggestions.extraConfig = {
    ZSH_AUTOSUGGEST_USE_ASYNC = "1";
  };
  programs.zsh.setOptions = [
    "HIST_IGNORE_SPACE"
  ];

  users.defaultUserShell = pkgs.zsh;
  users.users.root.openssh.authorizedKeys.keyFiles = [ ../../keys/thomas.pub ];
  users.users.thomas = {
    isNormalUser = true;
    home = "/home/thomas";
    extraGroups = [ "wheel" "networkmanager" "wireshark" ];
    openssh.authorizedKeys.keyFiles = [ ../../keys/thomas.pub ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
