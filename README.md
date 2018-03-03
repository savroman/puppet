# puppet
Learning Puppet

This Vagrantfile automatically creates master & two agents 

### How to use
1. Clone puppet repo to your working directory.
2. In directory with Vagranfile run "vagrant up".
3. After finishing VM creation run next commands on master machine:
  
  $ sudo /opt/puppetlabs/bin/puppet cert list
  
  $ sudo /opt/puppetlabs/bin/puppet cert sign --all
  
4. Play with puppet :)
