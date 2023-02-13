## Rakish


__Rakish__: *adjective*: having or displaying a dashing, jaunty, or slightly disreputable quality or appearance.
> "he had a rakish, debonair look"

This gem is:
- *Jaunty*, hot-reloading for your application
- *dashing* keep your database connections persistent
- *slightly disreputable* requires \*no changes for production!

\* - this is not quite true, you actually should change one thing. You should disable the hot-reloading for prod. To achieve this you can either drop the reloading middleware or add `DISABLE_RAKISH_RELOAD=true` to your environment.

### What does this actually do?


This is a collection of basic dev-facing niceties I've come to expect from a framework.

- Add zeitwerk's conventional loading to everything in `./lib`
- Hot application code in development, without inducing crashes on any request, dropping connections, or restarting the process.

Conceptually it is fairly simple: your Application reloads, your Config does not.

### Usage

in your gemfile

```ruby
  gem 'rakish'
```

```ruby
# app.rb
require 'rakish'

Rakish.init
Rakish.prep(
  app: -> { Application },
  config: Config
)

# config.ru
require './app.rb'
run Rakish.application
```

per the above:
- `Application` is any rack application (class, not instance)

The provided `app` must be a proc, which accesses your application class constant directly. Thallows zeitwerk to reload it.

- `Config` needs to define "middleware" method, be sure to add `Raskish::ReloadLock` middleware. See `Rakish::Config` for an example.

#### Access

Access to data assigned to the top level is as follows. Only `app` and `config` are special cases.
```ruby
# give this to your rack complient server
Rakish.application

# special cases
Rakish.app           # an instance of your Application, fresh on each call
Rakish.static.app    # the proc you provided
Rakish.config        # an instance of your Config, the same every time
Rakish.static.app    # the Config class you provided

# all other access remains the same
# i.e. if you Rakish.register(:foo, 123)
Rakish.foo        # 123
Rakish.static.foo # 123
```

#### Caveats

Due to how zeitwerk reloading works, you might want to call `Rakish.config` instead of referencing your own `Config` directly to prevent reloading.

If you update your Config, restart the process.
