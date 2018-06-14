#!/bin/bash

ipaddr="$(ip -o -4 addr show dev eth0 | sed 's/.* inet \([^/]*\).*/\1/')"

echo "
       _____       _                  __________      
      / ___/____  (_)___  ___        /  _/_  __/      
      \__ \/ __ \/ / __ \/ _ \______ / /  / /         
     ___/ / / / / / /_/ /  __/_____// /  / /          
    /____/_/ /_/_/ .___/\___/     /___/ /_/           
                /_/                                   
                                                      
          Welcome to Snipe-IT Inventory            
  Snipe-IT can be access from http://$ipaddr     "    
                                                      


