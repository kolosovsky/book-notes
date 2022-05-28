Conceptually, components are like JavaScript functions. They accept arbitrary inputs (called “props”) and return React
elements describing what should appear on the screen.

Function component:

```tsx
function Welcome(props) {
    return <h1>Hello, {props.name}</h1>;
}
```

Class component:

```tsx
class Welcome extends React.Component {
    render() {
        return <h1>Hello, {this.props.name}</h1>;
    }
}
```

The above two components are equivalent from React’s point of view.

Elements can also represent user-defined components:

```tsx
const element = <Welcome name="Sara"/>;
```

When React sees an element representing a user-defined component, it passes JSX attributes and children to this
component as a single object. We call this object “props”.

Note: Always start component names with a capital letter. React treats components starting with lowercase letters as DOM
tags. For example, `<div />` represents an HTML div tag, but `<Welcome />` represents a component and requires `Welcome`
to be in scope.

Whether you declare a component as a function or a class, it must never modify its own `props`.

All React components must act like pure functions with respect to their props.




