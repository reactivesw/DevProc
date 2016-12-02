# Coding Style

## Overivew
If there is no strong good reason, we just follow the [JavaScript Standard Style](https://github.com/feross/standard) and [AirBnb CSS and SASS Style](https://github.com/airbnb/css). (css lint is not available yet, can't find a acceptable way to lint both .scss and .vue files.) Anything not follow these styles should be explicitly documented here. 

## ES6 Syntax
Follow the suggestion in http://es6-features.org/. For example, use shorthand to define properties and methods. 

```js
obj = {
    x, 
    y,
    foo (a, b) {
        …
    },
    bar (x, y) {
        …
    },
    *quux (x, y) {
        …
    }
}
```

