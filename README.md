# omnifocus-pivotaltracker

code: https://github.com/vesan/omnifocus-pivotaltracker

Plugin for omnifocus gem to provide Pivotal Tracker BTS synchronization.

Pulls all (not done) stories from "My Work" for the user specified in the
configuration file and creates corresponding tasks to Omnifocus.

## Usage

1. Install

    $ gem install omnifocus-pivotaltracker

2. Sync

    $ of sync

3. (On the first run, configuration file will be generated at 
   ~/.omnifocus-pivotaltracker.yml. Go and fill your account information.)

## Multi-account support

You can add multiple accounts to the configuration file by using the YAML array
syntax like:

    ---
    -
      :token: aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
      :user_name: muo
    -
      :token: bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
      :user_name: KN

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
