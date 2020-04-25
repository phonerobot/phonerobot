#include "mbed.h"

Serial blue(p28,p27);

DigitalOut myled(LED1);
PwmOut Motor1(p23);
PwmOut Motor2(p24);
PwmOut Motor3(p25);
PwmOut Motor4(p26);

int main()
{
    
    Motor1 = 0.0;
    Motor2 = 0.0;
    Motor3 = 0.0;
    Motor4 = 0.0;
    char bnum=0;
    char bhit=0;
    while(1) {
        if (blue.getc()=='!') {
            if (blue.getc()=='B') { //button data packet
                bnum = blue.getc(); //button number
                bhit = blue.getc(); //1=hit, 0=release
                if (blue.getc()==char(~('!' + 'B' + bnum + bhit))) { //checksum OK?
                    myled = bnum - '0'; //current button number will appear on LEDs
                    switch (bnum) {
                       
                        case '5': //button 5 up arrow
                            if (bhit=='1') {
                              Motor1 = 0.5;
                              Motor2 = 0.5;
                              Motor3 = 0.5;
                              Motor4 = 0.5;
                                //add hit code here
                            } else {
                                //add release code here
                              Motor1 = 0.0;
                              Motor2 = 0.0;
                              Motor3 = 0.0;
                              Motor4 = 0.0;
                                
                            }
                            break;
                        case '6': //button 6 down arrow
                            if (bhit=='1') {
                              Motor1 = 0.0;
                              Motor2 = 0.0;
                              Motor3 = 0.0;
                              Motor4 = 0.0;
                                
                                //add hit code here
                            } else {
                              Motor1 = 0.0;
                              Motor2 = 0.0;
                              Motor3 = 0.0;
                              Motor4 = 0.0;
                                //add release code here
                            }
                            break;
                        case '7': //button 7 left arrow
                            if (bhit=='1') {
                              Motor1 = 0.2;
                              Motor2 = 0.2;
                              Motor3 = 0.95;
                              Motor4 = 0.95;
                                //add hit code here
                            } else {
                                //add release code here
                              Motor1 = 0.0;
                              Motor2 = 0.0;
                              Motor3 = 0.0;
                              Motor4 = 0.0;
                                
                            }
                            break;
                        case '8': //button 8 right arrow
                            if (bhit=='1') {
                                //add hit code here
                              Motor1 = 0.95;
                              Motor2 = 0.95;
                              Motor3 = 0.2;
                              Motor4 = 0.2;
                                
                            } else {
                                //add release code here
                              Motor1 = 0.0;
                              Motor2 = 0.0;
                              Motor3 = 0.0;
                              Motor4 = 0.0;
                            }
                            break;
                        default:
                            break;
                    }
                }
            }
        }
    }
}

