#!/usr/bin/env nu

def focus_window [] {
     let window_list = hyprctl clients -j | from json | sort-by focusHistoryID| each {|client|
         if $client.title != "" {
             # Use client title and address for selection
             {title: $client.title, address: $"address:($client.address)"}
         }
     } | where $it.title != "" | to json

     # Get the user's selection from rofi
     let choice = $window_list | from json | select title | to text | cut -d ' ' -f 2- | rofi -dmenu -i -p "Select Window"
     # Check if a choice was made
     if $choice != "" {
         let selected = ($window_list | from json | where title == $choice |first)
 $selected |print
         # Focus the selected window
         if $selected != null {
             echo "Focusing on window: $selected.title"
             hyprctl dispatch focuswindow $selected.address
         }
     }
 }
focus_window
 
