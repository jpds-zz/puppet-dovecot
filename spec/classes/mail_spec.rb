require 'spec_helper'

describe 'dovecot::mail', :type => 'class' do
  let :pre_condition do
    'include dovecot'
  end

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

    it { should contain_file('/etc/dovecot/conf.d/10-mail.conf').with(
        'ensure' => 'present',
        'path'   => '/etc/dovecot/conf.d/10-mail.conf',
        'mode'   => '0644',
        'owner'  => 'root',
        'group'  => 'root',
        'notify' => 'Class[Dovecot::Service]',
      )
    }

    it {
      should contain_file('/etc/dovecot/conf.d/10-mail.conf') \
        .with_content(/^mail_location = mbox:~\/mail:INBOX=\/var\/mail\/%u/)
    }

    context "with mail_location set" do
      let :params do
        {
          :mail_location => 'maildir:~/Maildir',
        }
      end

      it {
        should contain_file('/etc/dovecot/conf.d/10-mail.conf') \
          .with_content(/^mail_location = maildir:~\/Maildir$/)
      }
    end
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
