#include <math.h>

#include "pilib.h"


/* program */ 


int main() {
	writeString("\nPlease enter your name: ");
	char* str = readString();
	writeString("Welcome, ");
	writeString(str);
	writeString("\n");
	writeString("Your income for this month is ");
	double dec = 4.245e2;
	writeReal(dec);
	writeString("$");
	int power = 2;
	double result;
	result = pow(dec, 3);
	writeString("\n\nIf you invest your money, in one year you will have earned  ");
	writeInt(result);
	writeString("$");
	writeString("\n\nWe will check if you are able to invest your money. ");
	writeString("\nFor the following questions, please enter 1 for *yes* and 2 for *no*");
	writeString("\nPlease answer if you have childen: ");
	int childen = readInt();
	writeString("\nPlease answer if you pay rent: ");
	int rent = readInt();
	writeString("\nPlease answer if have got loan: ");
	int loan = readInt();
	int chlidren_bool;
	int rent_bool;
	int loan_bool;
	if (childen == 1) {
chlidren_bool = 1;

} else {
chlidren_bool = 0;

}
	if (rent == 1) {
rent_bool = 1;

} else {
rent_bool = 0;

}
	if (loan == 1) {
loan_bool = 1;

} else {
loan_bool = 0;

}
	if ((chlidren_bool == 1 && rent_bool == 1 && loan_bool == 1) | (chlidren_bool == 1 && rent_bool == 1 && loan_bool == 0)) {
writeString("\nYou cannot invest your money. Too risky.\n");

} else {
if (chlidren_bool == 1 && rent_bool == 0 && loan_bool == 1) {
writeString("\nIt is not a good idea to invest your money.\n");

} else {
if (chlidren_bool == 1 && rent_bool == 0 && loan_bool == 0) {
writeString("\nYou could invest your money but be careful!\n");

} else {
if (chlidren_bool == 0 && rent_bool == 1 && loan_bool == 1) {
writeString("\nIt is a bit risky to invest your money.\n");

} else {
if (chlidren_bool == 0 && rent_bool == 1 && loan_bool == 0) {
writeString("\nYou could invest your money properly.\n");

} else {
if (chlidren_bool == 0 && rent_bool == 0 && loan_bool == 1) {
writeString("\nIt is not a good idea to invest your money.\n");

} else {
if (chlidren_bool == 0 && rent_bool == 0 && loan_bool == 0) {
writeString("\nYou can invest your money.\n");

}

}

}

}

}

}

}
}


/* Accepted! */
