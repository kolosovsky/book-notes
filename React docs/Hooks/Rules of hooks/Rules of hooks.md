Hooks are JavaScript functions, but you need to follow two rules when using them.

### Only Call Hooks at the Top Level

Don’t call Hooks inside loops, conditions, or nested functions. Instead, always use Hooks at the top level of your React
function, before any early returns. By following this rule, you ensure that Hooks are called in the same order each time
a component renders. That’s what allows React to correctly preserve the state of Hooks between multiple `useState` and
`useEffect` calls.

How does React know which state corresponds to which useState call? The answer is that React relies on the order in
which Hooks are called.

**Bad** example (breaking the first rule):

```tsx
if (name !== '') {
    useEffect(function persistForm() {
        localStorage.setItem('formData', name);
    });
}
```

**Good** example (not breaking the first rule):

```tsx
useEffect(function persistForm() {
    if (name !== '') {
        localStorage.setItem('formData', name);
    }
});
```

### Only Call Hooks from React Functions

Don’t call Hooks from regular JavaScript functions. Instead, you can:

- ✅ Call Hooks from React function components.
- ✅ Call Hooks from custom Hooks.

By following this rule, you ensure that all stateful logic in a component is clearly visible from its source code.

We released an ESLint plugin called eslint-plugin-react-hooks that enforces these two rules.
