The three laws of TDD:

1. Do not write production code behaviour of which is not covered with tests
2. Do not write more tests than needed to fail
3. Do not write more production code than needed to make tests pass

You must begin by writing a unit test for the functionality that you intend to write. But by rule 2, you can't write
very much of that unit test. As soon as the unit test code fails to compile, or fails an assertion, you must stop and
write production code. But by rule 3 you can only write the production code that makes the test compile or pass, and no
more.

At some point of development rule 3 requires to write something like this
```typescript
class List {
    contain(key: string): boolean {
        return true;
    }
}
```
which feels like cheating. 

