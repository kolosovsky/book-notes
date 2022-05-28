`React components` are made of `React elements`. They are not the same.

The root element:

```html

<div id="root"></div>
```

We call this a “root” DOM node because everything inside it will be managed by React DOM. Applications built with just
React usually have a single root DOM node. If you are integrating React into an existing app, you may have as many
isolated root DOM nodes as you like.

To render a React element, first pass the DOM element to ReactDOM.createRoot(), then pass the React element to
root.render():

```tsx
const element = <h1>Hello, world</h1>;
const root = ReactDOM.createRoot(
    document.getElementById('root')
);
root.render(element);
```

React elements are immutable. Once you create an element, you can’t change its children or attributes.

React DOM compares the element and its children to the previous one, and only applies the DOM updates necessary to bring
the DOM to the desired state.
