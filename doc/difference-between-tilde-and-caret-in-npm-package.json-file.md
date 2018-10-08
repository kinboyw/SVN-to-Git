# What's the difference between a tilde (~) and a caret (^) in a npm package.json file?

Written by [Michael Lee](https://michaelsoolee.com/about/) on July 13, 2017

If you use npm to manage packages in your JavaScript application, you’re probably familiar with the package.json file.

```
{
  "devDependencies": {
    "ember-cli": "~2.14.0"
  }
}
```

The syntax is in JSON format where the key is the name of the package and the value is the version of the package to be used.

npm uses the package.json file to specify the version of a package that your app depends on.

The version number is in [semver syntax](http://semver.org/) which designates each section with different meaning. semver is broken into three sections separated by a dot.

```
major.minor.patch

1.0.2
```

Major, minor and patch represent the different releases of a package.

npm uses the tilde (~) and caret (^) to designate which patch and minor versions to use respectively.

So if you see `~1.0.2` it means to install version `1.0.2` or the latest patch version such as `1.0.4`. If you see `^1.0.2` it means to install version `1.0.2` or the latest minor or patch version such as `1.1.0`.