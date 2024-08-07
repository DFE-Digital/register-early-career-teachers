# Setup

## Codespaces

The quickest way to get up and running with the ECF2 application is to use a [Codespace](https://github.com/features/codespaces). Just click 'Code', 'Create codespace on main' and wait for a minute while everything's installed for you. Once it's done you should be able to type `bin/dev` in your terminal window and the app will run.

## Running it on your computer

### Prerequisites

* Ruby 3.3.4 (via [rbenv](https://github.com/rbenv/rbenv), [rvm](https://github.com/rvm/rvm), or [asdf](https://github.com/asdf-vm/asdf))
* NodeJS (via [fnm](https://github.com/Schniz/fnm), [nvm](https://github.com/nvm-sh/nvm) or asdf)
* PostgreSQL (via your package manager or [Postgres.app](https://postgresapp.com/))

You'll need to set up some environment variables too. You can do that securely with [direnv](https://direnv.net/).

#### Preparing your database user

When running the app locally for development purposes we'll often want to drop and recreate the database, so we need to use a superuser.

This assumes your username is `joey`. You can check yours by running `whoami`

1. Ensure PostgreSQL is installed and running
2. Change to the `postgres` user with `sudo su -l postgres`
3. As the `postgres` user:
    1. Create a database user with the same name as your main main login, i.e., `createuser --superuser joey`
    2. Edit the `pg_hba.conf` file (found in the data directory in the `postgres` user's home) and add this line to the table at the bottom - this trusts all local connections. It's permissive but fine for development purposes.
       ```
       local   all             all                                     trust
       host    all             all             127.0.0.1/32            trust
       ```
    3. log out (type `exit`)
4. Restart PostgreSQL.

   On Linux this will be something like `sudo systemctl restart postgresql.service`

   On Mac, if you installed with Homebrew, run `brew services restart postgres`. If you installed Postgres.app, right click on the icon in the control centre and click 'Restart server'
5. Now we can test our user account is working properly. By default, running the `postgres` command with no arguments will connect with your username to a database named after your username (i.e. it will connect with the user `joey` to a database called `joey`).

   We should be able to create a database with `createdb joey`

   Then, running `psql` should connect and give us a prompt like this:

   ```
   $ psql

   psql (16.3)
   Type "help" for help.

   joey=#
   ```

   If that worked, we're done. You can quit the database prompt with `\q` or by pressing `ctrl+d`


### Installing dependencies

Once you have Ruby and NodeJS installed we're ready to install the application's dependencies.

We can do this in one step with `bin/setup`:

```bash
$ bin/setup

# == Installing dependencies ==
# The Gemfile's dependencies are satisfied
#
# up to date, audited 22 packages in 932ms
#
# found 0 vulnerabilities
#
# == Preparing database ==
# Created database 'ecf2_development'
# Created database 'ecf2_test'
#
# == Removing old logs and tempfiles ==
#
# == Restarting application server ==
```

Or you can do each step manually with:

```bash
$ bundle install
$ npm install
$ bundle exec rails db:setup
```

### Running the app

Once all the dependencies are installed we can run the application.

```
$ bin/dev
```

Navigate to [https://localhost:3000](https://localhost:3000) in your browser and if you can see a website, everything's working! 🥳

Go and put the kettle on.
