```tsx
const memoizedCallback = useCallback(
    () => {
        doSomething(a, b);
    },
    [a, b],
);
```

Returns a [memoized](https://en.wikipedia.org/wiki/Memoization) callback.

Pass an inline callback and an array of dependencies. `useCallback` will return a memoized version of the callback that
only changes if one of the dependencies has changed. This is useful when passing callbacks to optimized child components
that rely on reference equality to prevent unnecessary renders (e.g. `shouldComponentUpdate`).

`useCallback(fn, deps)` is equivalent to `useMemo(() => fn, deps)`.

The array of dependencies is not passed as arguments to the callback. Conceptually, though, that’s what they represent:
every value referenced inside the callback should also appear in the dependencies array. In the future, a sufficiently
advanced compiler could create this array automatically.

We recommend using the exhaustive-deps rule as part of our eslint-plugin-react-hooks package. It warns when dependencies
are specified incorrectly and suggests a fix.

