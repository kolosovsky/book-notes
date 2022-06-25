to enable Hooks, All React packages need to be 16.8.0 or higher. Hooks won’t work if you forget to update, for example,
React DOM.

React Native 0.59 and above support Hooks.

**Do I need to rewrite all my class components?**  
No.

**What can I do with Hooks that I couldn’t with classes?**  
Hooks offer a powerful and expressive new way to reuse functionality between
components. [“Building Your Own Hooks”](https://reactjs.org/docs/hooks-custom.html)
provides a glimpse of what’s
possible. [This article](https://medium.com/@dan_abramov/making-sense-of-react-hooks-fdbde8803889) by a React core team
member dives deeper into the new capabilities unlocked by Hooks.

**How much of my React knowledge stays relevant?**  
Hooks are a more direct way to use the React features you already know — such as state, lifecycle, context, and refs.
They don’t fundamentally change how React works, and your knowledge of components, props, and top-down data flow is just
as relevant.

**Should I use Hooks, classes, or a mix of both?**  
When you’re ready, we’d encourage you to start trying Hooks in new components you write. We don’t recommend rewriting
your existing classes to Hooks unless you planned to rewrite them anyway.

You can’t use Hooks inside a class component, but you can definitely mix classes and function components with Hooks in a
single tree. Whether a component is a class or a function that uses Hooks is an implementation detail of that component.
In the longer term, we expect Hooks to be the primary way people write React components.

**Do Hooks cover all use cases for classes?**  
There are no Hook equivalents to the uncommon `getSnapshotBeforeUpdate`, `getDerivedStateFromError`
and `componentDidCatch` lifecycles yet, but we plan to add them soon.

**Do Hooks replace render props and higher-order components?**  
Often, render props and higher-order components render only a single child. We think Hooks are a simpler way to serve
this use case. There is still a place for both patterns. But in most cases, Hooks will be sufficient and can help reduce
nesting in your tree.

**What do Hooks mean for popular APIs like Redux connect() and React Router?**  
You can continue to use the exact same APIs as you always have; they’ll continue to work.

React Redux since v7.1.0 supports Hooks API and exposes hooks like useDispatch or useSelector.

React Router supports hooks since v5.1.

Other libraries might support hooks in the future too.

**Do Hooks work with static typing?**  
Hooks were designed with static typing in mind. Because they’re functions, they are easier to type correctly than
patterns like higher-order components. The latest Flow and TypeScript React definitions include support for React Hooks.

Importantly, custom Hooks give you the power to constrain React API if you’d like to type them more strictly in some
way. React gives you the primitives, but you can combine them in different ways than what we provide out of the box.

**What exactly do the lint rules enforce?**  
We provide an ESLint plugin that enforces rules of Hooks to avoid bugs. It assumes that any function starting with ”use”
and a capital letter right after it is a Hook.

In particular, the rule enforces that:

- Calls to Hooks are either inside a PascalCase function (assumed to be a component) or another useSomething function (
  assumed to be a custom Hook).
- Hooks are called in the same order on every render.

There are a few more heuristics, and they might change over time.

**How do lifecycle methods correspond to Hooks?**

- `constructor`: Function components don’t need a constructor. You can initialize the state in the `useState` call. If
  computing the initial state is expensive, you can pass a function to `useState`.
- `getDerivedStateFromProps`: Schedule an update while rendering instead.
- `shouldComponentUpdate`: See `React.memo` below.
- `render`: This is the function component body itself.
- `componentDidMount`, `componentDidUpdate`, `componentWillUnmount`: The `useEffect` Hook can express all combinations
  of these (including less common cases).
- `getSnapshotBeforeUpdate`, `componentDidCatch` and `getDerivedStateFromError`: There are no Hook equivalents for these
  methods yet, but they will be added soon.

**How can I do data fetching with Hooks?**  
Here is a [small demo](https://codesandbox.io/s/jvvkoo8pq3) to get you started. To learn more, check
out [this article](https://www.robinwieruch.de/react-hooks-fetch-data/)
about data fetching with Hooks.

**Is there something like instance variables?**  
Yes! The `useRef()` Hook isn’t just for DOM refs. The “ref” object is a generic container whose current property is
mutable and can hold any value, similar to an instance property on a class.

You can write to it from inside `useEffect`:

```tsx
function Timer() {
    const intervalRef = useRef();

    useEffect(() => {
        const id = setInterval(() => {
            // ...
        });
        intervalRef.current = id;
        return () => {
            clearInterval(intervalRef.current);
        };
    });

    // ...
}
```

If we just wanted to set an interval, we wouldn’t need the `ref` (`id` could be local to the effect), but it’s useful if
we want to clear the interval from an event handler:

```tsx
// ...
function handleCancelClick() {
    clearInterval(intervalRef.current);
}

// ...
```

Conceptually, you can think of refs as similar to instance variables in a class. Unless you’re doing lazy
initialization, avoid setting refs during rendering — this can lead to surprising behavior. Instead, typically you want
to modify refs in event handlers and effects.

