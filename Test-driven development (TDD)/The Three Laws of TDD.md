The three laws of TDD:

1. Do not write production code behaviour of which is not covered with tests
2. Do not write more tests than needed to fail
3. Do not write more production code than needed to make tests pass

You must begin by writing a unit test for the functionality that you intend to write. But by rule 2, you can't write
very much of that unit test. As soon as the unit test code fails to compile, or fails an assertion, you must stop and
write production code. But by rule 3 you can only write the production code that makes the test compile or pass, and no
more.

At some point of development rule 3 requires writing something like this

```typescript
class List {
    contain(key: string): boolean {
        return true;
    }
}
```

which feels like cheating.

(personal opinion, may be misunderstanding) The simplest reason to use TDD I find for myself is that we need to have a
way of checking if our tests actually work. We can't write tests for tests. So the only solution is to use a methodology
that helps to write working tests.
