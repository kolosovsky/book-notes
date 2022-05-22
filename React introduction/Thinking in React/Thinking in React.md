One of the many great parts of React is how it makes you think about apps as you build them.

**Step 1: Break The UI Into A Component Hierarchy**

The first thing you’ll want to do is to draw boxes around every component (and subcomponent) in a design mock and give
them all names.

But how do you know what should be its own component? Use the same techniques for deciding if you should create a new
function or object. One such technique is the single responsibility principle, that is, a component should ideally only
do one thing. If it ends up growing, it should be decomposed into smaller subcomponents.

Since you’re often displaying a JSON data model to a user, you’ll find that if your model was built correctly, your UI (
and therefore your component structure) will map nicely. That’s because UI and data models tend to adhere to the same
information architecture.

**Step 2: Build A Static Version in React**

```tsx
class ProductCategoryRow extends React.Component {
    render() {
        const category = this.props.category;
        return (
            <tr>
                <th colSpan="2">
                    {category}
                </th>
            </tr>
        );
    }
}

class ProductRow extends React.Component {
    render() {
        const product = this.props.product;
        const name = product.stocked ?
            product.name :
            <span style={{color: 'red'}}>
        {product.name}
      </span>;

        return (
            <tr>
                <td>{name}</td>
                <td>{product.price}</td>
            </tr>
        );
    }
}

class ProductTable extends React.Component {
    render() {
        const rows = [];
        let lastCategory = null;

        this.props.products.forEach((product) => {
            if (product.category !== lastCategory) {
                rows.push(
                    <ProductCategoryRow
                        category={product.category}
                        key={product.category}/>
                );
            }
            rows.push(
                <ProductRow
                    product={product}
                    key={product.name}/>
            );
            lastCategory = product.category;
        });

        return (
            <table>
                <thead>
                <tr>
                    <th>Name</th>
                    <th>Price</th>
                </tr>
                </thead>
                <tbody>{rows}</tbody>
            </table>
        );
    }
}

class SearchBar extends React.Component {
    render() {
        return (
            <form>
                <input type="text" placeholder="Search..."/>
                <p>
                    <input type="checkbox"/>
                    {' '}
                    Only show products in stock
                </p>
            </form>
        );
    }
}

class FilterableProductTable extends React.Component {
    render() {
        return (
            <div>
                <SearchBar/>
                <ProductTable products={this.props.products}/>
            </div>
        );
    }
}


const PRODUCTS = [
    {category: 'Sporting Goods', price: '$49.99', stocked: true, name: 'Football'},
    {category: 'Sporting Goods', price: '$9.99', stocked: true, name: 'Baseball'},
    {category: 'Sporting Goods', price: '$29.99', stocked: false, name: 'Basketball'},
    {category: 'Electronics', price: '$99.99', stocked: true, name: 'iPod Touch'},
    {category: 'Electronics', price: '$399.99', stocked: false, name: 'iPhone 5'},
    {category: 'Electronics', price: '$199.99', stocked: true, name: 'Nexus 7'}
];

const root = ReactDOM.createRoot(document.getElementById('container'));
root.render(<FilterableProductTable products={PRODUCTS}/>);
```

Now that you have your component hierarchy, it’s time to implement your app. The easiest way is to build a version that
takes your data model and renders the UI but has no interactivity. It’s best to decouple these processes.

`props` are a way of passing data from parent to child. If you’re familiar with the concept of `state`, don’t use `state` at
all to build this static version. `State` is reserved only for interactivity, that is, data that changes over time. Since
this is a static version of the app, you don’t need it.

You can build top-down or bottom-up. In simpler examples, it’s usually easier to go top-down, and on larger projects,
it’s easier to go bottom-up and write tests as you build.

**Step 3: Identify The Minimal (but complete) Representation Of UI State**

To make your UI interactive, you need to be able to trigger changes to your underlying data model. React achieves this
with `state`.

To build your app correctly, you first need to think of the minimal set of mutable `state` that your app needs. The key
here is DRY: Don’t Repeat Yourself. Figure out the absolute minimal representation of the `state` your application needs
and compute everything else you need on-demand. For example, if you’re building a TODO list, keep an array of the TODO
items around; don’t keep a separate `state` variable for the count. Instead, when you want to render the TODO count, take
the length of the TODO items array.

Let’s go through each one and figure out which one is `state`. Ask three questions about each piece of data:

1. Is it passed in from a parent via `props`? If so, it probably isn’t `state`.
2. Does it remain unchanged over time? If so, it probably isn’t `state`.
3. Can you compute it based on any other `state` or `props` in your component? If so, it isn’t `state`.

**Step 4: Identify Where Your State Should Live**

Remember: React is all about one-way data flow down the component hierarchy. It may not be immediately clear which
component should own what `state`. Follow these steps to figure it out:

For each piece of `state` in your application:

- Identify every component that renders something based on that `state`.
- Find a common owner component (a single component above all the components that need the `state` in the hierarchy).
- Either the common owner or another component higher up in the hierarchy should own the `state`.
- If you can’t find a component where it makes sense to own the `state`, create a new component solely for holding the
  `state` and add it somewhere in the hierarchy above the common owner component.

**Step 5: Add Inverse Data Flow**

```tsx
class ProductCategoryRow extends React.Component {
    render() {
        const category = this.props.category;
        return (
            <tr>
                <th colSpan="2">
                    {category}
                </th>
            </tr>
        );
    }
}

class ProductRow extends React.Component {
    render() {
        const product = this.props.product;
        const name = product.stocked ?
            product.name :
            <span style={{color: 'red'}}>
        {product.name}
      </span>;

        return (
            <tr>
                <td>{name}</td>
                <td>{product.price}</td>
            </tr>
        );
    }
}

class ProductTable extends React.Component {
    render() {
        const filterText = this.props.filterText;
        const inStockOnly = this.props.inStockOnly;

        const rows = [];
        let lastCategory = null;

        this.props.products.forEach((product) => {
            if (product.name.indexOf(filterText) === -1) {
                return;
            }
            if (inStockOnly && !product.stocked) {
                return;
            }
            if (product.category !== lastCategory) {
                rows.push(
                    <ProductCategoryRow
                        category={product.category}
                        key={product.category}/>
                );
            }
            rows.push(
                <ProductRow
                    product={product}
                    key={product.name}
                />
            );
            lastCategory = product.category;
        });

        return (
            <table>
                <thead>
                <tr>
                    <th>Name</th>
                    <th>Price</th>
                </tr>
                </thead>
                <tbody>{rows}</tbody>
            </table>
        );
    }
}

class SearchBar extends React.Component {
    constructor(props) {
        super(props);
        this.handleFilterTextChange = this.handleFilterTextChange.bind(this);
        this.handleInStockChange = this.handleInStockChange.bind(this);
    }

    handleFilterTextChange(e) {
        this.props.onFilterTextChange(e.target.value);
    }

    handleInStockChange(e) {
        this.props.onInStockChange(e.target.checked);
    }

    render() {
        return (
            <form>
                <input
                    type="text"
                    placeholder="Search..."
                    value={this.props.filterText}
                    onChange={this.handleFilterTextChange}
                />
                <p>
                    <input
                        type="checkbox"
                        checked={this.props.inStockOnly}
                        onChange={this.handleInStockChange}
                    />
                    {' '}
                    Only show products in stock
                </p>
            </form>
        );
    }
}

class FilterableProductTable extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            filterText: '',
            inStockOnly: false
        };

        this.handleFilterTextChange = this.handleFilterTextChange.bind(this);
        this.handleInStockChange = this.handleInStockChange.bind(this);
    }

    handleFilterTextChange(filterText) {
        this.setState({
            filterText: filterText
        });
    }

    handleInStockChange(inStockOnly) {
        this.setState({
            inStockOnly: inStockOnly
        })
    }

    render() {
        return (
            <div>
                <SearchBar
                    filterText={this.state.filterText}
                    inStockOnly={this.state.inStockOnly}
                    onFilterTextChange={this.handleFilterTextChange}
                    onInStockChange={this.handleInStockChange}
                />
                <ProductTable
                    products={this.props.products}
                    filterText={this.state.filterText}
                    inStockOnly={this.state.inStockOnly}
                />
            </div>
        );
    }
}


const PRODUCTS = [
    {category: 'Sporting Goods', price: '$49.99', stocked: true, name: 'Football'},
    {category: 'Sporting Goods', price: '$9.99', stocked: true, name: 'Baseball'},
    {category: 'Sporting Goods', price: '$29.99', stocked: false, name: 'Basketball'},
    {category: 'Electronics', price: '$99.99', stocked: true, name: 'iPod Touch'},
    {category: 'Electronics', price: '$399.99', stocked: false, name: 'iPhone 5'},
    {category: 'Electronics', price: '$199.99', stocked: true, name: 'Nexus 7'}
];

const root = ReactDOM.createRoot(document.getElementById('container'));
root.render(<FilterableProductTable products={PRODUCTS}/>);
```

Let’s think about what we want to happen. We want to make sure that whenever the user changes the form, we update the
`state` to reflect the user input. Since components should only update their own `state`, `FilterableProductTable` will pass
callbacks to `SearchBar` that will fire whenever the `state` should be updated. We can use the `onChange` event on the inputs
to be notified of it. The callbacks passed by `FilterableProductTable` will call `setState()`, and the app will be updated.

