#this program set and update both room's temperature and its smoke sensor rate. we set a critical limit range for the the temperature system with <15 and >30
#we also set critical range for smoke sensor rate which is >=30. the program is according to our flowchart.
#here are the four members of the group and their respective part of work in the program
#1. Islam MD Shariful : works on Login and check passwork verification and username verification 
#2.  : works on setting Room temperature and updating room temperature
#3. : works on Smoke sensor Rate setting part of the program
#4. : works on decrease setting of the temperature and termination of the program
 
.data
welcomeMsg:  .asciiz "<---Welcome to Smart Home System--->\nPlease Login!!\n"
userNMsg:  .asciiz "Enter your username: "
passMsg:  .asciiz "Enter your password: "
wrongMsg:  .asciiz "Please enter correct username and password!!!\n"
Option:   .asciiz "Choose an option:\n\t1: set temperature\n\t2: Decrease Temperature\n\t3: Do nothing\n"
wrongOpt:  .asciiz "Invalid option. Choose valid one!!!\n"
roomTemp:  .asciiz "Enter the initial temperature of the Room : "
howManyRem:  .asciiz "How many degre do you want to Decrease to the current temperature? "
tempMsg:  .asciiz "\nHow many degre do you want to add to the current temperature : "
SensorRateEnteringMsg:  .asciiz "\nset the Smoking sensor rate: "
user1:   .asciiz "jacques"
user2:   .asciiz "sagar"
user3:   .asciiz "Shariful"
user4:   .asciiz "nabila"
currentTemp:.word 20
ContinueMsg:.asciiz "\n\Enter 1 for yes and 2 for No if you want to do another action"
continueOption:.asciiz "\n\Choose an option:\n\t1: Yes\n\t2: No\n"
cantDecrease:  .asciiz "you didn't set any temperature. So, you can't decrease by any level!!!\n"
wrongInputSensorRateNumber:  .asciiz "Smoke rate entered is inaccurate!!\n"
smokeCriticalMsg:  .asciiz "the smoking rate is critical\n"
tempOverMsg:  .asciiz "Your are in the critical limit range. Please update the temperature to the normal!!\n"
lessAlert:  .asciiz "Your are in the less critical limit range. Please update the temperature to the normal!!\n"
greaterAlert:  .asciiz "you are in the most critical limit range. Please update to the normal!!\n"
isCurrentTemp:  .asciiz "oC is the current temperature!\n ."
NumberOfDegreDecrease:  .asciiz " temperature degre are Decreased.\n"
InitialTemperature:  .asciiz "\nthe initial Temperature of the Room was : "
tempIs:   .asciiz "\n you have updated the current room temperature to : "
SmokeRateIs:  .asciiz "\n the Smoke Sensor Rate of the room is currently : "
storeTemp:  .word 0
dataBaseTemp:.word 0
initiale:.word 0
YesNumber:.word 1
password:  .word 12345
userName:  .space 11
 
.text
# display welcome message
la $a0, welcomeMsg
jal displayNotification

main:

# display username message
la $a0, userNMsg
jal displayNotification

# read username from user
la $a0, userName
li $a1,11   # 10 charcaters can be read from user
jal readStrInput

# print password message
la $a0, passMsg
jal displayNotification

# read password from user
jal readIntInput
move $t0, $v0  # move password into t0

#check all users names
checkUserName:

 la $a0, user1
 la $a1, userName
 jal strCmp  # check username and user1 are equal or not
 beqz $v0, checkPassword # if v0 == 0 goto checkPassword
 
 la $a0, user2
 la $a1, userName
 jal strCmp  # check username and user2 are equal or not
 beqz $v0, checkPassword # if v0 == 0 goto checkPassword
 
 la $a0, user3
 la $a1, userName
 jal strCmp  # check username and user2 are equal or not
 beqz $v0, checkPassword # if v0 == 0 goto checkPassword
 
 la $a0, user4
 la $a1, userName
 jal strCmp  # check username and user2 are equal or not
 beqz $v0, checkPassword # if v0 == 0 goto checkPassword
 j inValid   # else jump on inValid
 
checkPassword:
 lw $t1, password  # load password into t1
 bne $t0, $t1, inValid # if t0 != password goto inValid
 
DisplayOption:
 # display Option on console
 la $a0, Option
 jal displayNotification
 # read option from user
 jal readIntInput
 move $t0, $v0  # move choice into t0
 beq $t0, 1, InitialRoomTempEntered  # if choice == 1 goto InitialRoomTempEntered
 beq $t0, 2, Decrease # else if choice == 2 goto Decrease
 beq $t0, 3, exit # else if choice == 3 goto printValue
 la $a0, wrongOpt  # else print wrong option message
 jal displayNotification
 j DisplayOption   # jump on DisplayOption
 
 
InitialRoomTempEntered:
 # print the initial room temp message 
 la $a0, roomTemp  
 jal displayNotification
 jal readIntInput
 move $t0, $v0  # move temp  into t0
 # integer value
 move $a0, $t0  
 jal displayIntegerValue
  # print the initial temp just entered string
 la $a0, isCurrentTemp
 jal displayNotification
 lw $t1, storeTemp  # stored temp
 add $t1, $t1, $t0  # present temp = store temperature + added temperature
 sw $t1, initiale  # update storeTemp
 blt $t1, 15, runningOut # if present temperature < 15 goto runningOut
 bgt $t1, 30, HighTemp # else if present temp > 30 goto HighTemp
 j gotoTemperature #else if want to increase
 
 gotoTemperature:
 # print enter temperature to increase with message
 la $a0, tempMsg  
 jal displayNotification
 # read temperature from user
 jal readIntInput 
 move $t3, $v0  # move temperature into t3
 add $t3, $t3, $t1
 sw $t3, dataBaseTemp
 blt $t3, 15, tempAlert # if temperature < 15 goto tempAlert
 bgt $t3, 30, tempAlert # else if temperature > 30 goto tempAlert
 jal goToSensor
 
 runningOut:
  # print runningOut message
  la $a0, lessAlert
  jal displayNotification # display less Alert Notification
  j DisplayOption # display option
  
 HighTemp:
  # print HighTemp message
la $a0, greaterAlert
  jal displayNotification # display greater Alert Notification
  j DisplayOption # display option
  
goToSensor:
 # print enter smokeSensorRate message
 la $a0, SensorRateEnteringMsg
 jal displayNotification
 jal readIntInput # read smokeSensorRate from user
 move $t2, $v0  # move smokeSensorRate into t2
 blez $t2, InvalidSensorRate  # if sensorRate input not valid
 bge $t2, 30, sensorAlert # if sensorRate >= 30 goto sensorAlert
 j printValue # print value
  
 sensorAlert:
  # print smokeSensorRate HighTemp message
  la $a0, smokeCriticalMsg
  jal displayNotification
  j DisplayOption
  
 InvalidSensorRate:
 #print smokeSensorRate wong input message
  la $a0, wrongInputSensorRateNumber
  jal displayNotification
  j goToSensor
  
 tempAlert:
  # print temperature over loaded message
  la $a0, tempOverMsg
  jal displayNotification
 j DisplayOption
 
Decrease:
 # print how many Decrease message
 la $a0, howManyRem
 jal displayNotification
 # read Decreased temperatures from user
 jal readIntInput
 move $t0, $v0  # move Decreased temperatures into t0
 lw $t1, dataBaseTemp  # stored temperature
 beqz $t1, cantBeDecrease
 # print Decreased temperatures
 move $a0, $t0
 jal displayIntegerValue
 # print temperatures Decreased message
 la $a0, NumberOfDegreDecrease
 jal displayNotification
 lw $t1, dataBaseTemp  # stored temperature
 sub $t1, $t1, $t0  # present temperature = store temperature - added temperature
 sw $t1, dataBaseTemp  # update store temperature
 blt $t1, 15, runningOut # if t1 < 15 goto runningOut
 bgt $t1, 30, HighTemp # else if t1 > 30 goto HighTemp
 j goToSensor  # jump on goToSensor
 
cantBeDecrease:
 # print can't Decrease message
 la $a0, cantDecrease
 jal displayNotification
 j DisplayOption
 
# if username or password wrong then this block of code execute
inValid:
 # print invalid message
 la $a0, wrongMsg
 jal displayNotification
 j main # jump on main

printValue:
 # print total temperatures message
 la $a0, InitialTemperature
 jal displayNotification
 # print total temperatures value
 lw $a0, initiale
 jal displayIntegerValue
 # print smokeSensorRate message
 la $a0, SmokeRateIs
 jal displayNotification
 # print smokeSensorRate value
 move $a0, $t2
 jal displayIntegerValue
 # print temperature message
 la $a0, tempIs
 jal displayNotification
 # print temperature value
 lw $t0, dataBaseTemp
 move $a0, $t0
 jal displayIntegerValue  
 
 #print continue msg
 continue:
 la $a0, ContinueMsg
 jal displayNotification
 #print choosing option
 la $a0,continueOption
 jal displayNotification
 #read input option from the user
 jal readIntInput
 move $t5, $v0
 #check option chosen
 lw $t6, YesNumber
 beq $t5,$t6, DisplayOption
 bne $t5, $t6, exit
 
# End of program
exit:
 li $v0, 10
 syscall

# this function display a string on console
displayNotification:
 li $v0, 4
 syscall
 jr $ra
 
# this function read integer value from user
readIntInput:
 li $v0, 5
 syscall 
 jr $ra

# this function read string value from user
readStrInput:
 li $v0, 8
 syscall 
 jr $ra
 
# this function print integer value on console
displayIntegerValue:
 li $v0, 1
 syscall 
 jr $ra

# this function compare two string if both strings are equal then $v0 = 0 
strCmp:
 add $s0,$zero,$zero  # s0 = 0
 add $s1,$zero,$a0   # s1 = first string address
 add $s2,$zero,$a1   # s2 = second string address
 loop:
  lb $s3,0($s1)   # load a byte from string 1
  lb $s4,0($s2)   # load a byte from string 2
  beq $s3, 10, returnStrCmp #equal
  beqz $s3, returnStrCmp   #Equal to 0
  bne $s3, $s4, setMinusOne   #if not equal
  li $v0, 0
  j nextChars
 setMinusOne:
  li $v0, -1
 nextChars:
  addi $s1,$s1,1   # s1 points to the next byte of str1
  addi $s2,$s2,1
  j loop
returnStrCmp:
 jr $ra
