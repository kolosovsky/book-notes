#include <stdio.h>

int main() {
	int x = 1, y = 2, z[10];
	int *ip; // declare a pointer to int 

	ip = &x; // ip now points to x 
	y = *ip; // y is now 1 
	*ip = 0; // x is now 0 
	ip = &z[0]; // ip now points to z[0] 
	z[0] = 7; // z[0] is now 7 
	*ip = 8; // z[0] is now 8 

	printf("x: %d, y: %d, z[0]: %d\n", x, y, *ip); // x: 0, y: 1, z[0]: 8
	printf("%d\n", *ip == z[0]); // 1
	printf("%d\n", ip == &z[0]); // 1

	return 0;
}
