`State` is similar to `props`, but it is private and fully controlled by the component.

Let's consider the following component:

```tsx
class Clock extends React.Component {
    constructor(props) {
        super(props);
        this.state = {date: new Date()};
    }

    componentDidMount() {
        this.timerID = setInterval(
            () => this.tick(),
            1000
        );
    }

    componentWillUnmount() {
        clearInterval(this.timerID);
    }

    tick() {
        this.setState({
            date: new Date()
        });
    }

    render() {
        return (
            <div>
                <h1>Hello, world!</h1>
                <h2>It is {this.state.date.toLocaleTimeString()}.</h2>
            </div>
        );
    }
}

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(<Clock/>);

```

The render method will be called each time an update happens.

We want to set up a timer whenever the Clock is rendered to the DOM for the first time. This is called `mounting` in
React. `componentDidMount()` is invoked immediately after a component is mounted (inserted into the tree).

We also want to clear that timer whenever the DOM produced by the Clock is removed. This is called `unmounting` in
React. `componentWillUnmount()` is invoked immediately before a component is unmounted and destroyed.

These methods are called `lifecycle methods`.

Thanks to the `setState()` call, React knows the state has changed, and calls the `render()` method again to learn what
should be on the screen. React doesn't compare `state` data. Although `render()` method of the component is called, the
real DOM is only updated if the output is different from the current DOM tree.

Do not modify `state` directly, use `setState()`. The only place where you can assign `this.state` is the constructor.

`setState()` does not always immediately update the component. It may batch or defer the update until later. Think of
`setState()` as a request rather than an immediate command to update the component. Look at the following example:

```tsx
console.log(this.state.value); // true
this.setState({value: false});
console.log(this.state.value); // still true
```

In the above example `this.state.value` is not changed immediately and `render` is not called immediately as well. This
makes reading `this.state` right after calling `setState()` a potential pitfall. Instead, use `componentDidUpdate`
or a `setState` callback (setState(updater, callback)), either of which are guaranteed to fire after the update has been
applied. Because `this.props` and `this.state` may be updated asynchronously, you should not rely on their values for
calculating the next state. For example, this code may fail to update the counter:

```tsx
// wrong
this.setState({
    counter: this.state.counter + this.props.increment,
});
```

To fix it, use a second form of `setState()` that accepts a function (which is called `updater`) rather than an object:

```tsx
this.setState((state, props) => {
    return {counter: state.counter + props.step};
});
```

`Updater` function will receive both the `state` and the `props` up-to-date at the time the update is applied.

In the rare case that you need to force the DOM update to be applied synchronously, you may wrap it in `flushSync`, but
this may hurt performance.

State updates are merged:

```tsx
componentDidMount()
{
    fetchPosts().then(response => {
        this.setState({
            posts: response.posts
        });
    });

    fetchComments().then(response => {
        this.setState({
            comments: response.comments
        });
    });
}
```

The merging is shallow, so `this.setState({comments})` leaves `this.state.posts` intact, but completely replaces
`this.state.comments`.

A component may choose to pass its state down as props to its child components:

```tsx
<FormattedDate date={this.state.date}/>
```

The `FormattedDate` component would receive the date in its `props` and wouldn’t know whether it came from the parent’s
`state`, from the parent’s `props`, or was typed by hand.

