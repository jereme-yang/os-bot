# OsBot

**OsBot** is a Discord bot designed to streamline Office Hours (OH) queue management. It automates nickname assignment and removal for students joining or leaving the queue, streamlining the process for both students and TAs.

## Features

- Automatically updates student nicknames to indicate queue order. makes it easier to know how many people in queue
- Clears nicknames once a student is helped. No more random numbers
- Built with [Elixir](https://elixir-lang.org/) and [Nostrum](https://github.com/Kraigie/nostrum)

## Installation

### 1. Install Elixir


**macOS (Homebrew):**
```
brew install elixir
```

**Ubuntu/Debian:**
```
sudo apt update
sudo apt install -y elixir
```

**Windows:**
- Download the installer from: https://elixir-lang.org/install.html

Verify installation:
```
elixir --version
```

### 2. Clone the Repository

```
git clone https://github.com/your-username/osbot.git
cd osbot
```

### 3. Install Dependencies

```
mix deps.get
```

This will install all required dependencies, including [Nostrum](https://github.com/Kraigie/nostrum), the Discord library.

> **Note:** You must set your `DISCORD_TOKEN` in your environment or in a `.env` file, depending on how you manage credentials. if you would like to work on this project contact me at jeremeyang@gmail.com and I will send the token

### 4. Launch the Bot
```
iex -S mix
```

This starts the bot with the interactive Elixir shell.

## Production Hosting

The bot is currently hosted by **Jereme Yang** on a personal **AWS EC2 (Free Tier)** instance.  
⚠️ The Free Tier will expire on **November 13, 2025**. After that, a new hosting solution will be needed.

## TODO

1. Find another cloud provider (UF hipergator??)
2. Add analytics to report:
   - Historical peak OH times
   - Average wait times per session
3. Add support for text-based commands and a `#bot-commands` channel for interactive help
