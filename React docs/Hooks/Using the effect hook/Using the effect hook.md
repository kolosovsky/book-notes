The Effect Hook lets you perform side effects in function components.

**SHORT EXPLANATION**

```tsx
useEffect(() => {
    // this is "effect" function

    return () => {
        // this is "cleanup" function and it optional,
        // effect function may not return it
    }
}, [] /* this array is dependencies list, it is optional */);
```

Way 1 (with empty dependencies array):

```tsx
useEffect(() => {
    // executed only after the very first render

    return () => {
        // executed only before unmount
    }
}, []);
```

Way 2 (with dependencies):

```tsx
useEffect(() => {
    // executed only after the very first render and
    // after render when prop1 or prop2 has been changed compared to previous render

    return () => {
        // executed before unmount and before every effect 
    }
}, [prop1, prop2]);
```

Way 3 (without dependencies):

```tsx
useEffect(() => {
    // executed after every render

    return () => {
        // executed before unmount and before every effect 
    }
});
```

**LONG EXPLANATION**

Data fetching, setting up a subscription, and manually changing the DOM in React components are all examples of side
effects. Whether or not you’re used to calling these operations “side effects” (or just “effects”), you’ve likely
performed them in your components before.

If you’re familiar with React class lifecycle methods, you can think of useEffect Hook as `componentDidMount`,
`componentDidUpdate`, and `componentWillUnmount` combined.

In React class components, the `render` method itself shouldn’t cause side effects. It would be too early — we typically
want to perform our effects after React has updated the DOM.

This is why in React classes, we put side effects into `componentDidMount` and `componentDidUpdate`. Coming back to our
example, here is a React counter class component that updates the document title right after React makes changes to the
DOM:

```tsx
class Example extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            count: 0
        };
    }

    componentDidMount() {
        document.title = `You clicked ${this.state.count} times`;
    }

    componentDidUpdate() {
        document.title = `You clicked ${this.state.count} times`;
    }

    render() {
        return (
            <div>
                <p>You clicked {this.state.count} times</p>
                <button onClick={() => this.setState({count: this.state.count + 1})}>
                    Click me
                </button>
            </div>
        );
    }
}
```

Now let’s see how we can do the same with the `useEffect` Hook:

```tsx
import React, { useState, useEffect } from 'react';

function Example() {
    const [count, setCount] = useState(0);

    useEffect(() => {
        document.title = `You clicked ${count} times`;
    });

    return (
        <div>
            <p>You clicked {count} times</p>
            <button onClick={() => setCount(count + 1)}>
                Click me
            </button>
        </div>
    );
}
```

**What does useEffect do?** By using this Hook, you tell React that your component needs to do something after render.
React will remember the function you passed (we’ll refer to it as our “effect”), and call it later after performing the
DOM updates. In this effect, we set the document title, but we could also perform data fetching or call some other
imperative API.

**Why is useEffect called inside a component?** Placing useEffect inside the component lets us access the count state
variable (or any props) right from the effect. We don’t need a special API to read it — it’s already in the function
scope. Hooks embrace JavaScript closures and avoid introducing React-specific APIs where JavaScript already provides a
solution.

**Does useEffect run after every render?** Yes! By default, it runs both after the first render and after every
update. Instead of thinking in terms of “mounting” and “updating”, you
might find it easier to think that effects happen “after render”. React guarantees the DOM has been updated by the time
it runs the effects.

Function passed to `useEffect` is going to be different on every render. This is intentional. In fact, this is what lets
us read the count value from inside the effect without worrying about it getting stale. Every time we re-render, we
schedule a different effect, replacing the previous one. In a way, this makes the effects behave more like a part of the
render result — each effect “belongs” to a particular render.

Unlike `componentDidMount` or `componentDidUpdate`, effects scheduled with `useEffect` don’t block the browser from
updating the screen. This makes your app feel more responsive. The majority of effects don’t need to happen
synchronously. In the uncommon cases where they do (such as measuring the layout), there is a separate `useLayoutEffect`
Hook with an API identical to `useEffect`.

In a React class, you would typically set up a subscription in `componentDidMount`, and clean it up
in `componentWillUnmount`.

Let’s see how we could write this component with Hooks. If your effect returns a function, React will run it when it is
time to clean up:

```tsx
import React, { useState, useEffect } from 'react';

function FriendStatus(props) {
    const [isOnline, setIsOnline] = useState(null);

    useEffect(() => {
        function handleStatusChange(status) {
            setIsOnline(status.isOnline);
        }

        ChatAPI.subscribeToFriendStatus(props.friend.id, handleStatusChange);
        // Specify how to clean up after this effect:
        return function cleanup() {
            ChatAPI.unsubscribeFromFriendStatus(props.friend.id, handleStatusChange);
        };
    });

    if (isOnline === null) {
        return 'Loading...';
    }
    return isOnline ? 'Online' : 'Offline';
}
```

**Why did we return a function from our effect?** This is the optional cleanup mechanism for effects. Every effect may
return a function that cleans up after it. This lets us keep the logic for adding and removing subscriptions close to
each other. They’re part of the same effect!

**When exactly does React clean up an effect?** React performs the cleanup when the component unmounts. However, as we
learned earlier, effects run for every render and not just once. This is why React also cleans up effects from the
previous render before running the effects next time.

Why effects run on each update? If you’re used to classes, you might be wondering why the effect cleanup phase happens
after every re-render, and not just once during unmounting. Consider the following class component:

```tsx
componentDidMount()
{
    ChatAPI.subscribeToFriendStatus(
        this.props.friend.id,
        this.handleStatusChange
    );
}

componentWillUnmount()
{
    ChatAPI.unsubscribeFromFriendStatus(
        this.props.friend.id,
        this.handleStatusChange
    );
}
```

But what happens if the friend prop changes while the component is on the screen? Our component would continue
displaying the online status of a different friend. This is a bug. We would also cause a memory leak or crash when
unmounting since the unsubscribe call would use the wrong friend ID.

In a class component, we would need to add `componentDidUpdate` to handle this case:

```tsx
componentDidUpdate(prevProps)
{
    // Unsubscribe from the previous friend.id
    ChatAPI.unsubscribeFromFriendStatus(
        prevProps.friend.id,
        this.handleStatusChange
    );
    // Subscribe to the next friend.id
    ChatAPI.subscribeToFriendStatus(
        this.props.friend.id,
        this.handleStatusChange
    );
}
```

Now consider the version of this component that uses Hooks:

```tsx
function FriendStatus(props) {
    // ...
    useEffect(() => {
        // ...
        ChatAPI.subscribeToFriendStatus(props.friend.id, handleStatusChange);
        return () => {
            ChatAPI.unsubscribeFromFriendStatus(props.friend.id, handleStatusChange);
        };
    });
```

It doesn’t suffer from this bug.

There is no special code for handling updates because useEffect handles them by default. It cleans up the previous
effects before applying the next effects. To illustrate this, here is a sequence of subscribe and unsubscribe calls that
this component could produce over time:

```tsx
// Mount with { friend: { id: 100 } } props
ChatAPI.subscribeToFriendStatus(100, handleStatusChange);     // Run first effect

// Update with { friend: { id: 200 } } props
ChatAPI.unsubscribeFromFriendStatus(100, handleStatusChange); // Clean up previous effect
ChatAPI.subscribeToFriendStatus(200, handleStatusChange);     // Run next effect

// Update with { friend: { id: 300 } } props
ChatAPI.unsubscribeFromFriendStatus(200, handleStatusChange); // Clean up previous effect
ChatAPI.subscribeToFriendStatus(300, handleStatusChange);     // Run next effect

// Unmount
ChatAPI.unsubscribeFromFriendStatus(300, handleStatusChange); // Clean up last effect
```

In some cases, cleaning up or applying the effect after every render might create a performance problem. In class
components, we can solve this by writing an extra comparison with `prevProps` or `prevState`
inside `componentDidUpdate`:

```tsx
componentDidUpdate(prevProps, prevState)
{
    if (prevState.count !== this.state.count) {
        document.title = `You clicked ${this.state.count} times`;
    }
}
```

You can tell React to skip applying an effect if certain values haven’t changed between re-renders. To do so, pass an
array as an optional second argument to `useEffect`:

```tsx
useEffect(() => {
    document.title = `You clicked ${count} times`;
}, [count]); // Only re-run the effect if count changes
```

In the example above, we pass [count] as the second argument. What does this mean? If the count is 5, and then our
component re-renders with count still equal to 5, React will compare [5] from the previous render and [5] from the next
render. Because all items in the array are the same (5 === 5), React would skip the effect. That’s our optimization.

When we render with count updated to 6, React will compare the items in the [5] array from the previous render to items
in the [6] array from the next render. This time, React will re-apply the effect because 5 !== 6. If there are multiple
items in the array, React will re-run the effect even if just one of them is different.

This also works for effects that have a cleanup phase:

```tsx
useEffect(() => {
    function handleStatusChange(status) {
        setIsOnline(status.isOnline);
    }

    ChatAPI.subscribeToFriendStatus(props.friend.id, handleStatusChange);
    return () => {
        ChatAPI.unsubscribeFromFriendStatus(props.friend.id, handleStatusChange);
    };
}, [props.friend.id]); // Only re-subscribe if props.friend.id changes
```

If you use this optimization, make sure the array includes all values from the component scope (such as props and state)
that change over time and that are used by the effect.

If you want to run an effect and clean it up only once (on mount and unmount), you can pass an empty array ([]) as a
second argument. If you pass an empty array ([]), the props and state inside the effect will always have their initial
values.
