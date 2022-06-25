### DIRECT DEPENDENCY (COUPLING)

/services/http.ts

```ts
export class Http {
    get(): Promise<Response> {
        return fetch('url');
    }
}
```

components/component.ts

```ts
import { Http } from '/services/http'

export class Component extends React.Component {
    http: Http;

    constructor() {
        super();
        
        this.http = new Http();
    }
}
```

### DEPENDENCY INJECTION (STILL COUPLING, BUT BETTER)

/services/http.ts

```ts
export class Http {
    get(): Promise<Response> {
        return fetch('url');
    }
}
```

components/component.ts

```ts
export class Component extends React.Component {
    http: Http;

    constructor(http: Http) {
        super();
    }
}
```

components/app.ts

```tsx
import { Component } from 'components/component.ts';
import { Http } from '/services/http'

export class App extends React.Component {
    render() {
        return <Component http={new Http()}/>
    }
}
```

### DEPENDENCY INVERSION (NO COUPLING)

/interfaces/http.ts

```ts
export interface IHttp {
    get(): Promise<Response>;
}
```

/services/http.ts

```ts
import { IHttp } from '/interfaces/http';

export class Http implements IHttp {
    get(): Promise<Response> {
        return fetch('url');
    }
}
```

/app-context.ts
```ts
import { IHttp } from '/interfaces/http';

export interface IAppContext {
    http: IHttp;
}

export const AppContext: React.Context<IAppContext> = React.createContext(null);
```

/dependencies.ts
```ts
import { Http } from '/services/http'

export const appDependencies: AppContext = {
    http: Http(),
}
```

components/app.ts

```tsx
import { Component } from 'components/component.ts';
import { Http } from '/services/http';
import { appDependencies } from '/dependencies.ts';
import { AppContext } from '/app-context.ts';

export class App extends React.Component {
    render() {
        return (
            <AppContext.Provider value={appDependencies}>
                <Component/>
            </AppContext.Provider>
        );
    }
}
```

components/component.ts

```ts
import { AppContext } from '/app-context.ts';

export class Component extends React.Component {
    static contextType = AppContext;
    
    constructor() {
        super();
        
        const http = this.context.http;
    }
}
```
