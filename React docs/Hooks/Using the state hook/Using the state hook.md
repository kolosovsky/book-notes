If you used classes in React before, this code should look familiar:

```tsx
class Example extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            count: 0
        };
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

`useState` is a Hook that lets you add React state to function components. In a function component, we have no this, so
we can’t assign or read this.state. Instead, we call the `useState` Hook directly inside our component:

```tsx
import React, { useState } from 'react';

function Example() {
    // Declare a new state variable, which we'll call "count"
    const [count, setCount] = useState(0);
```

We declare a state variable called `count`, and set it to 0. React will remember its current value between re-renders,
and provide the most recent one to our function. If we want to update the current count, we can call `setCount`.

**What does calling `useState` do?** It declares a “state variable”. Our variable is called count but we could call it
anything else, like banana. This is a way to “preserve” some values between the function calls — `useState` is a new way
to use the exact same capabilities that `this.state` provides in a class. Normally, variables “disappear” when the
function exits but state variables are preserved by React.

**What do we pass to `useState` as an argument?** The only argument to the `useState()` Hook is the initial state. Unlike
with classes, the state doesn’t have to be an object. We can keep a number or a string if that’s all we need. In our
example, we just want a number for how many times the user clicked, so pass 0 as initial state for our variable. (If we
wanted to store two different values in state, we would call `useState()` twice.)

**What does `useState` return?** It returns a pair of values: the current state and a function that updates it. This is
why we write `const [count, setCount] = useState()`. This is similar to this.state.count and `this.setState` in a class,
except you get them in a pair.

You don’t have to use many state variables. State variables can hold objects and arrays just fine, so you can still
group related data together. However, unlike `this.setState` in a class, updating a state variable always replaces it
instead of merging it.
