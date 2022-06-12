```tsx
const memoizedValue = useMemo(() => computeExpensiveValue(a, b), [a, b]);
```

Returns a memoized value.

Pass a “create” function and an array of dependencies. useMemo will only recompute the memoized value when one of the
dependencies has changed. This optimization helps to avoid expensive calculations on every render.

Remember that the function passed to useMemo runs during rendering. Don’t do anything there that you wouldn’t normally
do while rendering. For example, side effects belong in `useEffect`, not `useMemo`.

If no array is provided, a new value will be computed on every render. Using `useMemo()` with an empty dependencies
array will calculate the value only once, on mount.

You may rely on useMemo as a performance optimization, not as a semantic guarantee. In the future, React may choose to
“forget” some previously memoized values and recalculate them on next render, e.g. to free memory for offscreen
components. Write your code so that it still works without `useMemo` — and then add it to optimize performance.

The array of dependencies is not passed as arguments to the function. Conceptually, though, that’s what they represent:
every value referenced inside the function should also appear in the dependencies array. In the future, a sufficiently
advanced compiler could create this array automatically.

We recommend using the `exhaustive-deps` rule as part of our `eslint-plugin-react-hooks` package. It warns when
dependencies are specified incorrectly and suggests a fix.
