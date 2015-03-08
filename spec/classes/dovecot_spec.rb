require 'spec_helper'

describe 'dovecot', :type => 'class' do
  context "on a Debian OS" do
    let :facts do
      {
        :id             => 'root',
        :is_pe          => false,
        :osfamily       => 'Debian',
        :concat_basedir => '/dne',
        :path           => '/usr/sbin:/usr/bin:/sbin:/bin',
      }
    end

    it { should compile }

    it {
      should contain_package('dovecot-core') \
        .that_comes_before('File[dovecot_dir]')
    }

    it {
      should contain_package('dovecot-core') \
        .that_comes_before('File[/etc/dovecot/dovecot.conf]')
    }

    it { should contain_file('dovecot_dir').with(
        'ensure' => 'directory',
        'path'   => '/etc/dovecot',
        'mode'   => '0755',
        'owner'  => 'root',
        'group'  => 'root',
      )
    }

    it { should contain_file('/etc/dovecot/dovecot.conf').that_requires('Package[dovecot-core]') }
    
    it {
      should contain_file('/etc/dovecot/dovecot.conf').with(
        'ensure' => 'present',
        'mode'   => '0644',
        'owner'  => 'root',
        'group'  => 'root',
        'notify' => 'Class[Dovecot::Service]',
      )
    }

    it {
      should contain_file('/etc/dovecot/dovecot.conf') \
        .without_content(/^protocols = imaps$/)
    }

    context "with IMAP enabled" do
      let :params do
        {
          :enable_imap => true,
          :protocols => 'imaps',
        }
      end

      it {
        should contain_package('dovecot-imapd')
      }

      it {
        should contain_file('/etc/dovecot/dovecot.conf') \
          .with_content(/^protocols = imaps$/)
      }

      it {
        should contain_file('/etc/dovecot/dovecot.conf') \
          .without_content(/^protocols = pop3$/)
      }
    end
    context "with login greeting set" do
      let :params do
        {
          :login_greeting => 'Dovecot at imap.example.com.',
        }
      end
    
      it {
        should contain_file('/etc/dovecot/dovecot.conf') \
          .with_content(/^login_greeting = Dovecot at imap\.example\.com\.$/)
      }
    end
  end

  context "on a Red Hat OS" do
    let :facts do
      {
        :id             => 'root',
        :is_pe          => false,
        :osfamily       => 'RedHat',
        :concat_basedir => '/dne',
        :path           => '/usr/sbin:/usr/bin:/sbin:/bin',
      }
    end

    it { should compile }
    it {
      should contain_package('dovecot') \
        .that_comes_before('File[dovecot_dir]')
      should contain_package('dovecot') \
        .that_comes_before('File[/etc/dovecot/dovecot.conf]')
    }
    it { should contain_file('dovecot_dir').with(
        'ensure' => 'directory',
        'path'   => '/etc/dovecot',
        'mode'   => '0755',
        'owner'  => 'root',
        'group'  => 'root',
      )
    }
    it {
      should contain_file('/etc/dovecot/dovecot.conf').with(
        'ensure' => 'present',
        'mode'   => '0644',
        'owner'  => 'root',
        'group'  => 'root',
        'notify' => 'Class[Dovecot::Service]',
      )
    }
  end

  context "on an unknown OS" do
    let :facts do
      {
        :osfamily => 'Darwin'
      }
    end

    it {
      expect { should raise_error(Puppet::Error) }
    }
  end

end
