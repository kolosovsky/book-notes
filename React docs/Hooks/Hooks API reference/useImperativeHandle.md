First, take a look at the following example:

```tsx
const ChildComponent = forwardRef((props, ref) => {
    // ref is only accessible as a second argument here (it is not present in props.ref) 
    // see forwardRef documentation for details

    const createHandle = () => ({
        doSomething: () => {
            // triggered by clicking on the button from ParentComponent
            // do whatever you want here
        },
    });

    useImperativeHandle(ref, createHandle);

    return <input {...props}/>
});

const ParentComponent = () => {
    const ref = useRef(null); // ref.current's will be overridden by whatever returned from createHandle

    return (
        <div>
            <ChildComponent ref={ref}/>
            <button onClick={() => ref?.current?.doSomething()}>Focus!</button>
        </div>
    )
};
```

`useImperativeHandle` customizes the instance value that is exposed to parent components when using `ref`. As always,
imperative code using refs should be avoided in most cases. `useImperativeHandle` should be used with `forwardRef`.
