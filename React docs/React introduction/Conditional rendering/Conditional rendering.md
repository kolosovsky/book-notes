Conditional rendering looks like this:

```tsx
function UserGreeting(props) {
    return <h1>Welcome back!</h1>;
}

function GuestGreeting(props) {
    return <h1>Please sign up.</h1>;
}

function Greeting(props) {
    const isLoggedIn = props.isLoggedIn;
    if (isLoggedIn) {
        return <UserGreeting/>;
    }
    return <GuestGreeting/>;
}

ReactDOM.render(
    // Try changing to isLoggedIn={true}:
    <Greeting isLoggedIn={false}/>,
    document.getElementById('root')
);
```

Another example:

```tsx
render()
{
    const isLoggedIn = this.state.isLoggedIn;
    let button;
    if (isLoggedIn) {
        button = <LogoutButton onClick={this.handleLogoutClick}/>;
    } else {
        button = <LoginButton onClick={this.handleLoginClick}/>;
    }

    return (
        <div>
            <Greeting isLoggedIn={isLoggedIn}/>
            {button}
        </div>
    );
}
```

You may embed expressions in JSX by wrapping them in curly braces. This includes the JavaScript logical && operator. It
can be handy for conditionally including an element:

```tsx
function Mailbox(props) {
    const unreadMessages = props.unreadMessages;
    return (
        <div>
            <h1>Hello!</h1>
            {unreadMessages.length > 0 &&
            <h2>
                You have {unreadMessages.length} unread messages.
            </h2>
            }
        </div>
    );
}
```

Another method for conditionally rendering elements inline is to use the JavaScript conditional operator condition ?
true : false.

```tsx
render()
{
    const isLoggedIn = this.state.isLoggedIn;
    return (
        <div>
            {isLoggedIn
                ? <LogoutButton onClick={this.handleLogoutClick}/>
                : <LoginButton onClick={this.handleLoginClick}/>
            }
        </div>
    );
}
```

In rare cases you might want a component to hide itself even though it was rendered by another component. To do this
return null instead of its render output:

```tsx
function WarningBanner(props) {
    if (!props.warn) {
        return null;
    }

    return (
        <div className="warning">
            Warning!
        </div>
    );
}
```

Returning null from a component’s render method does not affect the firing of the component’s lifecycle methods. For
instance componentDidUpdate will still be called.
