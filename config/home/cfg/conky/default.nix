{ ... }:
{
  xdg.configFile.".conky/conky.conf".text = ''
    conky.config = {
    
    -------------------------------------
    --  Generic Settings
    -------------------------------------
    background=true,
    update_interval=1,
    double_buffer=true,
    no_buffers=true,
    imlib_cache_size=10,
    
    draw_shades=false,
    draw_outline=false,
    draw_borders=false,
    draw_graph_borders=false,
    default_graph_height=26,
    default_graph_width=80,
    show_graph_scale=false,
    show_graph_range=false,
    
    
    -------------------------------------
    --  Window Specifications
    -------------------------------------
    gap_x=100,
    gap_y=70,
    minimum_height=620,
    minimum_width=268,
    own_window=true,
    own_window_type="desktop",
    own_window_transparent=true,
    own_window_hints="undecorated,below,sticky,skip_taskbar,skip_pager",
    border_inner_margin=0,
    border_outer_margin=0,
    --alignment="middle_middle",
    --own_window_argb_visual=true,
    --own_window_argb_value=0,
    
    
    -------------------------------------
    --  Text Settings
    -------------------------------------
    use_xft=true,
    xftalpha=1,
    font="Droid Sans:size=8",
    text_buffer_size=256,
    override_utf8_locale=true,
    
    short_units=true,
    short_units=true,
    pad_percents=2,
    top_name_width=7,
    
    
    -------------------------------------
    --  Color Scheme
    -------------------------------------
    default_color="FFFFFF",
    color1="FFFFFF",
    color2="FFFFFF",
    color3="FFFFFF",
    color4="FFFFFF",
    color5="FFFFFF",
    color6="DCDCDC",
    color7="FFFFFF",
    color8="FFFFFF",
    
    
    -------------------------------------
    --  API Key
    -------------------------------------
    template6="",
    
    
    -------------------------------------
    --  City ID
    -------------------------------------
    template7="",
    
    
    -------------------------------------
    --  Temp Unit (default, metric, imperial)
    -------------------------------------
    template8="metric",
    
    
    -------------------------------------
    --  Locale (e.g. "es_ES.UTF-8")
    --  Leave empty for default
    -------------------------------------
    template9=""
    
    }
    
    
    ---------------------------------------------------
    ---------------------------------------------------
    
    
    conky.text = [[
    \
    \
    ${execi 300 ~/.harmattan-assets/get_weather ${template6} ${template7} ${template8} ${template9}}\
    \
    \
    \
    \
    \
    ${image ~/.harmattan-assets/misc/Glass/God-Mode/top-bg.png -p 20,30 -s 228x61}\
    ${image ~/.harmattan-assets/misc/Glass/God-Mode/bottom-bg.png -p 20,492 -s 228x99}\
    ${image ~/.harmattan-assets/misc/Glass/God-Mode/bg-1.png -p 20,177 -s 228x86}\
    ${image ~/.harmattan-assets/misc/Glass/God-Mode/bg-2.png -p 20,263 -s 228x105}\
    ${image ~/.harmattan-assets/misc/Glass/God-Mode/bg-3.png -p 20,368 -s 228x110}\
    ${image ~/.harmattan-assets/misc/Glass/God-Mode/bg-4.png -p 20,478 -s 228x14}\
    ${image ~/.harmattan-assets/misc/Glass/God-Mode/bg-5.png -p 20,478 -s 228x14}\
    ${image ~/.harmattan-assets/misc/Glass/God-Mode/bg-6.png -p 20,91 -s 228x86}\
    ${image ~/.harmattan-assets/misc/Glass/God-Mode/fav-color.png -p 20,91 -s 228x86}\
    ${image ~/.harmattan-assets/misc/Glass/God-Mode/border.png -p 20,30 -s 228x561}\
    ${image ~/.harmattan-assets/misc/Glass/God-Mode/separator-v.png -p 95,185 -s 1x76}\
    ${image ~/.harmattan-assets/misc/Glass/God-Mode/separator-v.png -p 172,185 -s 1x76}\
    ${image ~/.harmattan-assets/misc/Glass/God-Mode/separator-h.png -p 21,369 -s 226x1}\
    ${image ~/.harmattan-assets/misc/Glass/God-Mode/separator-h.png -p 21,269 -s 226x1}\
    \
    \
    \
    \
    ${color3}${voffset 187}${alignc 77}${execi 300 LANG=${template9} LC_TIME=${template9} date +%^a}${color}
    ${color3}${voffset -13}${alignc}${execi 300 LANG=${template9} LC_TIME=${template9} date -d +1day +%^a}${color}
    ${color3}${voffset -13}${alignc -77}${execi 300 LANG=${template9} LC_TIME=${template9} date -d +2day +%^a}${color}
    \
    \
    \
    \
    ${color2}${voffset 51}${alignc 77}${execi 300 ~/.harmattan-assets/parse_weather 'avg' '.main.temp_min' '0'}${if_match "$template8" == "metric"} °C${else}${if_match "$template8" == "imperial"} °F${else}${if_match "$template8" == "default"} K${endif}${endif}${endif}/${execi 300 ~/.harmattan-assets/parse_weather 'avg' '.main.temp_max' '0'}${if_match "$template8" == "metric"} °C${else}${if_match "$template8" == "imperial"} °F${else}${if_match "$template8" == "default"} K${endif}${endif}${endif}${color}
    ${color2}${voffset -13}${alignc}${execi 300 ~/.harmattan-assets/parse_weather 'avg' '.main.temp_min' '1'}${if_match "$template8" == "metric"} °C${else}${if_match "$template8" == "imperial"} °F${else}${if_match "$template8" == "default"} K${endif}${endif}${endif}/${execi 300 ~/.harmattan-assets/parse_weather 'avg' '.main.temp_max' '1'}${if_match "$template8" == "metric"} °C${else}${if_match "$template8" == "imperial"} °F${else}${if_match "$template8" == "default"} K${endif}${endif}${endif}${color}
    ${color2}${voffset -13}${alignc -77}${execi 300 ~/.harmattan-assets/parse_weather 'avg' '.main.temp_min' '2'}${if_match "$template8" == "metric"} °C${else}${if_match "$template8" == "imperial"} °F${else}${if_match "$template8" == "default"} K${endif}${endif}${endif}/${execi 300 ~/.harmattan-assets/parse_weather 'avg' '.main.temp_max' '2'}${if_match "$template8" == "metric"} °C${else}${if_match "$template8" == "imperial"} °F${else}${if_match "$template8" == "default"} K${endif}${endif}${endif}${color}
    \
    \
    \
    \
    ${goto 36}${voffset -172}${font Droid Sans :size=36}${color1}${execi 300 jq -r .main.temp ~/.cache/harmattan-conky/weather.json | awk '{print int($1+0.5)}' # round num}${if_match "$template8" == "metric"} °C${else}${if_match "$template8" == "imperial"} °F${else}${if_match "$template8" == "default"} K${endif}${endif}${endif}${font}${color}
    ${goto 46}${voffset 14}${font Droid Sans :size=12}${color1}${execi 300 jq -r .weather[0].description ~/.cache/harmattan-conky/weather.json | sed "s|\<.|\U&|g"}${font}${color}
    ${color1}${alignr 52}${voffset -73}${execi 300 jq -r .main.pressure ~/.cache/harmattan-conky/weather.json | awk '{print int($1+0.5)}' # round num} hPa
    ${color1}${alignr 52}${voffset 7}${execi 300 jq -r .main.humidity ~/.cache/harmattan-conky/weather.json | awk '{print int($1+0.5)}' # round num} %${color}
    ${color1}${alignr 52}${voffset 7}${execi 300 jq -r .wind.speed ~/.cache/harmattan-conky/weather.json | awk '{print int($1+0.5)}' # round num}${if_match "$template8" == "metric"} m/s${else}${if_match "$template8" == "default"} m/s${else}${if_match "$template8" == "imperial"} mi/h${endif}${endif}${endif}${color}
    \
    \
    \
    \
    ${voffset -117}${font Droid Sans Mono :size=22}${alignc}${color2}${time %H:%M}${font}${color}
    ${voffset 4}${font Droid Sans :size=10}${alignc}${color6}${execi 300 LANG=${template9} LC_TIME=${template9} date +"%A, %B %-d"}${font}${color}
    \
    \
    \
    \
    ${voffset 294}${goto 40}${color5}Cpu:${color}
    ${voffset 4}${goto 40}${color5}Mem:${color}
    ${voffset 4}${goto 40}${color5}Uptime:${color}
    ${voffset -47}${alignr 39}${color6}${cpu cpu0}%${color}
    ${voffset 4}${alignr 39}${color6}${memperc}%${color}
    ${voffset 4}${alignr 39}${color6}${uptime_short}${color}
    ${voffset -47}${alignc}${color2}${cpubar 5,36}${color}
    ${voffset 4}${alignc}${color2}${membar 5,36}${color}
    ${voffset 29}${goto 40}${loadgraph 26,190 FFFFFF FFFFFF -l}
    \
    \
    \
    \
    ${voffset 26}${goto 40}${color5}${top_mem name 1}${color}
    ${voffset 4}${goto 40}${color5}${top_mem name 2}${color}
    ${voffset 4}${goto 40}${color5}${top_mem name 3}${color}
    ${voffset 4}${goto 40}${color5}${top_mem name 4}${color}
    ${voffset 4}${goto 40}${color5}${top_mem name 5}${color}
    ${voffset -81}${alignc}${color2}${top_mem mem 1}%${color}
    ${voffset 4}${alignc}${color2}${top_mem mem 2}%${color}
    ${voffset 4}${alignc}${color2}${top_mem mem 3}%${color}
    ${voffset 4}${alignc}${color2}${top_mem mem 4}%${color}
    ${voffset 4}${alignc}${color2}${top_mem mem 5}%${color}
    ${voffset -81}${alignr 39}${color6}${top_mem mem_res 1}${color}
    ${voffset 4}${alignr 39}${color6}${top_mem mem_res 2}${color}
    ${voffset 4}${alignr 39}${color6}${top_mem mem_res 3}${color}
    ${voffset 4}${alignr 39}${color6}${top_mem mem_res 4}${color}
    ${voffset 4}${alignr 39}${color6}${top_mem mem_res 5}${color}
    ${voffset -104}${goto 40}${color1}Proc${color}
    ${voffset -13}${alignc}${color1}Mem%${color}
    ${voffset -13}${alignr 39}${color1}Mem${color}
    \
    \
    \
    \
    ${if_existing /proc/net/route ppp0}
    ${voffset -227}${goto 40}${color5}Up: ${color2}${upspeed ppp0}${color5}${goto 150}Down: ${color2}${downspeed ppp0}
    ${voffset 10}${goto 40}${upspeedgraph ppp0 26,80 FFFFFF FFFFFF}${goto 150}${downspeedgraph ppp0 26,80 FFFFFF FFFFFF}
    ${voffset 9}${goto 40}${color5}Sent: ${color2}${totalup ppp0}${color5}${goto 150}Received: ${color2}${totaldown ppp0}
    ${else}
    ${if_existing /proc/net/route ppp1}
    ${voffset -240}${goto 40}${color5}Up: ${color2}${upspeed ppp1}${color5}${goto 150}Down: ${color2}${downspeed ppp1}
    ${voffset 10}${goto 40}${upspeedgraph ppp1 26,80 FFFFFF FFFFFF}${goto 150}${downspeedgraph ppp1 26,80 FFFFFF FFFFFF}
    ${voffset 9}${goto 40}${color5}Sent: ${color2}${totalup ppp1}${color5}${goto 150}Received: ${color2}${totaldown ppp1}
    ${else}
    ${if_existing /proc/net/route wlp2s1}
    ${voffset -253}${goto 40}${color5}Up: ${color2}${upspeed wlp2s1}${color5}${goto 150}Down: ${color2}${downspeed wlp2s1}
    ${voffset 10}${goto 40}${upspeedgraph wlp2s1 26,80 FFFFFF FFFFFF}${goto 150}${downspeedgraph wlp2s1 26,80 FFFFFF FFFFFF}
    ${voffset 9}${goto 40}${color5}Sent: ${color2}${totalup wlp2s1}${color5}${goto 150}Received: ${color2}${totaldown wlp2s1}
    ${else}
    ${if_existing /proc/net/route wlp2s0}
    ${voffset -266}${goto 40}${color5}Up: ${color2}${upspeed wlp2s0}${color5}${goto 150}Down: ${color2}${downspeed wlp2s0}
    ${voffset 10}${goto 40}${upspeedgraph wlp2s0 26,80 FFFFFF FFFFFF}${goto 150}${downspeedgraph wlp2s0 26,80 FFFFFF FFFFFF}
    ${voffset 9}${goto 40}${color5}Sent: ${color2}${totalup wlp2s0}${color5}${goto 150}Received: ${color2}${totaldown wlp2s0}
    ${else}
    ${if_existing /proc/net/route wlan0}
    ${voffset -279}${goto 40}${color5}Up: ${color2}${upspeed wlan0}${color5}${goto 150}Down: ${color2}${downspeed wlan0}
    ${voffset 8}${goto 40}${upspeedgraph wlan0 26,80 FFFFFF FFFFFF}${goto 150}${downspeedgraph wlan0 26,80 FFFFFF FFFFFF}
    ${voffset 9}${goto 40}${color5}Sent: ${color2}${totalup wlan0}${color5}${goto 150}Received: ${color2}${totaldown wlan0}
    ${else}
    ${if_existing /proc/net/route wlan1}
    ${voffset -292}${goto 40}${color5}Up: ${color2}${upspeed wlan1}${color5}${goto 150}Down: ${color2}${downspeed wlan1}
    ${voffset 10}${goto 40}${upspeedgraph wlan1 26,80 FFFFFF FFFFFF}${goto 150}${downspeedgraph wlan1 26,80 FFFFFF FFFFFF}
    ${voffset 9}${goto 40}${color5}Sent: ${color2}${totalup wlan1}${color5}${goto 150}Received: ${color2}${totaldown wlan1}
    ${else}
    ${if_existing /proc/net/route eth1}
    ${voffset -305}${goto 40}${color5}Up: ${color2}${upspeed eth1}${color5}${goto 150}Down: ${color2}${downspeed eth1}
    ${voffset 10}${goto 40}${upspeedgraph eth1 26,80 FFFFFF FFFFFF}${goto 150}${downspeedgraph eth1 26,80 FFFFFF FFFFFF}
    ${voffset 9}${goto 40}${color5}Sent: ${color2}${totalup eth1}${color5}${goto 150}Received: ${color2}${totaldown eth1}
    ${else}
    ${if_existing /proc/net/route eth0}
    ${voffset -318}${goto 40}${color5}Up: ${color2}${upspeed eth0}${color5}${goto 150}Down: ${color2}${downspeed eth0}
    ${voffset 10}${goto 40}${upspeedgraph eth0 26,80 FFFFFF FFFFFF}${goto 150}${downspeedgraph eth0 26,80 FFFFFF FFFFFF}
    ${voffset 9}${goto 40}${color5}Sent: ${color2}${totalup eth0}${color5}${goto 150}Received: ${color2}${totaldown eth0}
    ${else}
    ${if_existing /proc/net/route enp0s0}
    ${voffset -331}${goto 40}${color5}Up: ${color2}${upspeed enp0s0}${color5}${goto 150}Down: ${color2}${downspeed enp0s0}
    ${voffset 10}${goto 40}${upspeedgraph enp0s0 26,80 FFFFFF FFFFFF}${goto 150}${downspeedgraph enp0s0 26,80 FFFFFF FFFFFF}
    ${voffset 9}${goto 40}${color5}Sent: ${color2}${totalup enp0s0}${color5}${goto 150}Received: ${color2}${totaldown enp0s0}
    ${else}
    ${if_existing /proc/net/route enp0s1}
    ${voffset -344}${goto 40}${color5}Up: ${color2}${upspeed enp0s1}${color5}${goto 150}Down: ${color2}${downspeed enp0s1}
    ${voffset 10}${goto 40}${upspeedgraph enp0s1 26,80 FFFFFF FFFFFF}${goto 150}${downspeedgraph enp0s1 26,80 FFFFFF FFFFFF}
    ${voffset 9}${goto 40}${color5}Sent: ${color2}${totalup enp0s1}${color5}${goto 150}Received: ${color2}${totaldown enp0s1}
    ${else}
    ${voffset -311}${goto 40}${color8}Network disconnected${color}
    ${image ~/.harmattan-assets/misc/Glass/God-Mode/offline.png -p 44,284 -s 16x16}
    ${endif}${endif}${endif}${endif}${endif}${endif}${endif}${endif}${endif}${endif}
    \
    \
    \
    \
    ${image ~/.harmattan-assets/misc/Glass/God-Mode/pressure.png -p 224,97 -s 16x16}\
    ${image ~/.harmattan-assets/misc/Glass/God-Mode/humidity.png -p 224,117 -s 16x16}\
    ${image ~/.harmattan-assets/misc/Glass/God-Mode/wind-2.png -p 224,138 -s 16x16}\
    ${execi 300 cp -f ~/.harmattan-assets/icons/#fff__32/$(~/.harmattan-assets/parse_weather 'first' '.weather[0].id' '0').png ~/.cache/harmattan-conky/weather-1.png}${image ~/.cache/harmattan-conky/weather-1.png -p 41,207 -s 32x32}\
    ${execi 300 cp -f ~/.harmattan-assets/icons/#fff__32/$(~/.harmattan-assets/parse_weather 'first' '.weather[0].id' '1').png ~/.cache/harmattan-conky/weather-2.png}${image ~/.cache/harmattan-conky/weather-2.png -p 119,207 -s 32x32}\
    ${execi 300 cp -f ~/.harmattan-assets/icons/#fff__32/$(~/.harmattan-assets/parse_weather 'first' '.weather[0].id' '2').png ~/.cache/harmattan-conky/weather-3.png}${image ~/.cache/harmattan-conky/weather-3.png -p 195,207 -s 32x32}${font}${voffset -120}\
    ]]
  '';
}
