```tsx
const id = useId();
```

`useId` is a hook for generating unique IDs that are stable across the server and client, while avoiding hydration
mismatches.

`useId` is not for generating keys in a list. Keys should be generated from your data.

For a basic example, pass the id directly to the elements that need it:

```tsx
function Checkbox() {
    const id = useId();
    return (
        <>
            <label htmlFor={id}>Do you like React?</label>
            <input id={id} type="checkbox" name="react"/>
        </>
    );
};
```

For multiple IDs in the same component, append a suffix using the same id:

```tsx
function NameFields() {
    const id = useId();
    return (
        <div>
            <label htmlFor={id + '-firstName'}>First Name</label>
            <div>
                <input id={id + '-firstName'} type="text"/>
            </div>
            <label htmlFor={id + '-lastName'}>Last Name</label>
            <div>
                <input id={id + '-lastName'} type="text"/>
            </div>
        </div>
    );
}
```

`useId` generates a string that includes the `:` token. This helps ensure that the token is unique, but is not supported
in CSS selectors or APIs like `querySelectorAll`.

`useId` supports an `identifierPrefix` to prevent collisions in multi-root apps. To configure, see the options for
`hydrateRoot` and `ReactDOMServer`.
