### DIRECT DEPENDENCY (COUPLING)

http.ts

```ts
export class Http {
    get(): Promise<Response> {
        return fetch('url');
    }
}
```

Component.ts

```ts
import { Http } from 'http';
import React from 'react';

export class Component extends React.Component {
    http: Http;

    constructor() {
        super();
        
        this.http = new Http();
    }
}
```

### DEPENDENCY INJECTION (STILL COUPLING, BUT BETTER)

http.ts

```ts
export class Http {
    get(): Promise<Response> {
        return fetch('url');
    }
}
```

Component.ts

```ts
import { Http } from 'http';
import React from 'react';

export class Component extends React.Component {
    http: Http;

    constructor(http: Http) {
        super();
    }
}
```

App.ts

```tsx
import { Component } from 'Component.ts';
import { Http } from 'http'
import React from 'react';

export class App extends React.Component {
    render() {
        return <Component http={new Http()}/>
    }
}
```

### DEPENDENCY INVERSION (NO COUPLING)

interfaces/http.ts

```ts
export interface IHttp {
    get(): Promise<Response>;
}
```

http.ts

```ts
import { IHttp } from './interfaces/http';

export class Http implements IHttp {
    get(): Promise<Response> {
        return fetch('url');
    }
}
```

app-context.ts
```ts
import { IHttp } from './interfaces/http';
import React from 'react';

export interface IAppContext {
    http: IHttp;
}

const defaultContext: IAppContext = {
    http: {
        get(): Promise<Response> {
            return Promise.resolve(new Response());
        }
    }
}

export const AppContext: React.Context<IAppContext> = React.createContext(defaultContext);
```

dependencies.ts
```ts
import { IAppContext } from './app-context';
import { Http } from './http';

export const appDependencies: IAppContext = {
    http: new Http(),
}
```

App.ts

```tsx
import React from 'react';
import { AppContext } from './app-context';
import { Component } from './Component';
import { appDependencies } from './dependencies';

class App extends React.Component {
    render() {
        return (
            <AppContext.Provider value={appDependencies}>
                <Component/>
            </AppContext.Provider>
        );
    }
}

export default App;
```

Component.ts

```ts
import React from 'react';
import { AppContext } from './app-context';

export class Component extends React.Component {
    static contextType = AppContext;

    context!: React.ContextType<typeof AppContext>;

    render() {
        const context = this.context;

        console.log(context.http);

        return (
            <div></div>
        )
    }
}
```
