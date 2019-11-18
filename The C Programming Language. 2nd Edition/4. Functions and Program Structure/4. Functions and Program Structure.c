#include <stdio.h>
#define concat(a, b) a##b

int main() {
	// Internal automatic variable
	for (int i = 0; i < 3; ++i) {
		int n = 0;

		printf("%d\n", n++); // prints: 0 0 0
	}

	// Internal static variable
	for (int i = 0; i < 3; ++i) {
		static int n = 0;

		printf("%d\n", n++); // prints: 0 1 2
	}

	// operator ##
	int xy = 30;
	printf("%d\n", concat(x, y));
}
