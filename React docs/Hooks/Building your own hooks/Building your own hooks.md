A custom Hook is a JavaScript function whose name starts with `use` and that may call other Hooks. For example,
`useFriendStatus` below is our first custom Hook:

```tsx
import { useState, useEffect } from 'react';

function useFriendStatus(friendID) {
    const [isOnline, setIsOnline] = useState(null);

    useEffect(() => {
        function handleStatusChange(status) {
            setIsOnline(status.isOnline);
        }

        ChatAPI.subscribeToFriendStatus(friendID, handleStatusChange);
        return () => {
            ChatAPI.unsubscribeFromFriendStatus(friendID, handleStatusChange);
        };
    });

    return isOnline;
}
```

Just like in a component, make sure to only call other Hooks unconditionally at the top level of your custom Hook. e can
decide what it takes as arguments, and what, if anything, it should return. In other words, it’s just like a normal
function.

Now that we’ve extracted this logic to a useFriendStatus hook, we can just use it:

```tsx
function FriendStatus(props) {
    const isOnline = useFriendStatus(props.friend.id);

    if (isOnline === null) {
        return 'Loading...';
    }
    return isOnline ? 'Online' : 'Offline';
}
```

**Do two components using the same Hook share state?** No. Custom Hooks are a mechanism to reuse stateful logic (such as
setting up a subscription and remembering the current value), but every time you use a custom Hook, all state and
effects inside of it are fully isolated.

What if we could write a `useReducer` Hook that lets us manage the local state of our component with a reducer? A
simplified version of it might look like this:

```tsx
function useReducer(reducer, initialState) {
    const [state, setState] = useState(initialState);

    function dispatch(action) {
        const nextState = reducer(state, action);
        setState(nextState);
    }

    return [state, dispatch];
}
```

Now we could use it in our component, and let the reducer drive its state management:

```tsx
function Todos() {
    const [todos, dispatch] = useReducer(todosReducer, []);

    function handleAddClick(text) {
        dispatch({type: 'add', text});
    }

    // ...
}
```

What if we could write a `useReducer` Hook that lets us manage the local state of our component with a reducer? A
simplified version of it might look like this:

```tsx
function useReducer(reducer, initialState) {
    const [state, setState] = useState(initialState);

    function dispatch(action) {
        const nextState = reducer(state, action);
        setState(nextState);
    }

    return [state, dispatch];
}
```

and then use it like this:

```tsx
function todosReducer(state, action) {
    switch (action.type) {
        case 'add':
            return [...state, {
                text: action.text,
                completed: false
            }];
        // ... other actions ...
        default:
            return state;
    }
}

function Todos() {
    const [todos, dispatch] = useReducer(todosReducer, []);

    function handleAddClick(text) {
        dispatch({type: 'add', text});
    }

    // ...
}
```

The need to manage local state with a reducer in a complex component is common enough that we’ve built the `useReducer`
Hook right into React.
