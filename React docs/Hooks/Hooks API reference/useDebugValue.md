`useDebugValue` can be used to display a label for custom hooks in React DevTools.

For example, consider the `useFriendStatus` custom Hook described in “Building Your Own Hooks”:

```tsx
function useFriendStatus(friendID) {
    const [isOnline, setIsOnline] = useState(null);

    // ...

    // Show a label in DevTools next to this Hook
    // e.g. "FriendStatus: Online"
    useDebugValue(isOnline ? 'Online' : 'Offline');

    return isOnline;
}
```

In some cases formatting a value for display might be an expensive operation. It’s also unnecessary unless a Hook is
actually inspected.

For this reason `useDebugValue` accepts a formatting function as an optional second parameter. This function is only
called if the Hooks are inspected. It receives the debug value as a parameter and should return a formatted display
value.

For example a custom Hook that returned a Date value could avoid calling the `toDateString` function unnecessarily by
passing the following formatter:

```tsx
useDebugValue(date, date => date.toDateString());
```
