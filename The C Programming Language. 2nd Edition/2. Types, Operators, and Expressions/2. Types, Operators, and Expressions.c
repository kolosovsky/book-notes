#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdbool.h>
#include <ctype.h>

// exercise 2-3
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

// exercise 2-5
int any(char s1[], char s2[]) {
	int result;
	int found = 0;

	for (int i = 0; i < strlen(s2); ++i) {
		char ch = s2[i];

		for (int j = 0; j < strlen(s1); ++j) {
			if (s1[j] == ch && (!found || result > j)) {
				printf("%c, %d\n", ch, j);
				result = j;
				found = 1;
			}
		}
	}

	return found ? result : -1;
}

int main() {

//	printf("%d\n", htoi("99af"));
//	printf("%d\n", any("asdf", "jjd;s"));

	return 0;
}

