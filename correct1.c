#include <math.h>

#include "pilib.h"


/* program */ 


int choose (int a, int b) {
	if ((a + 1) <= (b - 1)) {
return b;

} else {
return a;

}
}

void evenodd (int num) {
	int mult , even , odd;
	if (num % 2 == 0) {
writeString("\n EVEN \n");
 for (mult = 2 ; mult <= 5 ; mult = mult + 1) {
even = mult * num;
 writeString(" ");
 writeInt(even);

}
 writeString(" are also even\n");

} else {
writeString("\n ODD \n");
 for (mult = 2 ; mult <= 5 ; mult = mult + 1) {
odd = 2 * mult * num + 1;
 writeString(" ");
 writeInt(odd);

}
 writeString(" are also even\n");

}
}

int main() {
	int res_choose;
	res_choose = choose(2 , 5);
	writeString("\nres_choose : ");
	writeInt(res_choose);
	evenodd(res_choose);
	res_choose = choose(2 , 4);
	writeString("\nres_choose : ");
	writeInt(res_choose);
	evenodd(res_choose);
	int list[10];
	if (list != NULL) {
writeString("\nList not null\n ");

}
	int i;
	writeString("\nList:  ");
	for (i = 0 ; i < 10 ; i = i + 1) {
list[i] = i;
 writeInt(list[i]);
 writeString(" ");

}
	for (i = 0 ; i < 10 ; i = i + 1) {
if (i == 4) {
writeString("\nBREAK! \n");
 break;

}

}
}


/* Accepted! */
