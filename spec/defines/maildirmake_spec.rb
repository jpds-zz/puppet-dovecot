require 'spec_helper'

describe 'dovecot::maildirmake', :type => :define do
  let :pre_condition do
    'include dovecot'
  end

  context "on a Debian OS" do
    describe 'create skel Maildir' do
      let :facts do
        {
          :id             => 'root',
          :is_pe          => false,
          :osfamily       => 'Debian',
          :concat_basedir => '/dne',
          :path           => '/usr/sbin:/usr/bin:/sbin:/bin',
        }
      end

      let(:title) { 'skel-maildir' }
      let :params do
        {
          :directory => '/etc/skel/Maildir',
          :user      => 'root',
        }
      end

      it {
        should contain_exec('maildirmake.dovecot-/etc/skel/Maildir').with(
          'command' => 'maildirmake.dovecot /etc/skel/Maildir && maildirmake.dovecot /etc/skel/Maildir/.Drafts && maildirmake.dovecot /etc/skel/Maildir/.Sent && maildirmake.dovecot /etc/skel/Maildir/.Trash && maildirmake.dovecot /etc/skel/Maildir/.Templates',
          'path'    => '/bin:/usr/bin',
          'user'    => 'root',
          'creates' => '/etc/skel/Maildir',
          'require' => 'Package[dovecot-core]',
         )
       }
    end
  end

  context "on a Red Hat OS" do
    describe 'create skel Maildir' do
      let :facts do
        {
          :id             => 'root',
          :is_pe          => false,
          :osfamily       => 'RedHat',
          :concat_basedir => '/dne',
          :path           => '/usr/sbin:/usr/bin:/sbin:/bin',
        }
      end

      let(:title) { 'skel-maildir' }
      let :params do
        {
          :directory => '/etc/skel/Maildir',
          :user      => 'root',
        }
      end

      it {
        should contain_exec('maildirmake.dovecot-/etc/skel/Maildir').with(
          'command' => 'maildirmake.dovecot /etc/skel/Maildir && maildirmake.dovecot /etc/skel/Maildir/.Drafts && maildirmake.dovecot /etc/skel/Maildir/.Sent && maildirmake.dovecot /etc/skel/Maildir/.Trash && maildirmake.dovecot /etc/skel/Maildir/.Templates',
          'path'    => '/bin:/usr/bin',
          'user'    => 'root',
          'creates' => '/etc/skel/Maildir',
          'require' => 'Package[dovecot]',
         )
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
