#!/bin/bash

mainmenu(){
   echo "Welcome to Led_Konfigurator!"
   echo "================================="
   echo "Please select an led to configure:"
   cd /sys/class
   sel=1
   for leds in $(ls leds)
   do
      echo $sel.$leds
      sel=`expr $sel + 1`
   done
   echo "$sel.Quit"
   echo "Please enter a numnber(1-$sel)for the lead to configure or quit:"
}

submenu(){
   cd /sys/class
   se=1
   for leds in $(ls leds)
   do
      if [ $num == $se ]
      then
         LEDname=`basename $leds`
      fi
      se=`expr $se + 1`
   done

   echo $LEDname
   echo "================================="
   echo "What would you like to do wtin this led?"
   s=0
   for menu in "turn on" "turn off" "associate with a system event" "associate with the performance of a process" "stop association with a process' performance" "quit to main menu"
   do
      s=`expr $s + 1`
      echo $s.$menu
   done
}

action(){
   while true
   do
      if [ $meu == 1 ]
      then
         cd /sys/class/leds/$LEDname
         echo brightness 1
         break
      elif [ $meu == 2 ]
      then
         cd /sys/class/leds/$LEDname
         echo brightness 0
         break
      elif [ $meu == 3 ]
      then
         echo "Associate Led with a system Event"
         echo "========================================="
         echo "Availiable events are:"
         echo "-----------------------------------------"
         li=1
         for list in $(cat /sys/class/leds/$LEDname/trigger)
         do
            echo $li.$list
            li=`expr $li + 1`
         done
         echo "$li.Quit to previous menu"
         echo "please select an option(1-$li)"
         read op
         if [ $op == $li ]
         then
            break
         fi
      elif [ $meu == 4 ]
      then
         echo "Associate LED with the performace of a process"
         echo "=============================================="
         echo "Please enter the name of the program to monitor(partial names are ok):"
         read pna
         name=$(ps -eo comm|grep $pna)
         lanu=0
         for la in $name
            do
               lanu=`expr $lanu + 1`
            done
         if [ $lanu -gt 1 ]
         then
            echo "Name Confilict"
            echo "--------------"
            echo "I have detected a name confilict. Do you want to monitor:"
            lanum=0
            for lac in $name
            do
               lanum=`expr $lanum + 1`
               echo $lanum.$lac
            done
            read monitor
            lanumb=1
            for laco in $name
            do
               lanumb=`expr $lanumb + 1`
               if [ $monitor == $lanumb ]
               then
                  pna=$laco
               fi
            done
         fi
         echo $pna 
         echo "Do you wish to 1)monitor memory or 2)monitor cpu?[enter memory or cpu]"
         read mon
         if [ $mon == memory ]
         then
            ps -eo comm,pmem | grep $pna
            break
         elif [ $mon == cpu ]
         then
            ps -eo comm,pmem | grep $pna
            break
         fi
      elif [ $meu == $s ]
      then
         break
      fi
   done
}

while true
do
   mainmenu
   read num
   if [ $num -lt $sel ]
   then
      submenu
      read meu
      action
   elif [ $num == $sel ]
   then
      exit
   elif [ $num -gt $sel ]
   then
      echo "invalied number, please enter again:"
   fi
done

