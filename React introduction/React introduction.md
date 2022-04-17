JSX syntax, produces `React element`. You can put any valid JavaScript expression inside the curly braces in JSX.

```jsx
const name = 'Josh Perez';
const element = (
    <h1>
        Hello, {name}!
    </h1>
);
```

We split JSX over multiple lines for readability. While it isn’t required, when doing this, we also recommend wrapping
it in parentheses to avoid the pitfalls of automatic semicolon insertion.

You should either use quotes (for string values) or curly braces (for expressions), but not both in the same attribute.

React DOM uses camelCase property naming convention instead of HTML attribute names. For example, `class` becomes
`className` in JSX, and `tabindex` becomes `tabIndex`.

If a tag is empty, you may close it immediately with />, like XML:
```jsx
const element = <img src={user.avatarUrl}/>;
```

JSX Prevents Injection Attacks. By default, React DOM escapes any values embedded in JSX before rendering them. It is
safe to embed user input in JSX:

```jsx
const title = response.potentiallyMaliciousInput;
// This is safe:
const element = <h1>{title}</h1>;
```

Babel compiles JSX down to React.createElement() calls. These two examples are identical:
```jsx
const element = (
    <h1 className="greeting">
        Hello, world!
    </h1>
);
```
```jsx
const element = React.createElement(
    'h1',
    {className: 'greeting'},
    'Hello, world!'
);
```

React.createElement() performs a few checks to help you write bug-free code but essentially it creates an object like
this:
```jsx
// Note: this structure is simplified
const element = {
    type: 'h1',
    props: {
        className: 'greeting',
        children: 'Hello, world!'
    }
};
```

These objects are called `React elements`.
