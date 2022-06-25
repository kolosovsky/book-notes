Dependency inversion is satisfied by using interfaces in dependencies.

```tsx
interface CoffeeMachine {
    expresso(): void;
}

function CoffeeShop(coffeeMachine: CoffeeMachine) {
    return {
        expresso: () => {
            coffeeMachine.expresso();
        }
    }
}
```

In this example we simply create a CoffeeShop that can make an espresso, the coffee machine implementation can be
changed with another implementation and the `CoffeeShop` would not know the difference.

Let's consider the following example.

```tsx
import axios from "axios";
import * as React from "React";

function PostComponent() {
    const [post, setPost] = React.useState(null);

    axios.get(`url`).then(res => {
        setPost(res.data);
    })

    return post && <div>
        {post.title}
    </div>
}
```

This component is depending on axios.

We could potentially create service http that would depend on axios and then dependency chain would look like:
`PostComponent -> http -> axios` which would still not be what we want.

Also we could pass http as a parameter to the component:

```tsx
<PostComponent http={http}/>
```

which is still not what we want here. Ideally we want to create the http implementation at the app level because in the
future it will require more configuration and we want to create it once. We don’t want to spread this implementation
around the app.

In react we have the Context API that can be used as a Service Locator.

context.ts

```tsx
import { IHttp } from './http.interface';

export const APP_CONTEXT: React.Context<AppContext> = React.createContext(null);

export interface AppContext {
    http: IHttp;
}
```

dependencies.ts

```tsx
import { IHttp } from './http.interface';
import { Http } from './http';

const http: IHttp = Http();
export const appDependencies: AppContext = {
    http: http
}
```

App.ts

```tsx
import * as React from "React";
import { APP_CONTEXT } from './context';
import { appDependencies } from './dependencies'

export function App(): JSX.Element {
    return (
        <APP_CONTEXT.Provider value={appDependencies}>
            <PostComponent/>
        </APP_CONTEXT.Provider>
    );
}
```

PostComponent.tsx

```tsx
import * as React from "React";
import { APP_CONTEXT } from './context';

function PostComponent() {
    const http: IHttp = React.useContext(APP_CONTEXT).http;
    const [post, setPost] = React.useState(null);

    http.get(`url`).then(res => {
        setPost(res.data);
    })

    return post && <div>
        {post.title}
    </div>
}
```

React context allows you to take advantage of dependency inversion. You can provide a different implementation of the
same interface.

Benefits:
- This solution will respect dependency inversion principle
- Unit test will be easier
- Components are not coupled to core libraries
- Switching dependencies is efficient

Disadvantages:
- The creation of dependencies has to be done manually, you don’t have IOC (Inversion of Control)
