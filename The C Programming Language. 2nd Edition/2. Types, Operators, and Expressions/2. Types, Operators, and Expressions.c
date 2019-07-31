#include <stdio.h>
#include <string.h>
#include <math.h>

int htoi(char str[]) {
	int i;
	int result = 0;

	for (i = 0; i < strlen(str); ++i) {
		int num;
		char ch = str[i];

		if (ch >= '1' && ch <= '9') {
			num = ch - '0';
		} else if (ch == 'a') {
			num = 10;
		} else if (ch == 'b') {
			num = 11;
		} else if (ch == 'c') {
			num = 12;
		} else if (ch == 'd') {
			num = 13;
		} else if (ch == 'e') {
			num = 14;
		} else if (ch == 'f') {
			num = 15;
		}

		result += num * (int) pow(16, strlen(str) - i - 1);
	}

	return result;
}

int main() {

	printf("%d\n", htoi("99af"));

	return 0;
}

