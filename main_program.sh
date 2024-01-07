#!/bin/bash

main_menu()
{

clear

echo -e "\n\e[44m    \e[4mCommand Line Test\e[0m\e[44m    \e[0m\n"
echo -e "\e[1m\e[4mPlease choose the below option:\e[0m\n\e[1m1.sign up\n2.sign in\n3.exit\n"
read select

 case $select in
      1)
	 sign_up
	 ;;

      2)
	  sign_in
	  ;;
      3)
	  Exit
	  ;;
      *)
	  echo "Select valid option"
	  ;;
  esac

}

sign_up()
{

	clear

echo -e "\n\e[44m    \e[4mCommand Line Test\e[0m\e[44m    \e[0m\n"
   echo -e "\e[4m\e[1msign up\e[0m"
  
   user_arr=(`cat user.csv`)                                       #user_arr store all user name from user.csv
   
   count=1                                                         #count is run loop until user doesnt print unique user_id 
   
   while [ $count -eq 1 ]
   do 
       pass_no=0                                                  #pass_no is index number where password to be store
       count=0
       echo -e "\r\nEnter USERNAME :\c"                                                              # cycle=0    
       read  user

       for i in ${user_arr[@]}
       do  
	   pass_no=`expr $pass_no + 1`
	  
	   if [ $user = $i ]
	   then
	     count=1
	     echo -e "\r\e[5m\e[31m\nThis username already exist choose another one\n\e[0m\c"
	    
	     break
	   fi
	                                                         #cycle=`expr $cycle + 1`

       done
                                                                #echo "$cycle"
   done

       if [ $count -eq 0 ]
       then
	  
	   count_pass=1                                         #count_pass is to run loop until user donot type same password twice
	   pass_no=`expr $pass_no + 1`
	   
	  while [ $count_pass -eq 1 ]
	  do
           
	   
	   echo "Enter the Password"
	   read -s password
	   
	   echo "Retype Password"
	   read -s password2
	   
	   if [ $password = $password2  ]
	   then
		count_pass=0
		echo "$user">>user.csv
	        echo "$password">>password.csv                 # sed -i "$pass_no s/.*/$password/" password.csv 
                                                               # (This line dont here because no that line is not exixt in password.csv it can be use for change password)
		echo "$user not given the test">>User_Exam_details.csv
	    else
		echo -e "\n\e[5m\e[31mOops, that's is not the same password as the first one\e[0m\n"
	   fi

       
  	 done
       fi
       echo -e "\n\e[5m $user account has been created successfully\e[0m"
       sleep 6
       main_menu

}

sign_in()
{
   clear
   user_arr=(`cat user.csv`)
   pass_arr=(`cat password.csv`)
   
  
   count=1

   while [ $count -eq 1 ]
   do
       clear
echo -e "\n\e[44m    \e[4mCommand Line Test\e[0m\e[44m    \e[0m\n"
   echo -e "\e[4m\e[1msign in\e[0m"
       read -p "Enter the username:" user
   	position=0
       for i in ${user_arr[@]}
       do
	    

            if [ $user = $i ]
            then
	  
                count=0
	       break	
	    fi
           
	       
             position=`expr $position + 1`
      done

      if [ $count -eq 1 ]
      then
	  echo "username does not exist!"
	  sleep 2
	  clear
      fi

   done
     
   while [ $count -eq 0 ]
   do
      echo -e "\n"
      echo -ne "\rEnter the password:\c"
      read -s password
    
      if [ $password = ${pass_arr[$position]} ]
      then 
	count=1
		
      else
	  sleep 1
	  echo -e "\e[5m\rYou have entered wrong password\c\e[om"
	  sleep 2
	  
      fi
      
  done

  sleep 1

 clear
echo -e "\n\e[44m    \e[4mCommand Line Test\e[0m\e[44m    \e[0m\n"
	echo -e "\nsign in successful\n"

       echo -e "Please choose your option:\n"
  echo -e "1.Take the test\n2.exit\n"
  option=0
  
  while [ $option = 0 ]
  do
      read option

	if [ $option -eq 1  ]
	then
		Test
        elif [ $option -eq 2 ]
	then
      	        Exit
	else
	    option=0
	    echo -e "Invalid option!\n "
	fi
  done
  
}


Test()
{
    clear
    echo -e "\n\e[44m    \e[4mCommand Line Test\e[0m\e[44m    \e[0m\n"
    
    rm -r temp.txt 2> error.txt
  
   touch temp.txt 
   echo -e "\n\e[1m\e[32m\e[5mExam will Start within 10 second\e[0m\n"
   echo -e "\e[0m\e[33mInstruction\n\e[0m\e[1mThere are 10 question each carry 10 mark and to answer you have 10 second for each question.\e[0m"
   sleep 10
   clear
   for i in `seq 5 5 50`
   do
       
      head -$i question.txt | tail -5

       for j in `seq 10 -1 1`
       do
	   	
		echo -e "\rEnter the option:$j \c"
		read -t 1 answer

		if [ "$answer" = "a" -o "$answer" = "b" -o "$answer" = "c" -o "$answer" = "d"  ]
		then
		
		    option="$answer"
		    break
		else
		    option=`echo "e"`
		fi



       done
	
       echo "$option">>temp.txt
      
       
	 clear


   done
  
   Result

}


Result()
{
    clear
	echo "Evaluating your page"
	sleep 3
    clear
    
   mark=0
   k=0
   for i in `seq 5 5 50`
   do
    head -$i question.txt | tail -5
    k=`expr $k + 1`
   
   	user_ans=`head -$k temp.txt | tail -1`
   	 correct_ans=`head -$k answer.txt | tail -1`
	echo "your answer      correct answer"
	echo "    $user_ans                   $correct_ans "
        
          if [ "$user_ans" = "$correct_ans" ]
	  then
	      mark=`expr $mark + 10`
	  fi
	sleep 2
   done
   echo -e "\n\e[32mTotal mark\e[0m = 100\n\e[32m$user score\e[0m = $mark"
   echo "option e mean exceed time limit"
	s=`grep -n "$user" User_Exam_details.csv| cut -c 1`
	#sed -i "$s d" temp.txt
	#echo "$user : $mark">>User_Exam_details.csv
	sleep 6
	clear
}
Exit()
{
   clear

   exit
}

clear
echo -e "\n\e[44m    \e[4mCommand Line Test\e[0m\e[44m    \e[0m\n"
echo -e "\e[1m\e[4mPlease choose the below option:\e[0m\n\e[1m1.sign up\n2.sign in\n3.exit\n"
read select

 case $select in
      1)
	 sign_up
	 ;;

      2)
	  sign_in
	  ;;
      3)
	  Exit
	  ;;
      *)
	  echo "Select valid option"
	  ;;
  esac

