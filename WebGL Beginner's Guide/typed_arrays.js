/*
Buffer is an object representing a chunk of data.
It has no format to speak of and offers no mechanism for accessing its contents.
Create ArrayBuffer with 256 byte length:
*/

let arrayBuffer = new ArrayBuffer(256);

/*
In order to access the memory contained in a buffer, you need to use a **view**.
A view provides a context — that is, a data type, starting offset, and the
number of elements — that turns the data into a typed array.

Create a view that points to a buffer:
*/
let int16Array = new Int16Array(arrayBuffer);

// default value of all values is 0
console.log(int16Array[0]); // 0
console.log(int16Array[10]); // 0


/* Access to a view's buffer: */
console.log(int16Array.buffer);

/*
In our case we have a buffer with 256 byte length and a view (Int16Array) that allocates 2 bytes for each value.
So the view has maximum length 256 / 2 = 128. You can calculate it:
*/
console.log(`the view has maximum length = ${int16Array.BYTES_PER_ELEMENT * int16Array.byteLength}`);

int16Array[127] = 1;
console.log(int16Array[127]); // 1

// try to assign a value to an index exciding maximum length
int16Array[128] = 2;
console.log(int16Array[128]); // undefined

// try to assign a value exceeding the allowed range (allowed range for int16Array is from 0 to 65535)
int16Array[0] = 65536;
console.log(int16Array[0]); // 0
