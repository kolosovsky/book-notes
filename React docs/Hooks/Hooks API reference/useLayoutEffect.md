The signature is identical to `useEffect`, but it fires synchronously after all DOM mutations. Use this to read layout
from the DOM and synchronously re-render. Updates scheduled inside `useLayoutEffect` will be flushed synchronously,
before the browser has a chance to paint.

Prefer the standard `useEffect` when possible to avoid blocking visual updates.

If you’re migrating code from a class component, note `useLayoutEffect` fires in the same phase as `componentDidMount`
and `componentDidUpdate`. However, we recommend starting with `useEffect` first and only trying `useLayoutEffect` if
that causes a problem.
