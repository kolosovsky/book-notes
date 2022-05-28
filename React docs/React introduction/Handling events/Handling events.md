React events are named using camelCase, rather than lowercase and used like this:

```tsx
<button onClick={activateLasers}>
    Activate Lasers
</button>
```

You cannot return false to prevent default behavior in React. You must call preventDefault explicitly.

Event passed to `activateLasers` in the example above is synthetic. React defines these synthetic events according to
the W3C spec, so you don’t need to worry about cross-browser compatibility. React events do not work exactly the same as
native events. See the SyntheticEvent reference guide to learn more.

You have to be careful about the meaning of this in JSX callbacks. If you bind a handler like
this `onClick={this.handleClick}` `this` will be undefined when the function is actually called. To fix it you should
bind that method.

If you are using the experimental public class fields syntax, you can use class fields to correctly bind callbacks:

```tsx
class LoggingButton extends React.Component {
    // This syntax ensures `this` is bound within handleClick.
    // Warning: this is *experimental* syntax.
    handleClick = () => {
        console.log('this is:', this);
    }

    render() {
        return (
            <button onClick={this.handleClick}>
                Click me
            </button>
        );
    }
}
```

Or you can use an arrow function in the callback:

```tsx
render()
{
    // This syntax ensures `this` is bound within handleClick
    return (
        <button onClick={() => this.handleClick()}>
            Click me
        </button>
    );
}
```

The problem with this syntax is that a different callback is created each time the LoggingButton renders. In most cases,
this is fine. However, if this callback is passed as a prop to lower components, those components might do an extra
re-rendering. We generally recommend binding in the constructor or using the class fields syntax, to avoid this sort of
performance problem.

