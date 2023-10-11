## brew deps

```
# prettier
brew install prettierd
# docker linting 
brew install hadolint

# toml,markdown,dockerfile formtting
brew install dprint

```

# Set up formatting for toml, markdown, dockerfile
per project (in project root):
``` dprint init --config .dprint.jsonc```

## Java Debugging and Testing

```sh
git clone git@github.com:microsoft/java-debug.git
cd java-debug/
./mvnw clean install
```

```sh
git clone git@github.com:microsoft/vscode-java-test.git
cd vscode-java-test
npm install
npm run build-plugin
```

## Testing with neotest and rust

### Install cargo-nextest
```cargo install cargo-nextest --locked```
