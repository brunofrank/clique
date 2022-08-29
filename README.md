# CLIQUE

To improve

### 🔨 Dev-tool utility

We have a developer tools - a utility command line script - to make the developer life easier when using `docker` and `docker-compose`.
It's a list of simple shortcuts (very easy to memorize) to run more complex commands.

In order to install it, follow these steps:

```
cd docker/dev-tools
chmod +x install
./install
```

You then need to reenter your shell session to be able to test it. If it worked, you will be able to run `clq`. This should output the `HELP` command, with every available command you can run, with a short explanation.

#### Notes

In case it didn't work, you can manually add this file to your `bin` folder by running
`sudo cp docker/dev-tools/bin/lds /usr/local/bin`.

Please check the [Cloque developer tools](./dev-tools/README.md) for more information.
