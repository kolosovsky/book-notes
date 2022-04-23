Below, we loop through the numbers array using the JavaScript `map()` function. We return a `<li>` element for each
item. Finally, we assign the resulting array of elements to `listItems`:

```tsx
const numbers = [1, 2, 3, 4, 5];
const listItems = numbers.map((number) =>
    <li>{number}</li>
);
```

Then, we can include the entire `listItems` array inside a `<ul>` element:

```tsx
<ul>{listItems}</ul>
```

Keys help React identify which items have changed, are added, or are removed. Keys should be given to the elements
inside the array to give the elements a stable identity:

```tsx
const numbers = [1, 2, 3, 4, 5];
const listItems = numbers.map((number) =>
    <li key={number.toString()}>
        {number}
    </li>
);
```

The best way to pick a key is to use a string that uniquely identifies a list item among its siblings. Most often you
would use IDs from your data as keys:

```tsx
const todoItems = todos.map((todo) =>
    <li key={todo.id}>
        {todo.text}
    </li>
);
```

When you don’t have stable IDs for rendered items, you may use the item index as a key as a last resort:

```tsx
const todoItems = todos.map((todo, index) =>
    // Only do this if items have no stable IDs
    <li key={index}>
        {todo.text}
    </li>
);
```

We don’t recommend using indexes for keys if the order of items may change. This can negatively impact performance and
may cause issues with component state. If you choose not to assign an explicit key to list items then React will default
to using indexes as keys, also you’ll be given a warning that a key should be provided for list items.

In the following example you should keep the key on the `<ListItem />` elements in the array rather than on the `<li>`
element in the `ListItem` itself:

```tsx
function ListItem(props) {
    // Correct! There is no need to specify the key here:
    return <li>{props.value}</li>;
}

function NumberList(props) {
    const numbers = props.numbers;
    const listItems = numbers.map((number) =>
        // Correct! Key should be specified inside the array.
        <ListItem key={number.toString()} value={number}/>
    );
    return (
        <ul>
            {listItems}
        </ul>
    );
}
```

Keys used within arrays should be unique among their siblings. However, they don’t need to be globally unique.

Keys serve as a hint to React but they don’t get passed to your components. If you need the same value in your
component, pass it explicitly as a prop with a different name:

```tsx
const content = posts.map((post) =>
    <Post
        key={post.id}
        id={post.id}
        title={post.title}/>
);
```

With the example above, the Post component can read `props.id`, but not `props.key`.

`JSX` allows embedding any expression in curly braces so we could inline the `map()` result:
```tsx
function NumberList(props) {
  const numbers = props.numbers;
  return (
    <ul>
      {numbers.map((number) =>
        <ListItem key={number.toString()}
                  value={number} />
      )}
    </ul>
  );
}
```
