Test Kitchen 1.0 Support
========================

This cookbook includes support for running tests via Test Kitchen 1.0 using either VirtualBox/Vagrant locally,
or in the Rackspace Public Cloud using Fog/Kitchen.


Prerequisites
=============

1. You must be using the Git repository of the cookbook, rather than the downloaded cookbook from the RCB Cookbook Channel.
2. You must have a working Ruby 1.9.3 install.
3. You must have Vagrant 1.2.2 installed to run the `default-vagrant-*` test kitchens. Earlier 1.1.x versions may also work just fine.
4. You must have VirtualBox 4.2.12 installed to run the `default-vagrant-*` test kitchens. Earlier 4.2.x versions may also work just fine.
5. You must have a Rackspace Public Cloud account, api key, and ssh key to run the `default-rackspace-*` test kitchens.


Preparing Vagrant
=================

After installing Vagrant, or if it is already installed, make sure the Berkshelf plugin is installed:

    vagrant plugin install vagrant-berkshelf


Installing Ruby Gems
====================

If you are using your system ruby, you may need to using `sudo` to install the required gems below.
If you are using `rvm`, you may enable the `ruby-version` file to create a custom gemset for testing:

    $ cp .ruby-version.example .ruby-version

To install the required ruby gems, ensure you have `bundler` installed, then run `bundle install`:

    $ [sudo] gem install bundler
    $ [sudo] bundle install

This will install all of the ruby gems required to test the current cookbooks.


Configuring Rackspace Credentials
=================================

If you plan on running the `default-rackspace-*` test kitchens, you will need to configure
kitchen with your Rackspace Public Cloud credentials. To do this, simply copy over the
`.kitchen.local.yml.example` file and edit it:

    $ cp .kitchen.local.yml.example .kitchen.local.yml
    $ vim .kitchen.local.yml

    # .kitchen.local.yml
    driver_config:
      rackspace_username: myusername
      rackspace_api_key: a74bc83bs....
      rackspace_region: ord
      public_key_path: ~/.ssh/id_rsa.pub


Working With Test Kitchens
==========================

You can list all of the available test kitchens by using the `kitchen list` command:

    $ kitchen list
    
    Instance                       Last Action
    default-vagrant-ubuntu-1204    <Not Created>
    default-vagrant-centos-63      <Not Created>
    default-rackspace-ubuntu-1204  <Not Created>
    default-rackspace-centos-63    <Not Created>

Running test kitchens:

    $ kitchen test default-vagrant-ubuntu-1204
    $ kitchen test "default-vagrant-*"
    $ kitchen test
    $ thor kitchen:all  # same as kitchen test

For other kitchen commands, like `login`, see:

    $ kitchen


Running Food Critic
===================

You can run foodcritic directly using the `foodcritic` binary, or using `thor`:

    $ foodcritic .
    $ thor foodcritic:lint  # same as foodcritic .


Running Tailor
==============

You can run tailor directly using the `tailor` binary, or using `thor`:

    $ tailor .
    $ thor tailor:lint  # same as tailor **/*.rb


Running All Tests
=================

To run all tests, include tailor, foodcritic, knife cookbook test, chefspecs, and test kitchens:

    $ ./test/test.sh
