# Styles
We use Bootstrap 4 as the style framework

## 1. Setup Bootstrap
### 1.1. `package.json`
Install `bootstrap`, `jquery` and `tether` in `dependencies`.
Install `node-sass`, `sass-loader` in `devDependencies.

### 1.2. `webpack.base.conf.js`
Add the `jquery` and `tether` to the plugins.

```js
var webpack = require('webpack')

plugins: [
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Tether: 'tether'
  })
]
```

### 1.3. `main.ts`
Import the following two files in the entry file `main.ts`.

```js
import 'bootstrap/dist/js/bootstrap'
import './styles/style.scss'
```

## 2. Bootstrap Styles
We use bootstrap 4 to style the web site. All component styles are kept with their components. For customized variables/mixins, we create a `_custom.scss` file. To use the defined variables/mixins, we create a `_init.scss` file that has the following content: 

```
@import "~bootstrap/scss/variables";
@import "~bootstrap/scss/mixins";
@import "./custom";
```

A component use `@import "~src/styles/init";` to import all defined variables/mixins without increase bundle size of a css file. 

The `src/styles/style.scss` is the root style file that only import two files:

```
// import from node_module
@import "~bootstrap/scss/bootstrap";

// import ./_custom.scss.
// files with a "_" prefix is not compiled by scss
@import "./custom";
```

## 3. Font Awesome

First install font-awesome package using `yarn add font-awesome`.

Then add the following content to `styles/style.scss`:

```
// import font-awesome
$fa-font-path: "~font-awesome/fonts";
@import "~font-awesome/scss/font-awesome";
```

Now all font-awesome icons can be used. 