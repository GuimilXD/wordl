# WORDL

## A open-source [Wordle](https://nytimes.com/games/wordle) clone written in Elixir featuring Phoenix LiveView.
![GitHub](https://img.shields.io/github/license/guimilxd/wordl)
![GitHub last commit](https://img.shields.io/github/last-commit/guimilxd/wordl)
![GitHub Repo stars](https://img.shields.io/github/stars/guimilxd/wordl?style=social)

## Demo

You can play it here: https://wordl-liveview.herokuapp.com

![Demo Image](https://user-images.githubusercontent.com/60893025/178378520-1b178a85-5473-418b-bd31-124cc2bc0e4b.gif)

## Introduction

Wordl is a web-based word game where the player must guess a word using the given feedback from previous atempts. 

It features:

- Unlimited Play (Words are choosen randomly from a dictionary)
- Quick Restart (Press Enter to restart)
- Multiple Dictionaries Support


## Development Setup
### Prerequisites
**This project requires [Elixir](https://elixir-lang.org)! If you don't have it installed, refer to [this guide](https://elixir-lang.org/install.html).**

### Setting Up A Local Instance
1. Clone this repo and change into its directory:
```sh
git clone https://github.com/GuimilXD/wordl.git
cd wordl
```
2. Install dependencies with [Mix](https://elixir-lang.org/getting-started/mix-otp/introduction-to-mix.html):
```sh
mix deps.get
```
3. Create and Migrate the Database:

**WARNING: Be sure that you have a running [PostgreSQL](https://www.postgresql.org/) instance running! If you're having problems connecting to the database, refer to [Phoenix's official guide](https://hexdocs.pm/phoenix/mix_tasks.html#mix-ecto-create)!**
```sh
mix ecto.create && mix.ecto.migrate
```
4. (Optional) Run all tests and verify they pass:
```sh
mix test
```

5. Start the server:
```sh
mix phx.server
```
**Done! You can now navigate to http://localhost:4000 and start playing Wordl!**

## Known Issues

**WARNING: This project is a LiveView Demo. Therefore, performance is not a concern (at least for now).**

I'm well aware that sending keystrokes over the wire and handling them is the LiveView is not optimal performance-wise.

- No Feedback is given when the user has run out of tries.
- No Mobile Support

## Contributing
Firstly, thank you for having interest in contributing!
**Please, check out [Known Issues](#known-issues) before contributing.**
### Got A Question or Problem?
Before opening a new issue, search your problem online and check if it has already been solved. If you still haven't figured out a solution yet, make sure to open an issue!
### Found A Bug?
If you find any bugs in the code, please take the time to [submit an issue](#submiting-an-issue) to this repository. Even better, you can [submit a pull request](#submiting-a-pull-request-pr) with a fix!
### Submiting An Issue
Before you submit an issue, please search the issue tracker. An issue for your problem might already exist and the discussion might inform you of workarounds readily available.

Before fixing a bug, it's important for contributors to reproduce and confirm it. In order to reproduce bugs, it's required that you provide a minimal reproduction. Having a minimal reproducible scenario gives us a wealth of important information without going back and forth to you with additional questions.
### Submiting A Pull Request (PR)
Before you submit your Pull Request (PR) consider the following guidelines:

1. Search GitHub for an open or closed PR that relates to your submission. You don't want to duplicate existing efforts.

2. Be sure that an issue describes the problem you're fixing, or documents the design for the feature you'd like to add. Discussing the design upfront helps to ensure that we're ready to accept your work.

3. Fork the guimilxd/wordl repo.

4. In your forked repository, make your changes in a new git branch:
```sh
git checkout -b my-fix-branch main
```

5. Create your patch, including appropriate test cases.

6. Run the full test suite and ensure that all tests pass.

7. Commit your changes using a descriptive commit message that follows [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) conventions.
```sh
git commit --all
```

Note: the optional commit `-a` command line option will automatically "add" and "rm" edited files.

8. Push your branch to GitHub:
```sh 
git push origin my-fix-branch
```

9. In GitHub, send a pull request to wordl:main.

## Credits

Many thanks to Josh Wardle for coming up with the original idea. You check out his implementation [here](https://nytimes.com/games/wordle)!

## License

Wordl is licensed under the terms of the MIT license and is available for free.
