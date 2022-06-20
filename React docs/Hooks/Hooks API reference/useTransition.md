```tsx
const [isPending, startTransition] = useTransition();
```

Returns a stateful value for the pending state of the transition, and a function to start it.

`startTransition` lets you mark updates in the provided callback as transitions:

```tsx
startTransition(() => {
    setCount(count + 1);
})
```

`isPending` indicates when a transition is active to show a pending state:

```tsx
function App() {
    const [isPending, startTransition] = useTransition();
    const [count, setCount] = useState(0);

    function handleClick() {
        startTransition(() => {
            // while this function is executing isPending is true
            
            setCount(c => c + 1);
            
            // when this function is executed isPending is false again
        })
    }

    return (
        <div>
            {isPending && <Spinner/>}
            <button onClick={handleClick}>{count}</button>
        </div>
    );
}
```

Updates in a transition yield to more urgent updates such as clicks.

Updates in a transitions will not show a fallback for re-suspended content. This allows the user to continue interacting
with the current content while rendering the update.
