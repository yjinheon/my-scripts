#!/bin/bash
WINDOW=$(hyprctl clients | grep "title: " | 
  awk '{
    gsub("title: ", "");
    gsub("- Google Chrome", "");
    gsub("— Mozilla Firefox", "");
    print}' | 
      wofi --show dmenu)


# get workspaces for each window
#




if [ "$WINDOW" = "" ]; then
    exit
fi

hyprctl dispatch focuswindow $WINDOW
