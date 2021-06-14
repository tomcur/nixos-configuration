{ pkgs, lib, config, ... }:
let
  accounts = config.accounts.email.accounts;
in
{
  imports = [ ./accounts-bak.nix ./contacts.nix ];

  programs.mbsync.enable = true;
  services.imapnotify.enable = true;
  programs.msmtp.enable = true;
  programs.notmuch.enable = true;
  programs.alot.enable = true;
  programs.astroid = {
    enable = true;
    externalEditor =
      "urxvt -e nvim -c 'set ft=mail' '+set fileencoding=utf-8' '+set ff=unix' '+set enc=utf-8' '+set fo+=w' %1";
  };
  programs.neomutt.enable = true;
  programs.neomutt.editor = "nvim";
  programs.neomutt.sort = "threads";
  programs.neomutt.sidebar.enable = true;
  programs.neomutt.sidebar.width = 27;
  programs.neomutt.sidebar.format = "%D%* %S";
  programs.neomutt.extraConfig =
    ''
      # Mailbox handling
      alternates "${accounts.thomas-churchman-nl.address}" "${accounts.thomas-kepow-org.address}"
      set reply_self = "no"
      set reverse_name = "yes"
      set reverse_realname = "no"
      set edit_headers = "yes"

      # Record outgoing mail
      set copy = yes
      fcc-hook "~f ${accounts.thomas-churchman-nl.address}" ${accounts.thomas-churchman-nl.maildir.absPath}/Sent
      fcc-hook "~f ${accounts.thomas-kepow-org.address}" ${accounts.thomas-kepow-org.maildir.absPath}/Sent

      # Address book
      set query_command = "goobook query %s"

      # Display
      set sort_aux = "last-date-received"

      tag-transforms "inbox"   "⛊" \
                     "trash"   "☓" \
                     "flagged" "★" \
                     "sent"    "➥" \
                     "reference" "ref" \
                     "finance" "fin" \
                     "university" "uni" \
                     "github" "gh" \
                     "openstreetmap" "osm" \
                     "programming" "prog"

      tag-formats "inbox"   "GI" \
                  "archive" "GA" \
                  "trash"   "GT" \
                  "sent"    "GS"

      set hidden_tags = "unread,draft,flagged,passed,replied,attachment,signed,encrypted,inbox,trash,sent"
      set index_format = " %Z %<[y?%<[m?%<[d?%[     %H:%M]&%[    %a %d]>&%[    %b %d]>&%[%d/%m/%Y]> %-22.22F %<M?(%2M)&    > %1GI %1GS %1GA %1GT %-15g %.100s"
      set attach_format = "%u%D%I %t%4n %T%.100d%> [%.15m/%.15M, %.6e%?C?, %C?, %s] "

      set pager_format = "-%Z- %C/%m: %-20.20n %1GI %1GS %1GA %1GT %-15g  %s%*  -- (%P)"
      set pager_index_lines = 11

      set show_multipart_alternative = 'info'

      # Notmuch
      set nm_query_type = messages
      set nm_exclude_tags = "trash spam"
      set nm_record = yes
      set nm_record_tags = "sent"

      # Mailboxes
      virtual-mailboxes "inbox"         "notmuch://?query=tag:inbox"
      virtual-mailboxes "  new"         "notmuch://?query=tag:inbox and not tag:todo and not tag:flagged"
      virtual-mailboxes "  unread"      "notmuch://?query=tag:unread"
      virtual-mailboxes "  todo"        "notmuch://?query=tag:todo"
      virtual-mailboxes "  flagged"     "notmuch://?query=tag:flagged"
      virtual-mailboxes "  programming" "notmuch://?query=tag:programming"
      virtual-mailboxes "  astroplant"  "notmuch://?query=tag:astroplant"
      virtual-mailboxes "  friends"     "notmuch://?query=tag:friends"
      virtual-mailboxes "  university"  "notmuch://?query=tag:tag:university"
      virtual-mailboxes "  finance"     "notmuch://?query=tag:tag:finance"
      virtual-mailboxes "  jobs"        "notmuch://?query=tag:tag:jobs"
      virtual-mailboxes "reference"     "notmuch://?query=tag:reference"
      virtual-mailboxes "sent"          "notmuch://?query=tag:sent"
      virtual-mailboxes "archive"       "notmuch://?query=not tag:inbox"
      virtual-mailboxes "drafts"        "notmuch://?query=tag:draft"
      virtual-mailboxes "spam"          "notmuch://?query=tag:spam and (tag:trash or not tag:trash)"
      virtual-mailboxes "trash"         "notmuch://?query=tag:trash and (tag:spam or not tag:spam)"

      # Theme
      set my_background = "default"
      set my_gray = "color253"
      set my_darkgray = "color244"

      ## Index
      color index $my_gray $my_background ".*"
      color index_date magenta $my_background
      color index_subject white $my_background "~R"
      color index_subject brightwhite $my_background "~U"
      color index_author yellow $my_background "~R"
      color index_author brightyellow $my_background "~U"
      color index_tag cyan $my_background "inbox"
      color index_tag blue $my_background "inbox"
      color index_tag yellow $my_background "archive"
      color index_tag red $my_background "trash"
      color index_tags green $my_background

      ## Thread arrows
      color tree white $my_background

      ## Message
      color normal white $my_background
      color warning brightyellow $my_background
      color error brightred $my_background
      color tilde $my_gray $my_background
      color message white $my_background
      color markers brightyellow $my_background
      color attachment black yellow
      color bold brightwhite $my_background
      color underline brightcolor81 $my_background
      color quoted blue $my_background
      color quoted1 brightblue $my_background
      color quoted2 magenta $my_background
      color quoted3 brightmagenta $my_background
      color hdrdefault yellow $my_background
      color header brightwhite $my_background "^(Subject)"

      ## Sidebar
      color sidebar_divider cyan $my_background
      color sidebar_indicator black yellow
      color sidebar_new yellow $my_background
      color sidebar_unread blue $my_background

      ## Other
      color search black cyan
      color status black cyan
      color status brightred cyan "(New|Del|Flag):[0-9]+"

      # Bindings
      ## Adapted from: https://github.com/neomutt/neomutt/blob/d729f6b9a6cc5daf086ce8f47692bbd03b180cb6/contrib/vim-keys/vim-keys.rc
      bind index,pager \` modify-labels

      ## Moving around
      bind attach,browser,index g   noop
      bind attach,browser,index gg  first-entry
      bind attach,browser,index G   last-entry
      bind attach,index,pager   j   next-entry
      bind attach,index,pager   k   previous-entry
      bind pager                g   noop
      bind pager                gg  top
      bind pager                G   bottom
      bind pager                \Cj next-line
      bind pager                \Ck previous-line
      bind index,pager          o   vfolder-from-query
      bind index,pager          \J  sidebar-next
      bind index,pager          \K  sidebar-prev
      bind index,pager          \O  sidebar-open

      ## Tagging
      macro index,pager a  "<modify-labels>!inbox\n"      "Toggle the 'inbox' tag"
      macro index,pager s  "<modify-labels>!flagged\n"    "Toggle the 'flagged' tag"
      macro index,pager d  "<modify-labels>!trash\n"      "Toggle the 'trash' tag"
      bind  pager t noop
      macro index,pager tt "<modify-labels>!todo\n"       "Toggle the 'todo' tag"
      macro index,pager tr "<modify-labels>!reference\n"  "Toggle the 'reference' tag"
      macro index,pager ta "<modify-labels>!astroplant\n" "Toggle the 'astroplant' tag"
      macro index,pager tf "<modify-labels>!finance\n"    "Toggle the 'finance' tag"

      ## Scrolling
      bind attach,browser,pager,index \CF next-page
      bind attach,browser,pager,index \CB previous-page
      bind attach,browser,pager,index \Cu half-up
      bind attach,browser,pager,index \Cd half-down
      bind browser,pager              \Ce next-line
      bind browser,pager              \Cy previous-line
      bind index                      \Ce next-line
      bind index                      \Cy previous-line

      # Threads
      bind browser,pager,index N  search-opposite
      bind pager,index         gt next-thread
      bind pager,index         gT previous-thread
      bind index               za collapse-thread
      bind index               zA collapse-all
      bind index,pager         +  entire-thread

      # Messaging
      bind editor          <Tab> complete-query
      bind pager,index     R     group-chat-reply
      macro index,pager    \cb   "<pipe-message> ${pkgs.urlscan}/bin/urlscan<Enter>" "call urlscan to extract URLs out of a message"
      macro attach,compose \cb   "<pipe-entry>   ${pkgs.urlscan}/bin/urlscan<Enter>" "call urlscan to extract URLs out of a message"
    '';

  home.file.".mailcap".text = ''
    text/html; ${pkgs.qutebrowser}/bin/qutebrowser --target window %s &; test = test - n "$DISPLAY"; needsterminal; nametemplate = %s.html
    text/html; ${pkgs.w3m}/bin/w3m -I %{charset} -T text/html; copiousoutput
    image/*; ${pkgs.imv}/bin/imv %s
  '';

  programs.notmuch.new.tags = [ "inbox" "unread" "new" ];
  programs.notmuch.search.excludeTags = [ "trash" "spam" ];
  systemd.user.services.email-fetch = {
    Unit = { Description = "Fetch email and index."; };
    Service =
      let
        mbsync = "${pkgs.isync}/bin/mbsync";
        notmuch = "${pkgs.notmuch}/bin/notmuch";
        notify = "${pkgs.libnotify}/bin/notify-send";
        index-new = pkgs.substituteAll {
          src = ./secret-indexing/new.sh;
          isExecutable = true;
          inherit notmuch;
          inherit (pkgs) bash;
        };
        index-general = pkgs.substituteAll {
          src = ./secret-indexing/general.sh;
          isExecutable = true;
          inherit notmuch;
          inherit (pkgs) bash;
        };
        script = pkgs.writeShellScript "email-fetch" ''
          ${mbsync} -Va

          ${notmuch} new

          # Tags only on new mail
          ${notmuch} tag -inbox -unread -- tag:new and tag:sent
          ${notmuch} tag +github -- tag:new and from:github.com
          ${notmuch} tag +openstreetmap -- tag:new and from:openstreetmap.org
          ${notmuch} tag +wordpress -- tag:new and from:wordpress.org
          ${index-new}

          CHURCHMAN_NEW=$(${notmuch} count tag:new folder:${accounts.thomas-churchman-nl.maildir.path}/Inbox)
          KEPOW_NEW=$(${notmuch} count tag:new folder:${accounts.thomas-kepow-org.maildir.path}/Inbox)

          ${notmuch} tag -new -- tag:new

          # Tags on all mail
          ${notmuch} tag +sent from:${accounts.thomas-churchman-nl.address} and not tag:sent
          ${notmuch} tag +sent from:${accounts.thomas-kepow-org.address} and not tag:sent
          ${notmuch} tag +programming "(tag:github or tag:wordpress) and not tag:programming"
          ${index-general}

          if ((CHURCHMAN_NEW > 0)); then
              ${notify} -i mail-unread -a "${accounts.thomas-churchman-nl.address}" "$CHURCHMAN_NEW new message(s)"
          fi
          if ((KEPOW_NEW > 0)); then
              ${notify} -i mail-unread -a "${accounts.thomas-kepow-org.address}" "$KEPOW_NEW new message(s)"
          fi
        '';
      in
      { ExecStart = "${script}"; };
  };
  systemd.user.timers.email-fetch = {
    Unit = { Description = "Poll email."; };

    Timer = {
      OnUnitInactiveSec = "10m";
      OnBootSec = "30s";
    };

    Install = { WantedBy = [ "timers.target" ]; };
  };
}
