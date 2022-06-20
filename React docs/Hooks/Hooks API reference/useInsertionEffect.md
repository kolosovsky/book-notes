```tsx
useInsertionEffect(didUpdate);
```

The signature is identical to `useEffect`, but it fires synchronously before all DOM mutations. Use this to inject
styles into the DOM before reading layout in useLayoutEffect. Since this hook is limited in scope, this hook does not
have access to refs and cannot schedule updates.

`useInsertionEffect` should be limited to css-in-js library authors. Prefer `useEffect` or `useLayoutEffect` instead.
