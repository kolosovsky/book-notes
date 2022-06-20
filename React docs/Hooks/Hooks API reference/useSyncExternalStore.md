```tsx
const state = useSyncExternalStore(subscribe, getSnapshot[, getServerSnapshot
])
;
```

`useSyncExternalStore` is a hook recommended for reading and subscribing from external data sources in a way that’s
compatible with concurrent rendering features like selective hydration and time slicing.

This method returns the value of the store and accepts three arguments:

- `subscribe`: function to register a callback that is called whenever the store changes.
- `getSnapshot`: function that returns the current value of the store.
- `getServerSnapshot`: function that returns the snapshot used during server rendering.

The most basic example simply subscribes to the entire store:

```tsx
const state = useSyncExternalStore(store.subscribe, store.getSnapshot);
```

However, you can also subscribe to a specific field:

```tsx
const selectedField = useSyncExternalStore(
    store.subscribe,
    () => store.getSnapshot().selectedField,
);
```

When server rendering, you must serialize the store value used on the server, and provide it to `useSyncExternalStore`.
React will use this snapshot during hydration to prevent server mismatches:

```tsx
const selectedField = useSyncExternalStore(
    store.subscribe,
    () => store.getSnapshot().selectedField,
    () => INITIAL_SERVER_SNAPSHOT.selectedField,
);
```

`getSnapshot` must return a cached value. If `getSnapshot` is called multiple times in a row, it must return the same
exact value unless there was a store update in between.

A shim is provided for supporting multiple React versions published as `use-sync-external-store/shim`. This shim will
prefer `useSyncExternalStore` when available, and fallback to a user-space implementation when it’s not.

As a convenience, we also provide a version of the API with automatic support for memoizing the result of `getSnapshot`
published as `use-sync-external-store/with-selector`.

