`useReducer` is an alternative to `useState`. Accepts a reducer of type `(state, action) => newState`, and returns the current state
paired with a dispatch method.

`useReducer` is usually preferable to `useState` when you have complex state logic that involves multiple sub-values or
when the next state depends on the previous one. `useReducer` also lets you optimize performance for components that
trigger deep updates because you can pass dispatch down instead of callbacks.

React guarantees that `dispatch` function identity is stable and won’t change on re-renders. This is why it’s safe to
omit from the `useEffect` or `useCallback` dependency list.

There are two different ways to initialize `useReducer` state. You may choose either one depending on the use case.

**First way**. The simplest way is to pass the initial state as a second argument:

```tsx
const [state, dispatch] = useReducer(
    reducer,
    {count: initialCount}
);
```

React doesn’t use the `state = initialState` argument convention popularized by Redux. The initial value sometimes needs
to depend on props and so is specified from the Hook call instead. If you feel strongly about this, you can call
`useReducer(reducer, undefined, reducer)` to emulate the Redux behavior, but it’s not encouraged.

**Second way.** You can also create the initial state lazily. To do this, you can pass an init function as the third
argument. The initial state will be set to `init(initialArg)`.

It lets you extract the logic for calculating the initial state outside the reducer. This is also handy for resetting
the state later in response to an action:

```tsx
function init(initialCount) {
    return {count: initialCount};
}

function reducer(state, action) {
    switch (action.type) {
        case 'increment':
            return {count: state.count + 1};
        case 'decrement':
            return {count: state.count - 1};
        case 'reset':
            return init(action.payload);
        default:
            throw new Error();
    }
}

function Counter({initialCount}) {
    const [state, dispatch] = useReducer(reducer, initialCount, init);
    return (
        <>
            Count: {state.count}
            <button
                onClick={() => dispatch({type: 'reset', payload: initialCount})}>
                Reset
            </button>
            <button onClick={() => dispatch({type: 'decrement'})}>-</button>
            <button onClick={() => dispatch({type: 'increment'})}>+</button>
        </>
    );
}
```

If you return the same value from a Reducer Hook as the current state, React will bail out without rendering the
children or firing effects. (React uses the `Object.is` comparison algorithm.)

Note that React may still need to render that specific component again before bailing out. That shouldn’t be a concern
because React won’t unnecessarily go “deeper” into the tree. If you’re doing expensive calculations while rendering, you
can optimize them with `useMemo`.

